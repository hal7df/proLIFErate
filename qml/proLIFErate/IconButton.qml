import QtQuick 1.1

Button
{
    id: iconButtonContainer

    property string source: ""
    property bool srcAbsolute: false
    property alias iconRotation: image.rotation

        Image {

            id: image
            anchors.fill: parent
            anchors.margins: parent.srcAbsolute ? 0.1*parent.width : 0
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: getIconResolution()
            states: State {
                    name: "greyedOut"; when: iconButtonContainer.disabled
                    PropertyChanges { target: image; opacity: 0.24 }
                }

            function getIconResolution()
            {
                if (!iconButtonContainer.srcAbsolute)
                    if (height < 48)
                        return "images/mdpi/ic_"+iconButtonContainer.source+".png";
                    else if (height >= 48 && height < 64)
                        return "images/hdpi/ic_"+iconButtonContainer.source+".png";
                    else
                        return "images/xhdpi/ic_"+iconButtonContainer.source+".png";
                else
                    return iconButtonContainer.source;
            }
        }
}
