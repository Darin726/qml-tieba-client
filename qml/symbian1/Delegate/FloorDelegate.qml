import QtQuick 1.0
import com.nokia.symbian 1.0

AbstractDelegate {
    id: root;

    height: contentCol.height + platformStyle.paddingLarge*2;

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
                role: "SubTitle";
            }
            ListItemText {
                anchors.right: parent.right;
                text: Qt.formatDateTime(new Date(model.time*1000), "yyyy-MM-dd hh:mm:ss");
                role: "SubTitle";
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            text: model.content;
            font.pixelSize: tbsettings.fontSize;
            color: "white";
            wrapMode: Text.Wrap;
            textFormat: Text.RichText;
            onLinkActivated: signalCenter.linkActivated(link);
        }
    }
}
