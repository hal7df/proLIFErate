import QtQuick 2.0

Item {
    id: counterBase

    property string name
    property int count: 0
    property int stRqID     //Property to hold what is being edited
    property bool upDisabled: false
    property bool downDisabled: count == 0
    property bool disabled: false
    property bool editable: true

    signal clickIntercept  //Signal that is fired whenever this object receives a click.
    signal clicked (int rqID)  //Signal that is fired when there is an edit property request.
    signal received //Signal that is fired when the counter receives data from the editor (numpad only)
    signal deleteCounter

    /** rqID values
      * 0: change name
      * 1: change count (by increments other than 1)
      *
      * The actual edit property request needs to be handled by the parent.
      */

    onClicked: stRqID = rqID

    Rectangle {
        id: counterDispContainer

        anchors { top: parent.top; right: parent.right; left: parent.left; bottom: parent.bottom; margins:2; bottomMargin: 4 }

        color: "#ffffff"

        Item {
            id: countContain

            anchors {
                top: labelContain.bottom
                right: parent.right
                left: parent.left
            }

            height: (0.75*parent.height)-labelContain.height

            Text {
                id: showCount

                anchors.centerIn: parent

                text: counterBase.count
                font.pixelSize: parent.height*0.5
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
                font.pixelSize: parent.height*0.75
            }

            MouseArea {
                id: labelChange

                anchors.fill: parent

                onClicked: {
                    if (counterBase.editable)
                        counterBase.clicked(0)
                }

                Component.onCompleted: clicked.connect(counterBase.clickIntercept)
            }

            IconWidget {
                id: delCount

                anchors {
                    top: parent.top;
                    right: parent.right;
                    bottom: parent.bottom
                    margins: 2
                }

                source: "delete"
                visible: counterBase.editable

                Component.onCompleted: clicked.connect(counterBase.deleteCounter)
            }
        }

        Grid {
            id: buttonAlign

            anchors {
                top: countContain.bottom
                right: parent.right
                left: parent.left
                bottom: parent.bottom
            }

            columns: 2
            spacing: 2

            IconWidget {
                id: up

                height: parent.height
                width: (parent.width/2)-1

                source: "up"

                Component.onCompleted: clicked.connect(counterBase.clickIntercept)
                onClicked: counterBase.count++
                disabled: counterBase.upDisabled || counterBase.disabled
            }

            IconWidget {
                id: down

                height: parent.height
                width: (parent.width/2)-1

                source: "down"

                Component.onCompleted: clicked.connect(counterBase.clickIntercept)
                onClicked: counterBase.count--
                disabled: counterBase.downDisabled || counterBase.disabled
            }
        }
    }

    Rectangle {
        id: perspective

        anchors {
            top: counterDispContainer.bottom
            right: counterDispContainer.right
            left: counterDispContainer.left
            bottom: parent.bottom
            bottomMargin: 2
            leftMargin: 2
            rightMargin: 2
        }

        color: "#cccccc"
    }

    function receive (val)
    {
        if (val != undefined)
        {
            if (stRqID == 0)
                name = val;
            else
                count = parseInt(val,10);
        }
        received();
    }
}
