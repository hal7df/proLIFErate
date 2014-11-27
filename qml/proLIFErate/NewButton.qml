import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: buttonContain

    property color color: newButton.color
    property string iconSource: "add"
    property bool srcAbsolute: false
    property real circleWidth: (43/270)*parent.width

    signal clicked
    signal pressAndHold

    width: circleWidth
    height: width

    Rectangle {
        id: newButton

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        height: width
        width: parent.circleWidth
        radius: 0.5*width
        color: parent.color

        states: State {
            name: "activated"; when: buttonDetect.pressed
            PropertyChanges { target: newButton; color: Qt.darker(buttonContain.color,1.5) }
        }

        Image {
            id: icon

            anchors.centerIn: parent
            width: (parent.width/Math.sqrt(2))
            height: width

            source: getIconResolution()
            fillMode: Image.PreserveAspectFit
            smooth: true

            function getIconResolution()
            {
                if (!buttonContain.srcAbsolute)
                    if (height < 48)
                        return "images/mdpi/ic_"+buttonContain.iconSource+".png";
                    else if (height >= 48 && height < 64)
                        return "images/hdpi/ic_"+buttonContain.iconSource+".png";
                    else
                        return "images/xhdpi/ic_"+buttonContain.iconSource+".png";
                else
                    return parent.source;
            }
        }

        MouseArea {
            id: buttonDetect

            anchors.fill: parent

            Component.onCompleted: {
                clicked.connect(buttonContain.clicked);
                pressAndHold.connect(buttonContain.pressAndHold);
            }
        }
    }

    DropShadow {
        id: shadow
        anchors.fill: newButton

        source: newButton

        color: "#33000000"
        scale: 1.15
        samples: 10
        radius: 8
        verticalOffset: (newButton.width/20)
        z: -1
    }
}
