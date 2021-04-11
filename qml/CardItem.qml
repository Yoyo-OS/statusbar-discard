import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import FishUI 1.0 as FishUI

Item {
    id: control

    property bool checked: false
    property alias icon: _image.source
    property alias label: _titleLabel.text
    property alias text: _label.text

    signal clicked

    property var hoverColor: FishUI.Theme.darkMode ? Qt.lighter(FishUI.Theme.secondBackgroundColor, 2)
                                                   : Qt.darker(FishUI.Theme.secondBackgroundColor, 1.3)
    property var pressedColor: FishUI.Theme.darkMode ? Qt.lighter(FishUI.Theme.secondBackgroundColor, 1.8)
                                                     : Qt.darker(FishUI.Theme.secondBackgroundColor, 1.5)

    property var highlightHoverColor: FishUI.Theme.darkMode ? Qt.lighter(FishUI.Theme.highlightColor, 1.1)
                                                            : Qt.darker(FishUI.Theme.highlightColor, 1.1)
    property var highlightPressedColor: FishUI.Theme.darkMode ? Qt.lighter(FishUI.Theme.highlightColor, 1.1)
                                                              : Qt.darker(FishUI.Theme.highlightColor, 1.2)

    MouseArea {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()

        onPressedChanged: {
            control.scale = pressed ? 0.95 : 1.0
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 100
        }
    }

    FishUI.RoundedRect {
        anchors.fill: parent
        radius: FishUI.Theme.bigRadius
        backgroundOpacity: control.checked ? 0.9 : 0.3
        animationEnabled: false

        color: {
            if (control.checked) {
                if (_mouseArea.pressed)
                    return highlightPressedColor
                else if (_mouseArea.containsMouse)
                    return highlightHoverColor
                else
                    return FishUI.Theme.highlightColor
            } else {
                if (_mouseArea.pressed)
                    return pressedColor
                else if (_mouseArea.containsMouse)
                    return hoverColor
                else
                    return FishUI.Theme.secondBackgroundColor
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: FishUI.Theme.smallRadius
        anchors.rightMargin: FishUI.Theme.smallRadius

        Image {
            id: _image
            Layout.preferredWidth: control.height * 0.3
            Layout.preferredHeight: control.height * 0.3
            sourceSize: Qt.size(width, height)
            asynchronous: true
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: FishUI.Units.largeSpacing

//            ColorOverlay {
//                anchors.fill: _image
//                source: _image
//                color: control.checked ? FishUI.Theme.highlightedTextColor : FishUI.Theme.disabledTextColor
//            }
        }

        Item {
            Layout.fillHeight: true
        }

        Label {
            id: _titleLabel
            color: control.checked ? FishUI.Theme.highlightedTextColor : FishUI.Theme.textColor
            Layout.preferredHeight: control.height * 0.15
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
        }

        Label {
            id: _label
            color: control.checked ? FishUI.Theme.highlightedTextColor : FishUI.Theme.textColor
            elide: Label.ElideRight
            Layout.preferredHeight: control.height * 0.1
            Layout.alignment: Qt.AlignHCenter
            // Layout.fillWidth: true
            Layout.bottomMargin: FishUI.Units.largeSpacing
        }

        Item {
            Layout.fillHeight: true
        }
    }
}