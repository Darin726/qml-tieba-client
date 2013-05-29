import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root;

    property alias iconSource: pic.source;
    property alias text: text.text;

    property alias paddingItem: paddingItem;
    signal clicked;

    implicitWidth: parent.width;
    implicitHeight: constant.graphicSizeLarge;

    Item {
        id: paddingItem;
        anchors {
            left: parent.left; leftMargin: constant.paddingLarge;
            right: parent.right; rightMargin: constant.paddingLarge;
            top: parent.top; topMargin: constant.paddingLarge;
            bottom: parent.bottom; bottomMargin: constant.paddingLarge;
        }
    }

    Image {
        id: highlight
        anchors.fill: parent
        visible: false;
        source: theme.inverted ? "image://theme/meegotouch-panel-inverted-background-pressed"
                               : "image://theme/meegotouch-panel-background-pressed";
    }

    Image {
        id: pic
        anchors {
            left: root.paddingItem.left; top: root.paddingItem.top;
            bottom: root.paddingItem.bottom;
        }
        width: height;
        sourceSize: Qt.size(width, height);
        cache: false;
    }
    Text {
        id: text;
        anchors {
            verticalCenter: parent.verticalCenter;
            left: pic.right; leftMargin: constant.paddingMedium;
            right: root.paddingItem.right;
        }
        font.pixelSize: constant.fontSizeLarge;
        color: constant.colorLight;
    }
    MouseArea {
        anchors.fill: parent;
        enabled: root.enabled;
        onClicked: root.clicked();
        onPressed: highlight.visible = true;
        onReleased: highlight.visible = false;
        onCanceled: highlight.visible = false;
    }
}
