import QtQuick 1.0
import com.nokia.symbian 1.0
import "../Delegate"
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;
    onClicked: {
        var p = pageStack.push(Qt.resolvedUrl("NearbyContentPage.qml"),
                               { threadId: model.tid });
        p.getlist();
    }

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: platformStyle.paddingMedium;
        Repeater {
            model: content.list;
            Loader {
                source: modelData[0] ? "../Component/PostLabel.qml" : "../Component/PostImage.qml";
            }
        }
        Row {
            spacing: platformStyle.paddingMedium;
            Image {
                width: platformStyle.graphicSizeMedium;
                height: platformStyle.graphicSizeMedium;
                source: Calc.getAvatar(model.author.portrait)
            }
            ListItemText {
                anchors.verticalCenter: parent.verticalCenter;
                text: model.author.name_show + "\n" + model.time;
                role: "SubTitle";
            }
        }
        Loader {
            anchors { left: parent.left; leftMargin: platformStyle.paddingMedium; right: parent.right; }
            visible: model.reply_num > 0;
            sourceComponent: model.reply_num > 0 ? replyComp : undefined;
            Component {
                id: replyComp;
                Item {
                    width: parent.width;
                    height: replyCol.height + platformStyle.paddingMedium*2+5;
                    BorderImage {
                        anchors.fill: parent;
                        source: "../gfx/nearby_reply_bg_1.9.png";
                        border { left: 32; right: 10; top: 15; bottom: 10; }
                    }
                    Column {
                        id: replyCol;
                        anchors {
                            left: parent.left; leftMargin: platformStyle.paddingMedium;
                            top: parent.top; topMargin: platformStyle.paddingMedium+5;
                            right: parent.right; rightMargin: platformStyle.paddingMedium;
                        }
                        spacing: platformStyle.paddingSmall;
                        ListItemText {
                            visible: model.reply_num > 1;
                            text: qsTr("%1 more replies").arg(model.reply_num-1);
                        }
                        Rectangle {
                            anchors { left: parent.left; right: parent.right; }
                            height: 1;
                            color: platformStyle.colorDisabledMid
                            visible: model.reply_num > 1;
                        }
                        Item {
                            anchors { left: parent.left; right: parent.right; }
                            height: childrenRect.height;
                            Image {
                                id: replyerAvatar
                                width: platformStyle.graphicSizeMedium;
                                height: platformStyle.graphicSizeMedium;
                                source: Calc.getAvatar(model.replyer.portrait);
                            }
                            Text {
                                id: replyContent;
                                anchors { left: replyerAvatar.right; leftMargin: platformStyle.paddingSmall; right: parent.right; }
                                text: model.replyer.name_show + ":" + model.reply_content;
                                color: platformStyle.colorNormalMid;
                                wrapMode: Text.Wrap;
                                font {
                                    pixelSize: platformStyle.fontSizeSmall;
                                    family: platformStyle.fontFamilyRegular;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
