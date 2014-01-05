import QtQuick 1.1

Rectangle {
    id: toolbar

    height: ((parent.height*parent.width)/160)/30
    anchors { left: parent.left; right: parent.right }
    color: "#00000000"
    border.color: "#000000"
    border.width: 1
}
