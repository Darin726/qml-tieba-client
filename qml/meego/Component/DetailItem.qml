import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root;

    property alias title: itemText.text;
    property alias subTitle: subTitleText.text;

    property bool inverted: true;

    signal clicked;

    property QtObject platformStyle: SelectionDialogStyle {
        itemTextColor: root.inverted ? "white" : "black";
    }

    enabled: false;
    height: root.platformStyle.itemHeight
    anchors.left: parent.left
    anchors.right: parent.right

    MouseArea {
        id: delegateMouseArea
        anchors.fill: parent;
        onClicked:  root.clicked();
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: root.platformStyle.itemBackgroundColor;
    }

    BorderImage {
        id: background
        anchors.fill: parent
        border { left: 22; top: 22; right: 22; bottom: 22 }
        source: delegateMouseArea.pressed ? root.platformStyle.itemPressedBackground :
                root.platformStyle.itemBackground
    }

    Text {
        id: itemText
        elide: Text.ElideRight
        color: root.platformStyle.itemTextColor
        anchors.top: parent.top;
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.platformStyle.itemLeftMargin
        anchors.rightMargin: root.platformStyle.itemRightMargin
        font: root.platformStyle.itemFont
    }

    Text {
        id: subTitleText;
        color: root.platformStyle.itemTextColor;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.platformStyle.itemLeftMargin
        anchors.rightMargin: root.platformStyle.itemRightMargin
        horizontalAlignment: Text.AlignRight;
        font {
            family: itemText.font.family;
            pixelSize: constant.fontSizeSmall;
            weight: Font.Light;
        }
    }
}
