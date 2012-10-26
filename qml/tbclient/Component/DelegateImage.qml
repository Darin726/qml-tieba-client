import QtQuick 1.1

Item {
    id: root

    implicitWidth: platformStyle.graphicSizeMedium
    implicitHeight: platformStyle.graphicSizeMedium

    MouseArea {
        anchors.fill: parent
        onClicked: {
            signalCenter.linkActivated("img:"+modelData[1])
            try { placeHolder.opacity = 0.5 } catch(e){}
        }
    }
    Image {
        id: placeHolder
        sourceSize: Qt.size(platformStyle.graphicSizeMedium, platformStyle.graphicSizeMedium)
        source: "qrc:/gfx/photos.svg"
    }

    Image {
        sourceSize.width: 300
        onStatusChanged: if (status == Image.Ready) {
                             root.width = paintedWidth
                             root.height = paintedHeight
                             placeHolder.destroy()
                         }
        Component.onCompleted: {
            if (tbsettings.showImage){
                source = modelData[1]
            }
        }
    }
}
