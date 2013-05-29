import QtQuick 1.1
import com.nokia.symbian 1.1

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: platformStyle.paddingMedium;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            ListItemText {
                anchors.left: parent.left;
                text: model.author.name;
                platformInverted: root.platformInverted;
                role: "SubTitle";
            }
            ListItemText {
                anchors.right: parent.right;
                text: Qt.formatDateTime(new Date(model.time*1000), "yyyy-MM-dd hh:mm:ss");
                role: "SubTitle";
            }
        }
        Label {
            anchors { left: parent.left; right: parent.right; }
            text: model.content;
            font.pixelSize: tbsettings.fontSize;
            platformInverted: root.platformInverted;
            wrapMode: Text.Wrap;
            textFormat: Text.RichText;
            onLinkActivated: signalCenter.linkActivated(link);
        }
    }
}
