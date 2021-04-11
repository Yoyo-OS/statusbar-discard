import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Cutefish.StatusBar 1.0
import Cutefish.NetworkManagement 1.0 as NM
import FishUI 1.0 as FishUI

Item {
    id: rootItem

    property int iconSize: 16

    Rectangle {
        id: background
        anchors.fill: parent
        color: FishUI.Theme.backgroundColor
        opacity: 0.6

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.Linear
            }
        }
    }

    FishUI.PopupTips {
        id: popupTips
        backgroundColor: FishUI.Theme.backgroundColor
        backgroundOpacity: FishUI.Theme.darkMode ? 0.3 : 0.4
    }

    FishUI.DesktopMenu {
        id: acticityMenu

        MenuItem {
            text: qsTr("Close")
            onTriggered: acticity.close()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: FishUI.Units.smallSpacing
        anchors.rightMargin: FishUI.Units.smallSpacing
        spacing: 0

        StandardItem {
            id: acticityItem
            Layout.fillHeight: true
            Layout.preferredWidth: acticityLayout.implicitWidth ? acticityLayout.implicitWidth + FishUI.Units.largeSpacing
                                                                : 0
            onClicked: acticityMenu.open()

            RowLayout {
                id: acticityLayout
                anchors.fill: parent
                anchors.leftMargin: FishUI.Units.smallSpacing
                anchors.rightMargin: FishUI.Units.smallSpacing
                spacing: FishUI.Units.largeSpacing

//                Image {
//                    id: acticityIcon
//                    width: 16
//                    height: 16
//                    sourceSize: Qt.size(width, height)
//                    source: acticity.icon ? "image://icontheme/" + acticity.icon : ""
//                    visible: status === Image.Ready
//                    asynchronous: true
//                }

                Label {
                    id: acticityLabel
                    text: acticity.title
                    visible: text
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        ListView {
            id: trayView

            orientation: Qt.Horizontal
            layoutDirection: Qt.RightToLeft
            interactive: false
            clip: true
            spacing: 0

            property var itemSize: rootItem.height * 0.8
            property var itemWidth: itemSize + FishUI.Units.largeSpacing

            Layout.fillHeight: true
            Layout.preferredWidth: itemWidth * count

            model: SystemTrayModel {
                id: trayModel
            }

            delegate: StandardItem {
                width: trayView.itemWidth
                height: ListView.view.height

                property bool darkMode: FishUI.Theme.darkMode
                onDarkModeChanged: updateTimer.restart()

                Timer {
                    id: updateTimer
                    interval: 10
                    onTriggered: iconItem.updateIcon()
                }

                FishUI.IconItem {
                    id: iconItem
                    anchors.centerIn: parent
                    width: rootItem.iconSize
                    height: width
                    source: model.iconName ? model.iconName : model.icon
                }

                onClicked: trayModel.leftButtonClick(model.id)
                onRightClicked: trayModel.rightButtonClick(model.id)
                popupText: model.toolTip ? model.toolTip : model.title
            }
        }

        StandardItem {
            id: controler

            Layout.fillHeight: true
            Layout.preferredWidth: _controlerLayout.implicitWidth + FishUI.Units.largeSpacing

            onClicked: {
                if (controlDialog.visible)
                    controlDialog.visible = false
                else {
                    // 先初始化，用户可能会通过Alt鼠标左键移动位置
                    controlDialog.position = Qt.point(0, 0)
                    controlDialog.visible = true
                    controlDialog.position = Qt.point(mapToGlobal(0, 0).x, mapToGlobal(0, 0).y)
                }
            }

            RowLayout {
                id: _controlerLayout
                anchors.fill: parent
                anchors.leftMargin: FishUI.Units.smallSpacing
                anchors.rightMargin: FishUI.Units.smallSpacing

                spacing: FishUI.Units.largeSpacing

                Image {
                    id: volumeIcon
                    visible: volume.isValid && status === Image.Ready
                    source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark/" : "light/") + volume.iconName + ".svg"
                    width: rootItem.iconSize
                    height: width
                    sourceSize: Qt.size(width, height)
                    asynchronous: true
                    Layout.alignment: Qt.AlignCenter
                }

                Image {
                    id: wirelessIcon
                    width: rootItem.iconSize
                    height: width
                    sourceSize: Qt.size(width, height)
                    source: network.wirelessIconName ? "qrc:/images/" + (FishUI.Theme.darkMode ? "dark/" : "light/") + network.wirelessIconName + ".svg" : ""
                    asynchronous: true
                    Layout.alignment: Qt.AlignCenter
                    visible: network.enabled &&
                             network.wirelessEnabled &&
                             network.wirelessConnectionName !== "" &&
                             wirelessIcon.status === Image.Ready
                }

                // Battery Item
                RowLayout {
                    Label {
                        font.pointSize: 11
                        text: battery.chargePercent + "%"
                        visible: battery.showPercentage
                    }

                    Image {
                        id: batteryIcon
                        visible: battery.available && status === Image.Ready
                        height: rootItem.iconSize
                        width: height + 6
                        sourceSize: Qt.size(width, height)
                        source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark/" : "light/") + battery.iconSource
                        Layout.alignment: Qt.AlignCenter
                        asynchronous: true
                    }
                }

//                Image {
//                    id: powerIcon
//                    height: rootItem.iconSize + 2
//                    width: height
//                    sourceSize: Qt.size(width, height)
//                    source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark/" : "light/") + "system-shutdown-symbolic.svg"
//                    Layout.alignment: Qt.AlignCenter
//                    asynchronous: true
//                }

                Label {
                    id: timeLabel
                    Layout.alignment: Qt.AlignCenter
                    font.pixelSize: rootItem.height * 0.5

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        triggeredOnStart: true
                        onTriggered: {
                            timeLabel.text = new Date().toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
                        }
                    }
                }
            }
        }
    }

    // Components
    ControlDialog {
        id: controlDialog
    }

    Volume {
        id: volume
    }

    Battery {
        id: battery
    }

    NM.ConnectionIcon {
        id: connectionIconProvider
    }

    NM.Network {
        id: network
    }
}