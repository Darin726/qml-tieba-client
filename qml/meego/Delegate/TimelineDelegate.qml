import QtQuick 1.1
import com.nokia.meego 1.0

AbstractDelegate {
    id: root;

    implicitHeight: borderImage.height + constant.paddingLarge*2;
    onClicked: {
        if (model.type == 1){
            if (model.is_floor == 1){
                app.enterFloor({ threadId: model.tid, subpostId: model.pid });
            } else {
                app.enterFloor({ threadId: model.tid, postId: model.pid });
            }
        } else {
            app.enterThread({ threadId: model.tid, title: model.title });
        }
    }

    Image {
        id: icon;
        anchors { top: root.paddingItem.top; left: root.paddingItem.left; }
        source: theme.inverted ? "../gfx/icon_thread_node_1.png"
                               : "../gfx/icon_thread_node.png";
    }
    BorderImage {
        id: borderImage;
        anchors {
            left: icon.right; top: root.paddingItem.top; right: root.paddingItem.right;
        }
        source: theme.inverted ? "../gfx/time_line_node_content_skin_1.9.png"
                               : "../gfx/time_line_node_content.9.png"
        border { left: 20; top: 25; right: 10; bottom: 10; }
        height: contentCol.height + constant.paddingMedium*2;
        Column {
            id: contentCol;
            anchors {
                left: parent.left; leftMargin: 10+constant.paddingMedium;
                right: parent.right; rightMargin: 10;
                top: parent.top; topMargin: constant.paddingMedium;
            }
            spacing: constant.paddingMedium;
            Text {
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                text: (model.type == 1 ? qsTr("Reply:") : qsTr("Post:"))+model.title;
                font.pixelSize: constant.fontSizeLarge;
                color: constant.colorLight;
            }
            Row {
                spacing: constant.paddingLarge;
                Text {
                    text: model.reply_time;
                    font { pixelSize: constant.fontSizeSmall; weight: Font.Light; }
                    color: constant.colorMid;
                }
                Text {
                    text: model.fname + qsTr("Bar");
                    font {
                        pixelSize: constant.fontSizeSmall;
                    }
                    color: theme.inverted ? constant.colorMid : "lightblue";
                }
            }
        }
    }
}
