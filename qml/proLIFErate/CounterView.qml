import QtQuick 2.0

Item {
    id: playerContain

    property int viewer
    property DynamicToolbar dynToolbar
    property ListModel model
    property int otherViewAt //to make sure two views don't settle on the same player
    readonly property alias playerAt: players.currentIndex

    ListView {
        id: players

        property real lastMovingDirection
        property bool stopped: false

        anchors.fill: parent

        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        model: parent.model

        boundsBehavior: Flickable.StopAtBounds
        interactive: model.count > 2

        delegate: playerDelegate

        Component.onCompleted: positionViewAtIndex(viewer-1,ListView.Beginning)

        onCurrentIndexChanged: {
            if (currentIndex == playerContain.otherViewAt)
            {
                console.log("Repositioning viewer",viewer,"due to conflicting viewer");
                if (lastMovingDirection > 0)
                {
                    console.log("Viewer last moving forward...");
                    if (currentIndex == count-1)
                    {
                        console.log("Repositioning viewer to previous item");
                        positionViewAtIndex(currentIndex-1,ListView.Beginning);
                    }
                    else
                    {
                        console.log("Repositioning viewer to next item");
                        positionViewAtIndex(currentIndex+1,ListView.Beginning);
                    }
                }
                else
                {
                    console.log("Viewer last moving backward...");
                    if (currentIndex == 0)
                    {
                        console.log("Repositioning viewer to previous item");
                        positionViewAtIndex(currentIndex+1,ListView.Beginning);
                    }
                    else
                    {
                        console.log("Repositioning viewer to next item");
                        positionViewAtIndex(currentIndex-1,ListView.Beginning);
                    }
                }
            }
        }

        onHorizontalVelocityChanged: {
            if ((horizontalVelocity*lastMovingDirection) > 0)
            {
                lastMovingDirection = horizontalVelocity;
            }
            else if (stopped)
            {
                stopped = false;
                lastMovingDirection = horizontalVelocity;
            }
            else if (horizontalVelocity == 0)
            {
                stopped = true;
            }
        }
    }

    Component {
        id: playerDelegate

        Item {
            id: player

            width: players.width
            height: players.height

            Rectangle {
                id: nameBack

                anchors {
                    top: parent.top
                    right: parent.right
                    left: parent.left
                    margins: 5
                }

                height: parent.height/6

                color: "#00000000"
                border { color: "#00000000"; width: 2 }

                Text {
                    id: playerName

                    text: name

                    anchors.centerIn: parent
                    width: parent.width - 5
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: nameBack.height*0.72
                }

                MouseArea {
                    id: nameChange

                    anchors.fill: parent

                    onClicked: {
                        if (playerContain.dynToolbar.requestText(playerName.text,nameBack))
                        {
                            nameBack.color = "#ffffff";
                            nameBack.border.color = "#000000";
                        }
                    }
                }

                function receive (value)
                {
                    if (value != undefined)
                        playerContain.model.setProperty(index, "name", value);
                    nameBack.color = "#00000000";
                    nameBack.border.color = "#00000000";
                }
            }

            Item {
                id: counterContain

                anchors {
                    top: nameBack.bottom
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                    margins: 2
                }

                height: players.height-nameBack.height-2

                GridView {
                    id: counters

                    anchors.fill: parent

                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    snapMode: GridView.SnapOneRow

                    clip: true
                    cellWidth: (width/2)-2
                    cellHeight: height
                    model: playerContain.model.get(index).counters
                    property int rootIndex: index

                    delegate: CounterBase {
                            id: counter

                            width: counters.cellWidth
                            height: counters.cellHeight

                            name: counterName
                            count: lCount
                            editable: edit

                            onCountChanged: playerContain.model.get(counters.rootIndex).counters.setProperty(index,"lCount",count)
                            onNameChanged: playerContain.model.get(counters.rootIndex).counters.setProperty(index,"counterName",name)

                            onClicked: {
                                if (rqID == 0)
                                    playerContain.dynToolbar.requestText(name,counter);
                                else if (rqID == 1)
                                {
                                    if (playerContain.dynToolbar.requestViewer(count,playerContain.rotation,counter))
                                        numpad.visible = true;
                                }
                            }

                            onReceived: numpad.visible = false
                            onDeleteCounter: playerContain.model.get(counters.rootIndex).counters.remove(index)

                            Component.onCompleted: console.log("Counter height:",height)
                        }

                    footer: Rectangle {
                            id: addCounter

                            width: (counters.width/2)-1
                            height: counterContain.height - 2

                            color: "#00000000"
                            border.color: "#bbcccccc"

                            states: State {
                                when:  addClick.pressed
                                PropertyChanges { target: addCounter; color: "#33B5E5" }
                            }

                            Image {
                                anchors.centerIn: parent

                                height: parent.height/3
                                width: height

                                fillMode: Image.PreserveAspectFit
                                source: {
                                    if (height < 48)
                                        return "images/mdpi/ic_new.png";
                                    else if (height >= 48 && height < 64)
                                        return "images/hdpi/ic_new.png";
                                    else
                                        return "images/xhdpi/ic_new.png";
                                }
                            }

                            MouseArea {
                                id: addClick

                                anchors.fill: parent

                                onClicked: {
                                    playerContain.model.get(index).counters.append({"counterName": "Unnamed", "lCount": 0, "edit": true});
                                }
                            }
                        }
                    }
                }
            }
        }

    Rectangle {
        id: playerIndicator

        anchors.top: parent.top

        height: 2
        width: players.visibleArea.widthRatio * players.width
        x: players.visibleArea.xPosition * players.width

        color: "#33B5E5"

        visible: playerContain.model.count > 2
    }


    Numpad {
        id: numpad

        anchors.fill: parent
        visible: false
        onAppendDisplay: parent.dynToolbar.append(add)
        onAddNum: parent.dynToolbar.add(add)
        onBackspace: parent.dynToolbar.deleteLast()
    }

    function positionViewAtIndex(index)
    {
        players.positionViewAtIndex(index,ListView.Contain);
    }

    function positionViewAtEnd()
    {
        players.positionViewAtEnd();
    }

    function positionViewAtBeginning()
    {
        players.positionViewAtBeginning();
    }
}

