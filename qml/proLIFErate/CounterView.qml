import QtQuick 2.0

Item {
    id: playerContain

    property int viewer
    property DynamicToolbar dynToolbar
    property ListModel model
    property int otherViewAt //to make sure two views don't settle on the same player
    readonly property alias playerAt: players.displayIndex

    readonly property alias delegateWidth: playerContain.width
    readonly property alias delegateHeight: playerContain.height

    onOtherViewAtChanged: {
        console.log("Other view now at:(",viewer,")",otherViewAt);
    }

    ListView {
        id: players

        property real lastMovingDirection
        property int displayIndex: indexAt(contentX,contentY)

        anchors.fill: parent
        width: parent.width
        height: parent.height

        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        model: parent.model

        boundsBehavior: Flickable.StopAtBounds
        interactive: model.count > 2

        Component.onCompleted: {
            positionViewAtIndex(parent.viewer-1,ListView.Beginning)
        }

        onDisplayIndexChanged: {
            if (displayIndex == playerContain.otherViewAt)
            {
                console.log("Viewer",viewer,"index:",displayIndex);
                console.log("Other viewer index:",parent.otherViewAt);

                if (lastMovingDirection > 0)
                {
                    if (displayIndex == count-1)
                    {
                        positionViewAtIndex(displayIndex-1,ListView.Beginning);
                        displayIndex--;
                    }
                    else
                    {
                        positionViewAtIndex(displayIndex+1,ListView.Beginning);
                        displayIndex++;
                    }
                }
                else
                {
                    if (displayIndex == 0)
                    {
                        positionViewAtIndex(displayIndex+1,ListView.Beginning);
                        displayIndex++;
                    }
                    else
                    {
                        positionViewAtIndex(displayIndex-1,ListView.Beginning);
                        displayIndex--;
                    }
                }
            }

            console.log("View",viewer,"at:",playerAt);
        }

        onHorizontalVelocityChanged: {
            if (horizontalVelocity != 0)
                lastMovingDirection = horizontalVelocity;
        }

        delegate: playerDelegate

        Behavior on contentX { NumberAnimation {} }
    }

    Component {
        id: playerDelegate

        Rectangle {
            id: player

            property bool loss: (counters.get(0).lCount == 0) || (counters.get(1).lCount >= 10)
            property variant counterList: counters

            width: ListView.view.width == 0 ? 480 : ListView.view.width
            height: ListView.view.height == 0 ? 360 : ListView.view.height

            color: "#e7ece6"

            onLossChanged: {
                if (loss)
                    color = "#ff4444";
            }

            ColorAnimation on color { to: "#e7ece6"; running: player.color != "#e7ece6"; duration: 1500 }

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
                        }
                    }
                }

                Rectangle {
                    id: namePerspective

                    anchors {
                        left: nameBack.left
                        right: nameBack.right
                        top: nameBack.bottom
                    }

                    height: 2

                    color: "#cccccc"
                    visible: nameBack.color == "#ffffff"
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
                    id: counterDisplay

                    anchors.fill: parent

                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    snapMode: GridView.SnapOneRow

                    clip: true
                    cellWidth: width/2
                    cellHeight: height
                    model: player.counterList

                    delegate: CounterBase {
                            id: counter

                            width: counterDisplay.cellWidth
                            height: counterDisplay.cellHeight

                            name: counterName
                            count: lCount
                            editable: edit

                            disabled: player.loss

                            onCountChanged: counterDisplay.model.setProperty(index,"lCount",count)
                            onNameChanged: counterDisplay.model.setProperty(index,"counterName",name)

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
                            onDeleteCounter: counterDisplay.model.remove(index)

                            Connections {
                                target: player.counterList
                                onDataChanged: count = player.counterList.get(index).lCount
                            }
                        }

                    footer: Item {
                            id: addCounter

                            width: counterDisplay.width
                            height: counterDisplay.height

                            Rectangle {
                                anchors.centerIn: parent

                                height: (parent.height/3)*Math.sqrt(2)
                                width: height
                                radius: width/2

                                color: addClick.pressed ? "#FF4444" : "#00000000"

                                Image {
                                    anchors.centerIn: parent

                                    height: addCounter.height/3
                                    width: height

                                    fillMode: Image.PreserveAspectFit
                                    source: {
                                        if (addClick.pressed)
                                        {
                                            if (height < 48)
                                                return "images/mdpi/ic_add.png";
                                            else if (height >= 48 && height < 64)
                                                return "images/hdpi/ic_add.png";
                                            else
                                                return "images/xhdpi/ic_add.png";
                                        }
                                        else
                                        {
                                            if (height < 48)
                                                return "images/mdpi/ic_new.png";
                                            else if (height >= 48 && height < 64)
                                                return "images/hdpi/ic_new.png";
                                            else
                                                return "images/xhdpi/ic_new.png";
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                id: addClick

                                anchors.fill: parent

                                onClicked: {
                                    counterDisplay.model.append({"counterName": "Unnamed", "lCount": 0, "edit": true});
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

    function flashPlayer (index)
    {
        players.currentIndex = index;
        players.positionViewAtIndex(index,ListView.Beginning);

        players.currentItem.color = "#66cc00";
    }
}

