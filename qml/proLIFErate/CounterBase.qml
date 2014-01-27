import QtQuick 1.1

Rectangle {
    id: counterBase

    property string name
    property int count: 0
    property int stRqID     //Property to hold what is being edited
    property bool upDisabled: false
    property bool downDisabled: false
    property bool disabled: false
    property bool editable: true

    signal clickIntercept  //Signal that is fired whenever this object receives a click.
    signal clicked (int rqID)  //Signal that is fired when there is an edit property request.
    signal received //Signal that is fired when the counter receives data from the editor (numpad only)

    /** rqID values
      * 0: change name
      * 1: change count (by increments other than 1)
      *
      * The actual edit property request needs to be handled by the parent.
      */

    color: "#00000000"

    onClicked: stRqID = rqID

    Rectangle {
        id: counterDispContainer

        anchors { top: parent.top; right: parent.right; left: parent.left; margins: 2 }
        height: parent.height*0.62

        border { color: "#000000"; width: 2 }
        color: "#00000000"

        Item {
            id: countContain

            anchors.fill: parent

            Text {
                id: showCount

                anchors.centerIn: parent

                text: counterBase.count
                font.pointSize: parent.height*0.3
            }

            MouseArea {
                id: countChange

                anchors.fill: parent

                onClicked: counterBase.clicked(1)
                Component.onCompleted: clicked.connect(counterBase.clickIntercept)
            }
        }

        Item {
            id: labelContain

            anchors {top: parent.top; right: parent.right; left: parent.left }
            height: parent.height*0.17

            Text {
                id: label

                anchors.centerIn: parent

                text: counterBase.name
                font.pointSize: parent.height*0.5
            }

            MouseArea {
                id: labelChange

                anchors.fill: parent

                onClicked: {
                    if (editable)
                        counterBase.clicked(0)
                }

                Component.onCompleted: clicked.connect(counterBase.clickIntercept)
            }
        }
    }

    Grid {
        id: buttonAlign

        anchors { top: counterDispContainer.bottom; right: parent.right; left: parent.left; bottom: parent.bottom; topMargin: 2; bottomMargin: 2 }

        columns: 2
        spacing: 2

        IconButton {
            id: up

            height: parent.height
            width: (parent.width/2)-1

            source: "up"

            Component.onCompleted: clicked.connect(counterBase.clickIntercept)
            onClicked: counterBase.count++
            disabled: counterBase.upDisabled || counterBase.disabled
        }

        IconButton {
            id: down

            height: parent.height
            width: (parent.width/2)-1

            source: "down"

            Component.onCompleted: clicked.connect(counterBase.clickIntercept)
            onClicked: counterBase.count--
            disabled: counterBase.downDisabled || counterBase.disabled
        }
    }

    function receive (val)
    {
        if (val != undefined)
        {
            if (stRqID == 0)
                name = val;
            else
            {
                count = parseInt(val,10);
                console.log("Counter "+name+" received val "+val+", updated to "+count);
            }
        }
        received();
    }
}
