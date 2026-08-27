pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.common
import qs.services

QtObject {
    id: root

    readonly property var tutorials: []

    function tutorialFor(value): var {
        const id = typeof value === "string" ? value : (value ? value.id : "");
        for (let i = 0; i < root.tutorials.length; i++) {
            if (root.tutorials[i].id === id)
                return root.tutorials[i];
        }
        return null;
    }

    function stateFor(value): var {
        const tutorial = root.tutorialFor(value);
        if (!tutorial)
            return ({
                state: "neutral",
                text: Translation.tr("Not configured")
            });

        return {
            state: "neutral",
            text: Translation.tr("Setup required")
        };
    }

    function statusTextFor(value): string {
        return root.stateFor(value).text;
    }

    function stateKindFor(value): string {
        return root.stateFor(value).state;
    }

    function titleFor(tutorial): string {
        return tutorial ? Translation.tr(tutorial.titleKey) : "";
    }

    function descriptionFor(tutorial): string {
        return tutorial ? Translation.tr(tutorial.descriptionKey) : "";
    }

    function estimatedTimeFor(tutorial): string {
        return tutorial
            ? Translation.tr("About %1 minutes").arg(String(tutorial.estimatedMinutes))
            : "";
    }
}
