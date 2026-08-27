pragma ComponentBehavior: Bound

import QtQuick
import qs.services

/**
 * Local-only task contract for the assistant.
 *
 * Tasks live in the local JSON store (Todo). No external provider is
 * consulted. Every mutation funnels through the local task list.
 */
QtObject {
    id: root

    readonly property string localProviderId: "local"
    property var pendingOperations: ({})

    signal resultReady(string key, string operationId, var outcome)

    function providerInfo(providerId) {
        const id = String(providerId ?? "");
        if (id === root.localProviderId)
            return { id: id, name: qsTr("Local tasks"), accountId: qsTr("This device"), available: true };
        return null;
    }

    function availableProviders() {
        return [root.providerInfo(root.localProviderId)];
    }

    function resolveProvider(requested) {
        const wanted = String(requested ?? "").trim();
        const id = wanted.length > 0 ? wanted : root.localProviderId;
        const provider = root.providerInfo(id);
        if (!provider)
            return { ok: false, error: "Unknown task provider", provider: id };
        if (!provider.available)
            return { ok: false, error: "That task provider is not connected", provider: id };
        return { ok: true, provider: provider };
    }

    function listTaskLists(providerId) {
        const resolved = root.resolveProvider(providerId);
        if (!resolved.ok)
            return resolved;
        return { ok: true, provider: resolved.provider, lists: Todo.aiListTaskLists() };
    }

    function dueDate(raw) {
        const value = String(raw ?? "").trim();
        if (value.length === 0)
            return { value: null, display: qsTr("No due date") };
        const date = new Date(value);
        if (isNaN(date.getTime()))
            return { error: "Due date must be an ISO date or date-time" };
        return {
            value: date.toISOString(),
            display: date.toLocaleString()
        };
    }

    function normalizeCreate(args) {
        const resolved = root.resolveProvider(args?.provider);
        if (!resolved.ok)
            return resolved;
        const title = String(args?.title ?? "").trim();
        if (title.length === 0)
            return { ok: false, error: "A task needs a title" };
        if (title.length > 500)
            return { ok: false, error: "Task title is too long" };
        const date = root.dueDate(args?.dueDate);
        if (date.error)
            return { ok: false, error: date.error };
        return {
            ok: true,
            provider: resolved.provider,
            providerId: resolved.provider.id,
            accountId: resolved.provider.accountId,
            listId: String(args?.listId ?? Todo.aiListId),
            listName: qsTr("Local tasks"),
            title: title,
            notes: String(args?.notes ?? "").slice(0, 4000),
            dueDate: date.value,
            dueDateDisplay: date.display,
            priority: args?.priority === undefined ? undefined : Number(args.priority)
        };
    }

    function normalizeRef(args) {
        const resolved = root.resolveProvider(args?.provider);
        if (!resolved.ok)
            return resolved;
        const taskId = String(args?.taskId ?? "").trim();
        if (taskId.length === 0)
            return { ok: false, error: "A real task id is required" };
        return {
            ok: true,
            provider: resolved.provider,
            providerId: resolved.provider.id,
            accountId: resolved.provider.accountId,
            listId: String(args?.listId ?? Todo.aiListId),
            taskId: taskId
        };
    }

    function mapTask(raw, provider) {
        const task = raw ?? ({});
        const id = String(task.taskId ?? task.id ?? "");
        const title = String(task.title ?? task.content ?? "");
        return {
            provider: provider.id,
            accountId: provider.accountId,
            listId: String(task.listId ?? task.projectId ?? Todo.aiListId),
            listName: qsTr("Local tasks"),
            taskId: id,
            title: title,
            notes: String(task.notes ?? task.desc ?? ""),
            dueLocal: task.dueDate ?? (task.hasDate ? new Date(task.date).toISOString() : null),
            status: task.done === true || task.status === 2 ? "completed" : "open"
        };
    }

    function listTasks(args, key) {
        const resolved = root.resolveProvider(args?.provider);
        if (!resolved.ok)
            return { status: "error", summary: resolved.error, data: resolved, retryable: true };
        const tasks = Todo.aiListTasks({ query: args?.query, listId: args?.listId, includeCompleted: args?.includeCompleted === true })
            .slice(0, Math.max(1, Math.min(50, Number(args?.limit ?? 50))));
        return {
            status: "success",
            summary: qsTr("%1 local tasks").arg(tasks.length),
            data: { provider: resolved.provider, tasks: tasks.map(task => root.mapTask(task, resolved.provider)) }
        };
    }

    function searchTasks(args, key) {
        return root.listTasks(args, key);
    }

    function providerOutcome(job, operation, raw) {
        const base = job.input ?? ({});
        if (operation === "list") {
            const rawTasks = Array.from(raw?.tasks ?? []);
            const query = String(job.filters?.query ?? "").trim().toLowerCase();
            const tasks = rawTasks.map(task => root.mapTask(task, job.provider)).filter(task => {
                if (job.filters?.includeCompleted !== true && task.status === "completed")
                    return false;
                if (String(job.filters?.listId ?? "").length > 0 && String(job.filters.listId) !== task.listId)
                    return false;
                if (query.length === 0)
                    return true;
                return task.title.toLowerCase().includes(query) || task.notes.toLowerCase().includes(query);
            }).slice(0, Math.max(1, Math.min(50, Number(job.filters?.limit ?? 50))));
            return {
                status: "success",
                summary: qsTr("%1 tasks").arg(tasks.length),
                data: { provider: job.provider, tasks: tasks },
                operationId: String(job.operationId ?? ""),
                retryable: false
            };
        }
        const rawTask = raw?.task ?? raw;
        const taskSource = (rawTask?.id ?? rawTask?.taskId)
            ? rawTask
            : Object.assign({}, base, rawTask ?? ({}));
        const task = operation === "delete"
            ? root.mapTask(base, job.provider)
            : root.mapTask(taskSource, job.provider);
        return {
            status: "success",
            summary: operation === "create" ? qsTr("Task created in %1").arg(job.provider.name) : qsTr("Task updated in %1").arg(job.provider.name),
            data: { provider: job.provider, operation: operation, task: task, taskId: task.taskId },
            operationId: String(job.operationId ?? ""),
            retryable: false
        };
    }

    function createTask(args, key, operationId) {
        const input = root.normalizeCreate(args);
        if (!input.ok)
            return { status: "error", summary: input.error, data: input, retryable: true };
        const result = Todo.aiCreateTask(input);
        return result.ok
            ? { status: "success", summary: qsTr("Task created locally"), data: { provider: input.provider, task: root.mapTask(result.task, input.provider), taskId: result.task.id }, operationId: operationId, retryable: false }
            : { status: "error", summary: result.error, data: result, retryable: false };
    }

    function updateTask(args, key, operationId) {
        const ref = root.normalizeRef(args);
        if (!ref.ok)
            return { status: "error", summary: ref.error, data: ref, retryable: true };
        const changes = {
            title: args?.title,
            notes: args?.notes,
            dueDate: args?.dueDate
        };
        const result = Todo.aiUpdateTask(ref, changes);
        return result.ok
            ? { status: "success", summary: qsTr("Task updated locally"), data: { provider: ref.provider, task: root.mapTask(result.task, ref.provider), taskId: ref.taskId }, operationId: operationId, retryable: false }
            : { status: "error", summary: result.error, data: result, retryable: false };
    }

    function completeTask(args, key, operationId) {
        const ref = root.normalizeRef(args);
        if (!ref.ok)
            return { status: "error", summary: ref.error, data: ref, retryable: true };
        const result = Todo.aiCompleteTask(ref);
        return result.ok
            ? { status: "success", summary: qsTr("Task completed locally"), data: { provider: ref.provider, task: root.mapTask(result.task, ref.provider), taskId: ref.taskId }, operationId: operationId, retryable: false }
            : { status: "error", summary: result.error, data: result, retryable: false };
    }

    function deleteTask(args, key, operationId) {
        const ref = root.normalizeRef(args);
        if (!ref.ok)
            return { status: "error", summary: ref.error, data: ref, retryable: true };
        const result = Todo.aiDeleteTask(ref);
        return result.ok
            ? { status: "success", summary: qsTr("Task deleted locally"), data: { provider: ref.provider, task: root.mapTask(result.task, ref.provider), taskId: ref.taskId }, operationId: operationId, retryable: false }
            : { status: "error", summary: result.error, data: result, retryable: false };
    }
}
