import QtQuick 1.1


Toolbar {
    id: dynamicToolbar

    property bool editing: false
    property int editType: 0
    property string contents

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
            inputBack.visible = true
        }
        else
        {
            for (x=0; x<children.length; x++)
                children[x].visible = true;

            done.visible = false;
            inputBack.visible = false;
        }
    }

    onEditingDone: {
        rotation = 0;
        editing = false;
    }

    IconWidget {
        id: done

        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }

        source: "accept"
        visible: parent.editing

        onClicked: {
            parent.editingDone(input.text);
        }
    }

    Rectangle {
        id: inputBack

        anchors { left: parent.left; top: parent.top; right: done.left; bottom: parent.bottom }
        visible: parent.editing

        color: "#ffffff"

        TextInput {
            id: input

            anchors.centerIn: parent
            width: parent.width

            horizontalAlignment: Text.AlignHCenter
            font.pointSize: parent.height*0.6
            text: dynamicToolbar.contents
            readOnly: dynamicToolbar.editType != 0

            onAccepted: dynamicToolbar.editingDone(text)
        }
    }

    /***** Dynamic Toolbar API Functions *****/

    /** requestText: Request a standard text editor in the toolbar.
      * Returns true if the text editor was initialized.
      * Returns false if editing in the toolbar was locked by another component.
      */

    function requestText (iVal)
    {
        if (!editing)
        {
            editType = 0;
            contents = iVal;
            input.text = iVal;
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

    function requestViewer (iVal, nRot)
    {
        if (!editing)
        {
            editType = 1;
            contents = iVal;
            input.text = contents;
            editing = true;
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
            contents = contents + val;
            console.log("Updated to "+contents);

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
            input.text = parseInt(input.text) + val;
            return true;
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
            contents = val;

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
        console.log(input.length);
        if (editing && editType == 1 && input.length > 0)
        {
            contents = contents.substring(0,contents.length-1);
            contents = input.text;
            return true;
        }
        else
            return false;
    }
}
