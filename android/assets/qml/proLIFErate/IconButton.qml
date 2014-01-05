import QtQuick 1.1

Item
{
    id: iconButtonContainer

    property alias pressedColor: select.color
    property string source: ""
    property bool srcAbsolute: false
    property alias iconRotation: image.rotation
    property bool disabled: false
    signal clicked

    Rectangle {
        id: shadow
        color: "#767676"
        anchors { fill: parent; topMargin: 3; rightMargin: 3; leftMargin: 3; bottomMargin: 2 }
    }

    Rectangle {
        id: iconButton
        color: "#d2d2d2"
        anchors { fill: parent; margins: 3 }


        Image {
            id: image
            anchors.fill: parent
            anchors.margins: srcAbsolute ? 0.1*parent.width : 0
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: getIconResolution()
            states: State {
                    name: "greyedOut"; when: iconButtonContainer.disabled
                    PropertyChanges { target: image; opacity: 0.24 }
                }

            function getIconResolution()
            {
                if (!iconButtonContainer.srcAbsolute)
                    if (height < 48)
                        return "images/mdpi/ic_"+iconButtonContainer.source+".png";
                    else if (height >= 48 && height < 64)
                        return "images/hdpi/ic_"+iconButtonContainer.source+".png";
                    else
                        return "images/xhdpi/ic_"+iconButtonContainer.source+".png";
                else
                    return iconButtonContainer.source;
            }
        }

        MouseArea {
            id: button
            anchors.fill: parent
            enabled: !iconButtonContainer.disabled
            Component.onCompleted: clicked.connect(iconButtonContainer.clicked);
        }
    }

    Rectangle {
        id: select
        color: "#4bbde8"
        anchors.fill: parent
        radius: 4
        opacity: 0.75
        visible: button.pressed  && !parent.disabled ? true : false
    }
}
