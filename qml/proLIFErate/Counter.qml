import QtQuick 1.1

Rectangle {
    id: counter

    property int playerNum
    property bool isNormalColor: color == "#00000000"
    property bool loss: false
    property Item dynToolbar: parent.dynToolbar

    color: "#00000000"
    height: parent.height/2
    rotation: playerNum == 2 ? 180 : 0

    onLossChanged: {
        if (loss)
            color = "#ff4444";
    }

    onColorChanged: {
        if (!isNormalColor)
            colorAnimate.start();
    }

    PropertyAnimation on color { id: colorAnimate; running: !counter.isNormalColor; to: "#00000000"; duration: 1500 }

    Rectangle {
        id: nameBack
        anchors { margins: 5; top: parent.top; right: parent.right; left: parent.left }
        height: parent.height/6
        color: "#00000000"
        border { color: "#00000000"; width: 2 }

        Text {
            id: name

            property bool defaultText: true

            anchors.centerIn: nameBack
            width: nameBack.width - 5
            text: "Player"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: nameBack.height*0.72

            onTextChanged: defaultText = false
        }


        MouseArea {
            id: getEdit

            anchors.fill: parent

            onClicked: {
                if(counter.dynToolbar.requestText(name.text,nameBack))
                {
                    parent.color = "#ffffff";
                    parent.border.color = "#000000";
                }
            }
        }

        function receive (value)
        {
            if (value != undefined)
                name.text = value;
            color = "#00000000";
            border.color = "#00000000"
        }
    }

    FocusScope {
        id:scope
        anchors { top: nameBack.bottom; right: parent.right; left: parent.left; bottom: parent.bottom }

        MouseArea {
            id: backFocusIntercept
            anchors.fill: parent
            onClicked: parent.forceActiveFocus()
        }

        Grid {
            id: statsDisplay
            anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; topMargin: 2; leftMargin: 2; rightMargin: 2 }

            columns: 2
            spacing: 2

            CounterBase {
                id: life

                name: "Life"
                count: 20
                editable: false
                disabled: counter.loss

                height: parent.height
                width: (parent.width/2)-1

                onCountChanged: {
                    if (life.count <= 0)
                        counter.loss = true;
                }
                onClickIntercept: scope.forceActiveFocus()

                onClicked: {
                    if (rqID == 1)
                    {
                        if (counter.dynToolbar.requestViewer(count,counter.rotation,life))
                            bulkNumChange.visible = true;
                    }
                }

                onReceived: bulkNumChange.visible = false
            }

            CounterBase {
                id: poison

                name: "Poison"
                count: 0
                editable: false
                disabled: counter.loss
                downDisabled: count == 0

                height: parent.height
                width: (parent.width/2)-1

                onCountChanged: {
                    if (count >= 10)
                        counter.loss = true;
                }
                onClickIntercept: scope.forceActiveFocus()
                onClicked: {
                    if (rqID == 1)
                    {
                        if (counter.dynToolbar.requestViewer(count,counter.rotation,poison))
                            bulkNumChange.visible = true;
                    }
                }

                onReceived: bulkNumChange.visible = false;
            }

        }
    }

    Numpad {
        id: bulkNumChange

        anchors.fill: parent

        visible: false

        onAppendDisplay: parent.dynToolbar.append(add)
        onAddNum: parent.dynToolbar.add(add)
        onBackspace: parent.dynToolbar.deleteLast()
    }

        function findRotation()
        {
            if (!name.activeFocus)
            {
                if (playerNum == 2)
                    return 180;
                else
                    return 0;
            }
            else
                return 0;
        }

        function reset()
        {
            life.count = 20;
            poison.count = 0;
            loss = false;
        }
    }
