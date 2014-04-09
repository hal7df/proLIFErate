import QtQuick 2.0

Rectangle {
    id: root

    property alias dynToolbar: toolbar

    width: 480
    height: 800
    color: "#e7ece6"

    Display {
        id: player1
        anchors { bottom: parent.bottom; right: parent.right; top: toolbar.bottom; left: parent.left }
        playerNum: 1
    }

    Display {
        id: player2
        anchors { bottom: toolbar.top; top: parent.top; right: parent.right; left: parent.left }
        playerNum: 2
        rotation: 180
    }

    DynamicToolbar {
        id: toolbar
        anchors.verticalCenter: parent.verticalCenter

        IconWidget {
            id: restartGame

            anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }

            source: "restart"

            onClicked: {
                var selectPlayer

                player1.reset();
                player2.reset();

                selectPlayer = Math.floor((Math.random()*10)+1);

                if ((selectPlayer % 2) == 1)
                    player1.color = "#66cc00";
                else
                    player2.color = "#66cc00"
            }
        }

        IconWidget {
            id: selectPlayer
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left; leftMargin: (parent.width/10) }
            source: "select"
            onClicked: {
                var selectPlayer

                selectPlayer = Math.floor((Math.random()*10)+1);

                if ((selectPlayer % 2) == 1)
                    player1.color = "#66cc00";
                else
                    player2.color = "#66cc00"
            }
        }

        IconWidget {
            id: addPlayer
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right; rightMargin: (parent.width/10) }
            source: "add"

            onClicked: {
                players.append({"name": "player", "life":20, "poison":0, "active": true});
            }
        }
    }

    ListModel {
        id: players

        ListElement {
            name: "Player 1"
            life: 20
            poison: 0

            active: true
        }

        ListElement {
            name: "Player 2"
            life: 20
            poison: 0

            active: true
        }
    }

    /*** Passthrough functions for the Dynamic Toolbar ***/

    function requestText (referrer,iVal)
    {
        var success;
        success = toolbar.requestText(iVal);

        if (success)
            toolbarRefer = referrer;

        return success;
    }

    function requestViewer (referrer,iVal,nRot)
    {
        var success;
        success = toolbar.requestViewer(iVal,nRot);

        if (success)
            toolbarRefer = referrer;

        return success;
    }

    function append (val)
    {
        return toolbar.append(val);
    }

    function add (val)
    {
        return toolbar.add(val);
    }

    function deleteLast ()
    {
        return toolbar.deleteLast();
    }

    function replace (val)
    {
        return toolbar.replace(val);
    }

    function getToolbarContents()
    {
        return toolbar.contents;
    }
}
