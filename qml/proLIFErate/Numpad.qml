import QtQuick 1.1

Rectangle {
    id: numpad

    signal appendDisplay (int add)
    signal addNum (int add)
    signal backspace

    color: "#c6333333"

    MouseArea {
        id: clickIntercept

        anchors.fill: parent
    }

    Item {
        id: numpadWrap

        anchors { fill: parent; margins: 2 }

        Grid {
            id: numbers

            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }

            width: parent.width*0.75

            columns: 3
            rows: 4
            spacing: 2

            Repeater {
                id: numHolder
                model: 9

                Button {
                    property int num: index+1

                    height: (numbers.height/4)-1
                    width: (numbers.width/3)-1

                    text: num

                    onClicked: numpad.appendDisplay(num)
                }
            }

            Button {
                height: (numbers.height/4)-1
                width: (numbers.width/3)-1

                text: "0"

                onClicked: numpad.appendDisplay(0)
            }

            Item {
                height: (numbers.width/4)-1
                width: (numbers.width/3)-1
            }

            IconButton {
                height: (numbers.height/4)-1
                width: (numbers.width/3)-1

                source: "backspace"

                onClicked: numpad.backspace()
            }
        }

        Rectangle {
            anchors { left: numbers.right; top: parent.top; right: addButtons.left; bottom: parent.bottom; margins: 2 }
            color: "#66d2d2d2"
        }

        Grid {
            id: addButtons

            anchors { left: numbers.right; top: parent.top; right: parent.right; bottom: parent.bottom; leftMargin: 5 }

            columns: 1
            rows: 4
            spacing: 2

            Button {
                id: plusFive

                width: parent.width
                height: (addButtons.height/4)-1

                text: "+5"

                onClicked: numpad.addNum(5)
            }

            Button {
                id: plusTen

                width: parent.width
                height: (addButtons.height/4)-1

                text: "+10"

                onClicked: numpad.addNum(10)
            }

            Button {
                id: minusFive

                width: parent.width
                height: (addButtons.height/4)-1

                text: "-5"

                onClicked: numpad.addNum(-5);
            }

            Button {
                id: minusTen

                width: parent.width
                height: (addButtons.height/4)-1

                text: "-10"

                onClicked: numpad.addNum(-10);
            }
        }
    }
}
