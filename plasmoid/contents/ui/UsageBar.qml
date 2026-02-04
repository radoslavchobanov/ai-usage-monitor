/*
 * UsageBar - Reusable usage bar component
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: root

    property string title: ""
    property real percentage: 0
    property string subtitle: ""
    property string extraInfo: ""
    property bool compact: false

    spacing: Kirigami.Units.smallSpacing

    RowLayout {
        Layout.fillWidth: true

        PlasmaComponents.Label {
            text: root.title
            font.bold: true
            font.pointSize: root.compact ? Kirigami.Theme.smallFont.pointSize : Kirigami.Theme.defaultFont.pointSize
        }

        Item { Layout.fillWidth: true }

        PlasmaComponents.Label {
            text: Math.round(root.percentage) + "% used"
            opacity: 0.7
            font.pointSize: root.compact ? Kirigami.Theme.smallFont.pointSize : Kirigami.Theme.defaultFont.pointSize
        }
    }

    PlasmaComponents.ProgressBar {
        Layout.fillWidth: true
        from: 0
        to: 100
        value: root.percentage
    }

    RowLayout {
        Layout.fillWidth: true
        visible: root.subtitle !== "" || root.extraInfo !== ""

        PlasmaComponents.Label {
            text: root.subtitle
            visible: root.subtitle !== ""
            opacity: 0.6
            font.pointSize: Kirigami.Theme.smallFont.pointSize
        }

        Item { Layout.fillWidth: true }

        PlasmaComponents.Label {
            text: root.extraInfo
            visible: root.extraInfo !== ""
            opacity: 0.6
            font.pointSize: Kirigami.Theme.smallFont.pointSize
        }
    }
}
