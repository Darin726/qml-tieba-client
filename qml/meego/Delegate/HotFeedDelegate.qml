import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;

    onClicked: {
        app.enterThread({threadId: modelData.tid, title: modelData.title});
    }

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: constant.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: thumbnail.left; }
                text: modelData.title;
                color: constant.colorLight;
                font { pixelSize: tbsettings.fontSize; bold: true; }
                wrapMode: Text.Wrap;
                textFormat: Text.PlainText;
            }
            Loader {
                id: thumbnail;
                anchors.right: parent.right;
                sourceComponent: tbsettings.showImage && modelData.media.length > 0 ? thumbnailComp: undefined;
                Component {
                    id: thumbnailComp;
                    Image {
                        width: 75; height: 75;
                        fillMode: Image.PreserveAspectFit;
                        source: modelData.media[0];
                    }
                }
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            opacity: text ? 1 : 0;
            text: modelData.abstract;
            font {
                pixelSize: constant.fontSizeMedium;
                weight: Font.Light;
            }
            color: constant.colorMid;
            elide: Text.ElideRight;
            textFormat: Text.PlainText;
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                text: modelData.fname+qsTr("Bar");
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
            Text {
                id: timeShow;
                anchors.right: parent.right;
                text: Calc.formatDateTime(modelData.last_time_int*1000);
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
            Text {
                anchors { right: timeShow.left; rightMargin: constant.paddingMedium; }
                text: qsTr("Reply:")+modelData.reply_num;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
    }
}
