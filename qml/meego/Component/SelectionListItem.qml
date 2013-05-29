import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root;

    property alias title: title.text;
    property alias subTitle: subTitle.text;

    signal clicked;
    signal pressAndHold;

    implicitWidth: parent.width;
    implicitHeight: constant.graphicSizeLarge;

    Image {
        id: highlight
        anchors.fill: parent
        visible: false;
        source: theme.inverted ? "image://theme/meegotouch-panel-inverted-background-pressed"
                               : "image://theme/meegotouch-panel-background-pressed";
    }

    SplitLine { anchors.bottom: parent.bottom; }

    Column {
        spacing: constant.paddingSmall;
        anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge; verticalCenter: parent.verticalCenter; }
        Text {
            id: title;
            font.pixelSize: constant.fontSizeLarge;
            color: constant.colorLight;
        }
        Text {
            id: subTitle;
            font.pixelSize: constant.fontSizeSmall;
            font.weight: Font.Light;
            color: constant.colorMid;
        }
    }

    MouseArea {
        anchors.fill: parent;
        enabled: root.enabled;
        onClicked: root.clicked();
        onPressed: highlight.visible = true;
        onReleased: highlight.visible = false;
        onCanceled: highlight.visible = false;
        onPressAndHold: root.pressAndHold();
    }
}
