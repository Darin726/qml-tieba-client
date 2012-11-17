import QtQuick 1.1

Row {
    spacing: platformStyle.paddingSmall
    Repeater {
        id: repeater
        model: modelData.pic
        Image {
            id: pic
            width: repeater.count == 1 ? 300 : repeater.count == 2 ? 150 : 100
            height: 75;
            sourceSize.height: 75;
            source: modelData
            fillMode: Image.PreserveAspectFit
            Image {
                anchors.fill: parent;
                visible: pic.status != Image.Ready
                source: visible ? "qrc:/gfx/photos.svg" : ""
                asynchronous: true
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}
