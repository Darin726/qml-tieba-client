import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + symbianStyle.doublePaddingLarge;
    onClicked: {
        app.enterThread({threadId: model.id, title: model.title});
    }

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; right: root.paddingItem.right; top: root.paddingItem.top; }
        spacing: platformStyle.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
                elide: Text.ElideRight;
                text: model.author;
            }
            Row {
                anchors.right: parent.right;
                Image { source: opacity ? "../gfx/frs_post_top.png" : ""; opacity: model.is_top; asynchronous: true; }
                Image { source: opacity ? "../gfx/frs_post_good.png" : ""; opacity: model.is_good; asynchronous: true; }
            }
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: thumbnail.left; }
                text: model.title;
                color: symbianStyle.colorLight;
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: tbsettings.fontSize;
                }
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
                        smooth: false;
                        fillMode: Image.PreserveAspectFit;
                        source: model.media;
                    }
                }
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            opacity: tbsettings.showAbstract && text ? 1 : 0;
            text: model.abstract;
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeMedium;
                weight: Font.Light;
            }
            color: symbianStyle.colorMid;
            elide: Text.ElideRight;
        }
        Text {
            text: model.reply_num+"/"+model.view_num+"  "+model.last_replyer;
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeSmall;
                weight: Font.Light;
            }
            color: symbianStyle.colorMid;
        }
    }
    Text {
        anchors { right: root.paddingItem.right; bottom: root.paddingItem.bottom; }
        text: model.last_time;
        font {
            family: platformStyle.fontFamilyRegular;
            pixelSize: platformStyle.fontSizeSmall;
            weight: Font.Light;
        }
        color: symbianStyle.colorMid;
    }
}
