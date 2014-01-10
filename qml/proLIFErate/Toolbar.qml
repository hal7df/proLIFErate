import QtQuick 1.1

Rectangle {
    id: toolbar

    height: parent.height/10
    anchors { left: parent.left; right: parent.right; leftMargin: -1 }
    color: "#dddddd"
    border.color: "#d7dcd6"
    border.width: 3

    onHeightChanged: parent.writeDebug(height);
}
