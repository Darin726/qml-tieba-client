import QtQuick 1.1
import com.nokia.symbian 1.1

ListItem {
    id: root;

    property alias iconSource: pic.source;
    property alias text: text.text;

    subItemIndicator: true;
    platformInverted: tbsettings.whiteTheme;

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
    ListItemText {
        id: text;
        anchors {
            verticalCenter: parent.verticalCenter;
            left: pic.right; leftMargin: platformStyle.paddingMedium;
            right: root.paddingItem.right;
        }
        platformInverted: root.platformInverted;
    }
}
