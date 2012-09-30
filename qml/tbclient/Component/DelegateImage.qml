import QtQuick 1.1

Item {
    id: root

    implicitWidth: platformStyle.graphicSizeMedium
    implicitHeight: platformStyle.graphicSizeMedium

    MouseArea {
        anchors.fill: parent
        onClicked: {
            signalCenter.linkActivated("img:"+modelData[1])
        }
    }
    Image {
        id: placeHolder
        sourceSize: Qt.size(platformStyle.graphicSizeMedium, platformStyle.graphicSizeMedium)
        source: "qrc:/gfx/photos.svg"
    }
    Image {
        sourceSize.width: 250
        onStatusChanged: if (status == Image.Ready) {
                             root.width = paintedWidth
                             root.height = paintedHeight
                             placeHolder.destroy()
                         }
        Component.onCompleted: if (tbsettings.showImage)
                                   source = modelData[1]
    }
}
