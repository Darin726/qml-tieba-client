import QtQuick 1.1
import com.nokia.meego 1.0
import "../Delegate"
import "../Component"
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;
    onClicked: {
        var p = pageStack.push(Qt.resolvedUrl("NearbyContentPage.qml"),
                               { threadId: model.tid });
        p.getlist();
    }

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: constant.paddingMedium;
        Repeater {
            model: content.list;
            Loader {
                source: modelData[0] ? "../Component/PostLabel.qml" : "../Component/PostImage.qml";
            }
        }
        Row {
            spacing: constant.paddingMedium;
            Image {
                width: constant.graphicSizeMedium;
                height: constant.graphicSizeMedium;
                source: Calc.getAvatar(model.author.portrait)
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                text: model.author.name_show + "\n" + model.time;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
        Loader {
            anchors { left: parent.left; leftMargin: constant.paddingMedium; right: parent.right; }
            visible: model.reply_num > 0;
            sourceComponent: model.reply_num > 0 ? replyComp : undefined;
            Component {
                id: replyComp;
                Item {
                    width: parent.width;
                    height: replyCol.height + constant.paddingMedium*2+5;
                    BorderImage {
                        anchors.fill: parent;
                        source: theme.inverted ? "../gfx/nearby_reply_bg_1.9.png"
                                               : "../gfx/nearby_reply_bg.9.png";
                        border { left: 32; right: 10; top: 15; bottom: 10; }
                    }
                    Column {
                        id: replyCol;
                        anchors {
                            left: parent.left; leftMargin: constant.paddingMedium;
                            top: parent.top; topMargin: constant.paddingMedium+5;
                            right: parent.right; rightMargin: constant.paddingMedium;
                        }
                        spacing: constant.paddingSmall;
                        Text {
                            visible: model.reply_num > 1;
                            text: qsTr("%1 more replies").arg(model.reply_num-1);
                            font {
                                pixelSize: constant.fontSizeLarge;
                            }
                            color: constant.colorLight;
                        }
                        SplitLine { width: parent.width; visible: model.reply_num > 1; }
                        Item {
                            anchors { left: parent.left; right: parent.right; }
                            height: childrenRect.height;
                            Image {
                                id: replyerAvatar
                                width: constant.graphicSizeMedium;
                                height: constant.graphicSizeMedium;
                                source: Calc.getAvatar(model.replyer.portrait);
                            }
                            Text {
                                id: replyContent;
                                anchors { left: replyerAvatar.right; leftMargin: constant.paddingSmall; right: parent.right; }
                                text: model.replyer.name_show + ":" + model.reply_content;
                                color: constant.colorMid;
                                wrapMode: Text.Wrap;
                                font.pixelSize: constant.fontSizeSmall;
                            }
                        }
                    }
                }
            }
        }
    }
}
