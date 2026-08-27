pragma ComponentBehavior: Bound

import qs
import Quickshell
import qs.modules.ii.background.compositor

Scope {
    id: backgroundScope

    Variants {
        id: root
        model: Quickshell.screens

        BackgroundRoot {}
    }

    Variants {
        id: blurOverlayVariant
        model: Quickshell.screens

        BlurOverlayWindow {}
    }
}
