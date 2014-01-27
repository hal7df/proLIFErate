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
                if(counter.requestText(nameBack,name.text))
                {
                    parent.color = "#ffffff";
                    parent.border.color = "#000000";
                }
            }
        }

        function receive (value)
        {
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
                        counter.requestViewer(life,count);
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
                    if (count == 10)
                        counter.loss = true;
                }
                onClickIntercept: scope.forceActiveFocus()
                onClicked: {
                    if (rqID == 1)
                        counter.requestViewer(poison,count);
                }

                onReceived: bulkNumChange.visible = false;
            }

        }
    }

    Numpad {
        id: bulkNumChange

        anchors.fill: parent

        visible: false

        onAppendDisplay: parent.append(add)
        onAddNum: parent.addVal (add)
        onBackspace: parent.deleteLast()
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

        /*** Passthrough functions for the Dynamic Toolbar ***/

        function requestText (referrer,iVal)
        {
            return parent.requestText(referrer,iVal);
        }

        function requestViewer (referrer,iVal)
        {
            var retVal;

            retVal = parent.requestViewer(referrer,iVal,rotation);

            if (retVal)
                bulkNumChange.visible = true;

            return retVal;
        }

        function append (val)
        {
            return parent.append(val);
        }

        function addVal (val)
        {
            return parent.add(val);
        }

        function deleteLast ()
        {
            return parent.deleteLast();
        }

        function replace (val)
        {
            return parent.replace(val);
        }

        function getToolbarContents()
        {
            return parent.getToolbarContents();
        }
    }
