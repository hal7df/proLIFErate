import QtQuick 1.1

Rectangle {
    id: counter

    property int playerNum
    property bool isNormalColor: color == "#00000000"
    property bool loss: false

    color: "#00000000"
    height: parent.height/2
    rotation: playerNum == 2 ? 180 : 0

    onLossChanged: {
        if (loss)
            color = "#ff4444";
    }

    onColorChanged: {
        if (color != "#00000000")
            colorAnimate.start();
    }

    PropertyAnimation on color { id: colorAnimate; running: counter.isNormalColor; to: "#00000000"; duration: 1500 }

    Rectangle {
        id: nameBack
        anchors { margins: 5; top: parent.top; right: parent.right; left: parent.left }
        height: parent.height/6
        visible: name.focus
        color: "#ffffff"
        border.color: "#000000"
    }

    TextInput {
        id: name
        anchors.centerIn: nameBack
        width: nameBack.width - 5
        text: "Player "+parent.playerNum
        selectByMouse: true
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 30

        property bool defaultText: true

        onFocusChanged: {
            if (activeFocus)
                counter.rotation = 0;
            else
            {
                if (playerNum == 1)
                    counter.rotation = 0;
                else
                    counter.rotation = 180;
            }
        }
        onTextChanged: defaultText = false

    }

    FocusScope {
        id:scope
        anchors { top: nameBack.bottom; right: parent.right; left: parent.left }
        height: counter.height/2

        MouseArea {
            id: backFocusIntercept
            anchors.fill: parent
            onClicked: parent.forceActiveFocus()
        }

        Grid {
            id: statsDisplay
            anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; topMargin: 2; leftMargin: 2; rightMargin: 2 }

            columns: 2
            spacing: 4

            Rectangle {
                id: lifeBack

                height: parent.height-2
                width: (parent.width/2)-2

                border { color: "#000000"; width: 2 }

                color: "#00000000"

                MouseArea {
                    id: lifeFocusIntercept
                    anchors.fill: parent
                    onClicked: scope.forceActiveFocus()
                }

                Text {
                    id: lifeLabel
                    anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 2 }
                    text: "Life"
                    font.pointSize: 16
                }

                Text {
                    id: life
                    anchors.centerIn: parent
                    text: lifeCount
                    font.pointSize: 48

                    property int lifeCount: 20

                    onLifeCountChanged: {
                        if (lifeCount <= 0)
                            counter.loss = true;
                    }
                    }
                }

            Rectangle {
                id: poisonBack

                height: parent.height-2
                width: (parent.width/2)-2

                border { color: "#000000"; width: 2 }

                color: "#00000000"

                MouseArea {
                    id: poisonFocusIntercept
                    anchors.fill: parent
                    onClicked: scope.forceActiveFocus()
                }

                Text {
                    id: poisonLabel
                    anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 2 }
                    text: "Poison"
                    font.pointSize: 16
                }

                Text {
                    id: poison
                    anchors.centerIn: parent
                    text: poisonCount
                    font.pointSize: 48

                    property int poisonCount: 0

                    onPoisonCountChanged: {
                        if (poisonCount >= 10)
                            counter.loss = true
                    }
                }
            }
        }
    }

        Grid {
            id: buttonAlign
            anchors { top: scope.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; topMargin: 2; bottomMargin: 2 }
            columns: 4

            spacing: 2

            IconButton {
                id: lifeUp
                source: "up"

                width: (parent.width/4)-2
                height: parent.height-1

                onClicked: life.lifeCount++
                disabled: life.lifeCount <= 0 || poison.poisonCount >= 10
            }

            IconButton {
                id: lifeDown
                source: "down"

                width: (parent.width/4)-2
                height: parent.height-1

                onClicked: life.lifeCount--
                disabled: life.lifeCount <= 0 || poison.poisonCount >= 10
            }

            IconButton {
                id: poisonUp
                source: "up"


                width: (parent.width/4)-2
                height: parent.height-1

                onClicked: poison.poisonCount++
                disabled: poison.poisonCount >= 10 || life.lifeCount <= 0
            }

            IconButton {
                id: poisonDown
                source: "down"

                width: (parent.width/4)-2
                height: parent.height-1

                onClicked: poison.poisonCount--
                disabled: poison.poisonCount >= 10 || life.lifeCount <= 0 || poison.poisonCount <= 0
            }
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
            life.lifeCount = 20;
            poison.poisonCount = 0;
            loss = false;
        }
    }
