import QtQuick 2.0

Item
{
    id: buttonContainer

    property alias pressedColor: select.color
    property bool disabled: false
    property alias text: buttonText.text
    signal clicked

    Rectangle {
        id: shadow
        color: "#767676"
        anchors { fill: parent; topMargin: 3; rightMargin: 3; leftMargin: 3; bottomMargin: 2 }
    }

    Rectangle {
        id: buttonClickContainer
        color: "#d2d2d2"
        anchors { fill: parent; margins: 3 }

        Text {
            id: buttonText

            anchors.centerIn: parent

            font.pixelSize: 0.7*parent.height
            text: ""

            visible: text != ""
        }

        MouseArea {
            id: buttonClick
            anchors.fill: parent
            enabled: !buttonContainer.disabled
            Component.onCompleted: clicked.connect(buttonContainer.clicked);
        }
    }

    Rectangle {
        id: select
        color: "#4bbde8"
        anchors.fill: parent
        radius: 4
        opacity: 0.75
        visible: buttonClick.pressed  && !parent.disabled ? true : false
    }
}
