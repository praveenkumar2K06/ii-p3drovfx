pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick

/**
 * Compact orientation copy for the Welcome catalog. Canonical setup remains
 * in Cheatsheet/Settings; these cards explain the path without duplicating it.
 */
QtObject {
    function contentFor(contentId: string): var {
        return ({
            "intro": "This tutorial is not available yet.",
            "prerequisites": [],
            "steps": [],
            "actionLabel": "",
            "actionPage": "",
            "actionSubPage": "",
            "actionSection": ""
        });
    }
}
