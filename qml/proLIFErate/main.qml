import QtQuick 2.0

Rectangle {
    id: root

    property alias dynToolbar: toolbar

    width: 480
    height: 800
    color: "#e7ece6"

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
    }

    DynamicToolbar {
        id: toolbar
        anchors.verticalCenter: parent.verticalCenter

        IconWidget {
            id: restartGame

            anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }

            source: "restart"

            onClicked: {
                var selectPlayer;
                var playerShown;

                players.reset();

                selectPlayer = Math.floor((Math.random()*players.count));

                if (topScreen.playerAt == selectPlayer) for a counter application:
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

        IconWidget {
            id: addPlayer
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right; rightMargin: (parent.width/10) }
            source: "add"

            onClicked: {
                players.append({"name": "Player "+(players.count+1),
                                   counters: [{"counterName": "Life", "lCount": 20, "edit": false}, {"counterName": "Poison", "lCount": 0, "edit": false}],
                                   "active": true});
            }
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
