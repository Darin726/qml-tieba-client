import QtQuick 1.1

Item {
    id: root

    implicitWidth: platformStyle.graphicSizeMedium
    implicitHeight: platformStyle.graphicSizeMedium

    MouseArea {
        anchors.fill: parent
        onClicked: {
            signalCenter.linkActivated("img:"+modelData[1])
            root.opacity = 0.6
        }
    }

    Image {
        id: placeHolder
        anchors.centerIn: parent
        sourceSize: Qt.size(platformStyle.graphicSizeMedium,
                            platformStyle.graphicSizeMedium)
        source: "qrc:/gfx/photos.svg"
    }

    Image {
        anchors.fill: parent;
        sourceSize: Qt.size(width, height)
        opacity: 0
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        onStatusChanged: {
            if (status == Image.Ready){
                placeHolder.visible = false;
                opacity = 1;
            }
        }
        Component.onCompleted: {
            if (tbsettings.showImage){
                var s = modelData[2].split(",")
                if (s[0] <= 270){
                    root.width = s[0]; root.height = s[1]
                } else {
                    root.width = 270; root.height = Math.floor(270/s[0]*s[1])
                }
                source = modelData[1]
            }
        }
    }
}
