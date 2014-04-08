import QtQuick 1.1


Toolbar {
    id: dynamicToolbar

    property bool editing: false
    property int editType: 0
    property alias contents: input.text

    property Item caller

    /* editType values:
     * 0: Normal TextInput
     * 1: From external editing source
     */

    signal editingDone (variant value)

    onEditingChanged: {
        var x;

        if (editing)
        {
            for (x=0; x<children.length; x++)
                children[x].visible=false;

            done.visible = true;
            cancel.visible = true;
            inputBack.visible = true
        }
        else
        {
            for (x=0; x<children.length; x++)
                children[x].visible = true;

            done.visible = false;
            cancel.visible = false;
            inputBack.visible = false;
        }
    }

    onEditingDone: {
        rotation = 0;
        editing = false;
        caller.receive(value);
    }

    IconWidget {
        id: done

        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }

        source: "accept"
        visible: parent.editing

        onClicked: parent.editingDone(input.text)
    }

    IconWidget {
        id: cancel

        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }

        source: "cancel"
        visible: parent.editing

        onClicked: parent.editingDone(undefined);
    }

    Rectangle {
        id: inputBack

        anchors { left: cancel.right; top: parent.top; right: done.left; bottom: parent.bottom }
        visible: parent.editing

        color: "#ffffff"

        TextInput {
            id: input

            anchors.centerIn: parent
            width: parent.width

            horizontalAlignment: Text.AlignHCenter
            font.pointSize: parent.height*0.6
            readOnly: dynamicToolbar.editType != 0

            onAccepted: dynamicToolbar.editingDone(text)
            inputMethodHints: Qt.ImhNoPredictiveText
        }
    }

    /***** Dynamic Toolbar API Functions *****/

    /** requestText: Request a standard text editor in the toolbar.
      * Returns true if the text editor was initialized.
      * Returns false if editing in the toolbar was locked by another component.
      */

    function requestText (iVal,call)
    {
        if (!editing)
        {
            editType = 0;
            input.text = iVal;
            caller = call;
            editing = true;

            return true;
        }
        else
            return false;
    }

    /** requestViewer: Request a value viewer
      * To be used when another component provides the input
      * Returns true if the viewer was set up
      * Returns false if editing is locked by another component
      */

    function requestViewer (iVal, nRot, call)
    {
        if (!editing)
        {
            editType = 1;
            input.text = iVal;
            editing = true;
            caller = call;
            rotation = nRot;

            return true;
        }
        else
            return false;
    }

    /* Functions for input from another component */

    /** append: Append a value to the contents of the viewer
      * Returns true if successful
      * Returns false if unsuccessful
      */

    function append (val)
    {
        if (editing && editType == 1)
        {
            input.text = input.text + val;

            return true;
        }
        else
            return false;
    }

    /** add: Adds a number to the contents assuming they compose a number
      * Returns true if successful
      * Returns false if unsuccessful
      */

    function add (val)
    {
        if (editing && editType == 1 && parseInt(input.text) != NaN)
        {
            if (parseInt(input.text)+val >= 0)
            {
                input.text = parseInt(input.text) + val;
                return true;
            }
            else
                return false;
        }
        else
            return false;
    }

    /** replace: Replaces the contents of the viewer
      * Returns true if successful
      * Returns false if unsuccessful
      */

    function replace (val)
    {
        if (editing && editType == 1)
        {
            input.text = val;

            return true;
        }
        else
            return false;
    }

    /** deleteLast: Deletes the last character in the toolbar.
      * Returns true if successful
      * Returns false if unsuccessful
      */

    function deleteLast ()
    {
        if (editing && editType == 1 && input.text.length > 0)
        {
            input.text = input.text.substring(0,input.text.length-1);
            return true;
        }
        else
            return false;
    }
}
