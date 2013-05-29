import QtQuick 1.0
import com.nokia.symbian 1.0
import "../Delegate"
import "../Component"
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitWidth: screen.width;
    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left; right: root.paddingItem.right; top: root.paddingItem.top;
        }
        spacing: platformStyle.paddingMedium;
        Row {
            spacing: platformStyle.paddingMedium;
            Image {
                width: platformStyle.graphicSizeMedium;
                height: platformStyle.graphicSizeMedium;
                source: Calc.getAvatar(modelData.author.portrait);
            }
            ListItemText {
                anchors.verticalCenter: parent.verticalCenter;
                role: "SubTitle";
                text: modelData.author.name_show + "\n" + modelData.time_ex;
            }
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: replyCol.height + platformStyle.paddingMedium*2;
            BorderImage {
                anchors.fill: parent;
                border { left: 5; top: 5; right: 5; bottom: 5; }
                source: "../gfx/nearby_post_bg_1.9.png";
            }
            Column {
                id: replyCol;
                anchors {
                    left: parent.left; right: parent.right; top: parent.top;
                    margins: platformStyle.paddingMedium;
                }
                Repeater {
                    model: modelData.contentData;
                    Loader {
                        sourceComponent: modelData[0] ? contentLabel : contentImg;
                        Component {
                            id: contentLabel;
                            Label {
                                width: replyCol.width;
                                wrapMode: Text.Wrap;
                                font.pixelSize: tbsettings.fontSize;
                                onLinkActivated: signalCenter.linkActivated(link);
                                textFormat: modelData[2] ? Text.RichText : Text.PlainText;
                                text: modelData[2] ? modelData[1].replace(/\n/g,"<br/>") : modelData[1];
                            }
                        }
                        Component {
                            id: contentImg;
                            PostImage {}
                        }
                    }
                }
            }
        }
    }
}
