import QtQuick 1.1
import com.nokia.symbian 1.1

AbstractDelegate {
    id: root;

    implicitHeight: borderImage.height + platformStyle.paddingLarge*2;
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
        source: root.platformInverted ? "../gfx/icon_thread_node.png"
                                      : "../gfx/icon_thread_node_1.png";
    }
    BorderImage {
        id: borderImage;
        anchors {
            left: icon.right; top: root.paddingItem.top; right: root.paddingItem.right;
        }
        source: root.platformInverted ? "../gfx/time_line_node_content.9.png"
                                      : "../gfx/time_line_node_content_skin_1.9.png";
        border { left: 20; top: 25; right: 10; bottom: 10; }
        height: contentCol.height + platformStyle.paddingMedium*2;
        Column {
            id: contentCol;
            anchors {
                left: parent.left; leftMargin: 10+platformStyle.paddingMedium;
                right: parent.right; rightMargin: 10;
                top: parent.top; topMargin: platformStyle.paddingMedium;
            }
            spacing: platformStyle.paddingMedium;
            Label {
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                platformInverted: root.platformInverted;
                text: (model.type == 1 ? qsTr("Reply:") : qsTr("Post:"))+model.title;
                font.pixelSize: platformStyle.fontSizeLarge;
            }
            Row {
                spacing: platformStyle.paddingLarge;
                ListItemText {
                    text: model.reply_time;
                    role: "SubTitle";
                    platformInverted: root.platformInverted;
                }
                Text {
                    text: model.fname + qsTr("Bar");
                    font {
                        family: platformStyle.fontFamilyRegular;
                        pixelSize: platformStyle.fontSizeSmall;
                    }
                    color: root.platformInverted ? "lightblue" : platformStyle.colorNormalMid;
                }
            }
        }
    }
}
