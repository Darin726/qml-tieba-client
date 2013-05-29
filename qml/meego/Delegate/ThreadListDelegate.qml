import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;
    onClicked: {
        app.enterThread({threadId: model.id, title: model.title});
    }

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; right: root.paddingItem.right; top: root.paddingItem.top; }
        spacing: constant.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: thumbnail.left; }
                text: model.title;
                color: constant.colorLight;
                font { pixelSize: tbsettings.fontSize; bold: true; }
                wrapMode: Text.Wrap;
                textFormat: Text.PlainText;
            }
            Loader {
                id: thumbnail;
                anchors.right: parent.right;
                sourceComponent: tbsettings.showAbstract && tbsettings.showImage && model.media ? thumbnailComp : undefined;
                Component {
                    id: thumbnailComp;
                    Image {
                        width: 75; height: 75;
                        fillMode: Image.PreserveAspectFit;
                        source: model.media;
                    }
                }
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            opacity: tbsettings.showAbstract && text != "" ? 1 : 0;
            text: model.abstract;
            font {
                pixelSize: constant.fontSizeMedium;
                weight: Font.Light;
            }
            color: constant.colorMid;
            elide: Text.ElideRight;
            textFormat: Text.PlainText;
        }
        Row {
            Loader {
                sourceComponent: model.is_top == 1 ? topInfo : undefined;
                Component {
                    id: topInfo;
                    Image { source: "../gfx/frs_post_top.png"; }
                }
            }
            Loader {
                sourceComponent: model.is_good == 1 ? goodInfo : undefined;
                Component {
                    id: goodInfo;
                    Image { source: "../gfx/frs_post_good.png"; }
                }
            }
            Text {
                text: model.reply_num+"/"+model.view_num+"  "+model.author;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
    }
    Text {
        anchors { right: root.paddingItem.right; bottom: root.paddingItem.bottom; }
        text: model.last_time;
        font {
            pixelSize: constant.fontSizeSmall;
            weight: Font.Light;
        }
        color: constant.colorMid;
    }
}
