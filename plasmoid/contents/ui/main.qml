/*
 * AI Usage Monitor - KDE Plasma System Tray Applet
 * Native Plasma popup UI for monitoring AI usage limits
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: root

    // Backend connection via DBus
    property var providers: []
    property string currentProvider: "claude"
    property bool loading: true
    property string errorMessage: ""

    // DBus service interface
    PlasmaCore.DataSource {
        id: aiUsageSource
        engine: "executable"
        connectedSources: []

        onNewData: {
            var stdout = data["stdout"]
            if (stdout) {
                try {
                    var result = JSON.parse(stdout)
                    root.providers = result.providers || []
                    root.loading = false
                    root.errorMessage = ""
                } catch (e) {
                    root.errorMessage = "Failed to parse data"
                    root.loading = false
                }
            }
            disconnectSource(sourceName)
        }

        function refresh() {
            root.loading = true
            connectSource("ai-usage-backend --json")
        }
    }

    // Refresh on load and periodically
    Timer {
        id: refreshTimer
        interval: 60000 // 1 minute
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: aiUsageSource.refresh()
    }

    // Tray icon configuration
    Plasmoid.icon: "preferences-system-network"
    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    Plasmoid.toolTipMainText: "AI Usage Monitor"
    Plasmoid.toolTipSubText: getTooltipText()

    function getTooltipText() {
        if (loading) return "Loading..."
        if (providers.length === 0) return "No providers configured"

        var texts = []
        for (var i = 0; i < providers.length; i++) {
            var p = providers[i]
            if (p.is_connected) {
                texts.push(p.provider_name + ": " + Math.round(p.session_used_pct) + "% session")
            }
        }
        return texts.join("\n") || "No data"
    }

    function getProvider(id) {
        for (var i = 0; i < providers.length; i++) {
            if (providers[i].provider_id === id) return providers[i]
        }
        return null
    }

    // Popup content
    Plasmoid.fullRepresentation: PlasmaComponents.Page {
        id: popup

        Layout.minimumWidth: PlasmaCore.Units.gridUnit * 20
        Layout.minimumHeight: PlasmaCore.Units.gridUnit * 25
        Layout.preferredWidth: PlasmaCore.Units.gridUnit * 22
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 28

        header: PlasmaExtras.PlasmoidHeading {
            RowLayout {
                anchors.fill: parent

                PlasmaExtras.Heading {
                    level: 1
                    text: "AI Usage Monitor"
                    Layout.fillWidth: true
                }

                PlasmaComponents.ToolButton {
                    icon.name: "view-refresh"
                    onClicked: aiUsageSource.refresh()
                    PlasmaComponents.ToolTip { text: "Refresh" }
                }

                PlasmaComponents.ToolButton {
                    icon.name: "configure"
                    onClicked: Qt.openUrlExternally("file:///home/" + Qt.platform.os + "/.config/ai-usage-monitor/settings.json")
                    PlasmaComponents.ToolTip { text: "Settings" }
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: PlasmaCore.Units.smallSpacing

            // Provider tabs
            PlasmaComponents.TabBar {
                id: tabBar
                Layout.fillWidth: true

                PlasmaComponents.TabButton {
                    text: "Claude"
                    icon.name: "preferences-system-network"
                    onClicked: root.currentProvider = "claude"
                }
                PlasmaComponents.TabButton {
                    text: "Codex"
                    icon.name: "preferences-system-network"
                    onClicked: root.currentProvider = "codex"
                }
            }

            // Loading indicator
            PlasmaComponents.BusyIndicator {
                Layout.alignment: Qt.AlignCenter
                running: root.loading
                visible: root.loading
            }

            // Error message
            PlasmaExtras.Heading {
                level: 4
                text: root.errorMessage
                visible: root.errorMessage !== "" && !root.loading
                Layout.alignment: Qt.AlignCenter
                color: PlasmaCore.Theme.negativeTextColor
            }

            // Provider content
            Loader {
                id: contentLoader
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: !root.loading && root.errorMessage === ""
                sourceComponent: providerContent
            }
        }

        Component {
            id: providerContent

            ColumnLayout {
                spacing: PlasmaCore.Units.smallSpacing

                property var provider: root.getProvider(root.currentProvider)

                // Not connected message
                PlasmaExtras.Heading {
                    level: 3
                    text: provider ? provider.provider_name : root.currentProvider
                    Layout.fillWidth: true
                }

                PlasmaComponents.Label {
                    text: provider && provider.error_message ? provider.error_message : "Not configured"
                    visible: !provider || !provider.is_connected
                    opacity: 0.7
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Connected content
                ColumnLayout {
                    visible: provider && provider.is_connected
                    Layout.fillWidth: true
                    spacing: PlasmaCore.Units.largeSpacing

                    // Plan badge
                    RowLayout {
                        Layout.fillWidth: true

                        PlasmaComponents.Label {
                            text: "Plan"
                            opacity: 0.7
                        }
                        Item { Layout.fillWidth: true }
                        PlasmaComponents.Label {
                            text: provider ? provider.plan_name : ""
                            font.bold: true
                        }
                    }

                    // Session usage
                    UsageSection {
                        title: "Session (5h)"
                        percentage: provider ? provider.session_used_pct : 0
                        resetTime: provider ? provider.session_reset_time : ""
                        Layout.fillWidth: true
                    }

                    // Weekly usage
                    UsageSection {
                        title: "Weekly (7d)"
                        percentage: provider ? provider.weekly_used_pct : 0
                        resetTime: provider ? provider.weekly_reset_time : ""
                        paceStatus: provider ? provider.pace_status : ""
                        Layout.fillWidth: true
                    }

                    // Model usage (if available)
                    Repeater {
                        model: provider && provider.model_usage ? Object.keys(provider.model_usage) : []

                        UsageSection {
                            title: modelData
                            percentage: provider.model_usage[modelData]
                            Layout.fillWidth: true
                        }
                    }

                    // Extra usage
                    ColumnLayout {
                        visible: provider && provider.extra_usage_enabled
                        Layout.fillWidth: true
                        spacing: PlasmaCore.Units.smallSpacing

                        PlasmaCore.SvgItem {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            svg: PlasmaCore.Svg { imagePath: "widgets/line" }
                            elementId: "horizontal-line"
                        }

                        PlasmaComponents.Label {
                            text: "Extra Usage"
                            font.bold: true
                        }

                        PlasmaComponents.ProgressBar {
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: provider ? provider.extra_usage_pct : 0
                        }

                        PlasmaComponents.Label {
                            text: provider ? "$" + provider.extra_usage_current.toFixed(2) + " / $" + provider.extra_usage_limit.toFixed(2) : ""
                            opacity: 0.7
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // Quick links
                    PlasmaCore.SvgItem {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        svg: PlasmaCore.Svg { imagePath: "widgets/line" }
                        elementId: "horizontal-line"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: PlasmaCore.Units.largeSpacing

                        PlasmaComponents.ToolButton {
                            text: "Usage Dashboard"
                            icon.name: "document-preview"
                            onClicked: {
                                if (root.currentProvider === "claude") {
                                    Qt.openUrlExternally("https://claude.ai/settings/usage")
                                } else {
                                    Qt.openUrlExternally("https://platform.openai.com/usage")
                                }
                            }
                        }

                        PlasmaComponents.ToolButton {
                            text: "Status"
                            icon.name: "network-connect"
                            onClicked: {
                                if (root.currentProvider === "claude") {
                                    Qt.openUrlExternally("https://status.anthropic.com/")
                                } else {
                                    Qt.openUrlExternally("https://status.openai.com/")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Compact representation (tray icon)
    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: Plasmoid.icon
        active: mouseArea.containsMouse

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }
    }
}
