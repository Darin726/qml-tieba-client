import QtQuick 1.1
import com.nokia.meego 1.0
import "../Delegate"
import "../Component"
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitWidth: screen.rotation === 0 || screen.rotation === 180 ? screen.displayWidth : screen.displayHeight
    implicitHeight: contentCol.height + constant.paddingLarge*2;

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left; right: root.paddingItem.right; top: root.paddingItem.top;
        }
        spacing: constant.paddingMedium;
        Row {
            spacing: constant.paddingMedium;
            Image {
                width: constant.graphicSizeMedium;
                height: constant.graphicSizeMedium;
                source: Calc.getAvatar(modelData.author.portrait);
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                text: modelData.author.name_show + "\n" + modelData.time_ex;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: replyCol.height + constant.paddingMedium*2;
            BorderImage {
                anchors.fill: parent;
                border { left: 5; top: 5; right: 5; bottom: 5; }
                source: theme.inverted ? "../gfx/nearby_post_bg_1.9.png"
                                       : "../gfx/nearby_post_bg.9.png";
            }
            Column {
                id: replyCol;
                anchors {
                    left: parent.left; right: parent.right; top: parent.top;
                    margins: constant.paddingMedium;
                }
                Repeater {
                    model: modelData.contentData;
                    Loader {
                        sourceComponent: modelData[0] ? contentLabel : contentImg;
                        Component {
                            id: contentLabel;
                            Text {
                                width: replyCol.width;
                                wrapMode: Text.Wrap;
                                font.pixelSize: tbsettings.fontSize;
                                color: constant.colorLight;
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
