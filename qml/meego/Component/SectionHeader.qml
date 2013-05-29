import QtQuick 1.1

Item {
    id: root

    property alias text: text.text;

    implicitWidth: parent.width; implicitHeight: text.height

    Rectangle {
        id: line
        anchors {
            left: parent.left
            right: text.left; rightMargin: constant.paddingLarge
            verticalCenter: parent.verticalCenter
        }
        color: constant.colorMid
        height: 1
    }

    Text {
        id: text
        anchors { right: parent.right; rightMargin: constant.paddingLarge }
        color: constant.colorMid
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        font.pixelSize: constant.fontSizeXSmall
        font.bold: true;
    }
}
