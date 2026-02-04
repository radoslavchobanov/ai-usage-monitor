/*
 * UsageSection - Reusable usage display component
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

ColumnLayout {
    id: root

    property string title: ""
    property real percentage: 0
    property string resetTime: ""
    property string paceStatus: ""

    spacing: PlasmaCore.Units.smallSpacing

    RowLayout {
        Layout.fillWidth: true

        PlasmaComponents.Label {
            text: root.title
            font.bold: true
        }

        Item { Layout.fillWidth: true }

        PlasmaComponents.Label {
            text: Math.round(root.percentage) + "%"
            opacity: 0.8
        }
    }

    PlasmaComponents.ProgressBar {
        Layout.fillWidth: true
        from: 0
        to: 100
        value: root.percentage

        // Color based on usage level
        palette.highlight: {
            if (root.percentage >= 80) return PlasmaCore.Theme.negativeTextColor
            if (root.percentage >= 50) return PlasmaCore.Theme.neutralTextColor
            return PlasmaCore.Theme.positiveTextColor
        }
    }

    RowLayout {
        Layout.fillWidth: true
        visible: root.resetTime !== "" || root.paceStatus !== ""

        PlasmaComponents.Label {
            text: root.resetTime ? formatResetTime(root.resetTime) : ""
            opacity: 0.6
            font.pointSize: PlasmaCore.Theme.smallestFont.pointSize
            visible: root.resetTime !== ""
        }

        Item { Layout.fillWidth: true }

        PlasmaComponents.Label {
            text: root.paceStatus
            opacity: 0.6
            font.pointSize: PlasmaCore.Theme.smallestFont.pointSize
            visible: root.paceStatus !== "" && root.paceStatus !== "On track"
        }
    }

    function formatResetTime(isoTime) {
        if (!isoTime) return ""

        try {
            var reset = new Date(isoTime)
            var now = new Date()
            var diff = reset - now

            if (diff <= 0) return "Resetting..."

            var days = Math.floor(diff / (1000 * 60 * 60 * 24))
            var hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
            var minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))

            if (days > 0) return "Resets in " + days + "d " + hours + "h"
            if (hours > 0) return "Resets in " + hours + "h " + minutes + "m"
            return "Resets in " + minutes + "m"
        } catch (e) {
            return ""
        }
    }
}
