import QtQuick 1.1

Rectangle {
    id: counter

    property int playerNum
    property bool isNormalColor: color == "#00000000" ? true : false
    property bool loss: false

    color: "#00000000"
    height: parent.height/2
    rotation: playerNum == 2 ? 180 : 0

    onLossChanged: {
        if (loss)
            color = "#40ff0000";
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

        Item {
            id: statsDisplay
            anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 2; bottom: parent.bottom }

            Rectangle {
                id: lifeBack
                anchors { top: parent.top; left: parent.left; right: parent.horizontalCenter; bottom: parent.bottom; margins: 2 }
                radius: 3
                border { color: "#000000"; width: 2 }
                gradient: Gradient {
                    GradientStop { position: 1.0; color: "#ffffff" }
                    GradientStop { position: 0.0; color: "#6f6f6f" }
                }

                MouseArea {
                    id: lifeFocusIntercept
                    anchors.fill: parent
                    onClicked: scope.forceActiveFocus()
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
            }

            Rectangle {
                id: poisonBack
                anchors { top: parent.top; left: parent.horizontalCenter; right: parent.right; bottom: parent.bottom; margins: 2 }
                radius: 3
                border { color: "#000000"; width: 2 }
                gradient: Gradient {
                    GradientStop { position: 1.0; color: "#ffffff" }
                    GradientStop { position: 0.0; color: "#6f6f6f" }
                }

                MouseArea {
                    id: poisonFocusIntercept
                    anchors.fill: parent
                    onClicked: scope.forceActiveFocus()
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

        Item {
            id: countButtons
            anchors { top: scope.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; topMargin: 2; bottomMargin: 2 }

            Text {
                id: lifeLabel
                anchors { top: parent.top; left: parent.left; right: parent.horizontalCenter }
                text: "Life"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
            }

            IconButton {
                id: lifeUp
                source: "up"
                anchors { top: lifeLabel.bottom; left: parent.left; bottom: parent.bottom; margins: 2 }
                width: (parent.width/4)-2
                onClicked: life.lifeCount++
                disabled: life.lifeCount <= 0 || poison.poisonCount >= 10
            }

            IconButton {
                id: lifeDown
                source: "down"
                anchors {top: lifeLabel.bottom; left: lifeUp.right; right: parent.horizontalCenter; bottom: parent.bottom; margins: 2 }
                onClicked: life.lifeCount--
                disabled: life.lifeCount <= 0 || poison.poisonCount >= 10
            }

            Text {
                id: poisonLabel
                anchors { top: parent.top; left: parent.horizontalCenter; right: parent.right }
                text: "Poison"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
            }

            IconButton {
                id: poisonUp
                source: "up"
                anchors { top: poisonLabel.bottom; left: lifeDown.right; bottom: parent.bottom; margins: 2 }
                width: (parent.width/4)-2
                onClicked: poison.poisonCount++
                disabled: poison.poisonCount >= 10 || life.lifeCount <= 0
            }

            IconButton {
                id: poisonDown
                source: "down"
                anchors {top: poisonLabel.bottom; left: poisonUp.right; right: parent.right; bottom: parent.bottom; margins: 2 }
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
