import QtQuick 2.0

Rectangle {
    id: root

    property alias dynToolbar: toolbar

    width: 480
    height: 800

    CounterView {
        id: bottomScreen

        anchors {
            bottom: parent.bottom
            right: parent.right
            top: toolbar.bottom
            left: parent.left
        }

        viewer: 1
        model: players
        dynToolbar: toolbar
        otherViewAt: topScreen.playerAt

        Connections {
            onPlayerAtChanged: topScreen.otherViewAt = bottomScreen.playerAt
        }
    }

    CounterView {
        id: topScreen

        anchors {
            bottom: toolbar.top
            right: parent.right
            top: parent.top
            left: parent.left
        }

        viewer: 2
        dynToolbar: toolbar
        model: players
        otherViewAt: bottomScreen.playerAt
        rotation: 180

        Connections {
            onPlayerAtChanged: bottomScreen.otherViewAt = topScreen.playerAt
        }
    }

    DynamicToolbar {
        id: toolbar
        anchors.verticalCenter: parent.verticalCenter
        color: appColor

        z: 30

        IconWidget {
            id: restartGame

            anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }

            source: "restart"

            onClicked: {
                var selectPlayer;
                var playerShown;

                players.reset();

                selectPlayer = Math.floor((Math.random()*players.count));

                if (topScreen.playerAt == selectPlayer)
                    topScreen.flashPlayer(selectPlayer);
                else
                    bottomScreen.flashPlayer(selectPlayer);
            }
        }

        IconWidget {
            id: selectPlayer
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left; leftMargin: (parent.width/10) }
            source: "select"
            onClicked: {
                var selectPlayer

                selectPlayer = Math.floor((Math.random()*players.count));

                if (topScreen.playerAt == selectPlayer)
                    topScreen.flashPlayer(selectPlayer);
                else
                    bottomScreen.flashPlayer(selectPlayer);
            }
        }
    }

    NewButton {
        id: newButton

        anchors {
            right: parent.right
        }

        color: appColor
        anchors.verticalCenter: toolbar.verticalCenter
        anchors.rightMargin: (width/4)
        z: 31

        visible: !toolbar.editing

        onClicked: {
            players.append({"name": "Player "+(players.count+1),
                               counters: [{"counterName": "Life", "lCount": 20, "edit": false}, {"counterName": "Poison", "lCount": 0, "edit": false}],
                               "active": true});

            console.log("Clicked");
        }

        onPressAndHold: {
            if (players.count > 2)
                players.remove(players.count-1);

            console.log("Press and Hold");
        }
    }

    Rectangle {
        id: toolbarShadow

        anchors {
            right: parent.right
            verticalCenter: toolbar.verticalCenter
            left: toolbar.left
        }

        height: toolbar.height+(toolbar.height/5)
        z: 29

        gradient: Gradient {
            GradientStop {position: 0.0; color: "#00000000"}
            GradientStop {position: 0.083; color: "#33000000"}
            GradientStop {position: 0.917; color: "#33000000"}
            GradientStop {position: 1.0; color: "#00000000"}
        }
    }

    ListModel {
        id: players

        ListElement {
            name: "Player 1"
            active: true

            counters: [
                ListElement {
                    counterName: "Life"
                    lCount: 20
                    edit: false
                } ,
                ListElement {
                    counterName: "Poison"
                    lCount: 0
                    edit: false
                }

            ]
        }

        ListElement {
            name: "Player 2"
            active: true

            counters: [
                ListElement {
                    counterName: "Life"
                    lCount: 20
                    edit: false
                } ,
                ListElement {
                    counterName: "Poison"
                    lCount: 0
                    edit: false
                }

            ]
        }

        function reset ()
        {
            for (var x = 0; x < count; x++)
            {
                for (var y = 0; y < get(x).counters.count; y++)
                {
                    if (get(x).counters.get(y).counterName == "Life")
                        get(x).counters.setProperty(y,"lCount",20);
                    else
                        get(x).counters.setProperty(y,"lCount",0);
                }
            }
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
