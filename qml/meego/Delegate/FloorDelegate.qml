import QtQuick 1.1
import com.nokia.meego 1.0

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: constant.paddingMedium;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors.left: parent.left;
                text: model.author.name;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
            Text {
                anchors.right: parent.right;
                text: Qt.formatDateTime(new Date(model.time*1000), "yyyy-MM-dd hh:mm:ss");
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            text: model.content;
            font.pixelSize: tbsettings.fontSize;
            color: constant.colorLight;
            wrapMode: Text.Wrap;
            textFormat: Text.RichText;
            onLinkActivated: signalCenter.linkActivated(link);
        }
    }
}
