import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/Calculate.js" as Calc;

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;
    onClicked: {
        app.enterFloor({threadId: model.tid, postId: model.pid});
    }

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left;
            top: root.paddingItem.top;
            right: root.paddingItem.right;
        }
        spacing: constant.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: titleLabel.paintedHeight + constant.paddingLarge*3;
            visible: model.content != "";
            BorderImage {
                anchors.fill: parent;
                border { left: 30; top: 10; right: 10; bottom: 20; }
                source: theme.inverted ? "../gfx/search_replay_back_1.9.png"
                                       : "../gfx/search_replay_back.9.png";
            }
            Text {
                id: titleLabel;
                anchors {
                    left: parent.left; top: parent.top; right: parent.right;
                    margins: constant.paddingLarge;
                }
                text: model.content;
                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeLarge;
                color: constant.colorLight;
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            text: model.title;
            font {
                pixelSize: constant.fontSizeMedium;
                weight: Font.Light;
            }
            color: constant.colorMid;
            textFormat: Text.StyledText;
            maximumLineCount: 2;
            wrapMode: Text.Wrap;
            elide: Text.ElideRight;
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                text: model.name;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
            Text {
                text: model.fname + qsTr("Bar");
                anchors { right: timeShow.left; rightMargin: constant.paddingMedium; }
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
            Text {
                id: timeShow;
                anchors.right: parent.right;
                text: Calc.formatDateTime(model.time*1000);
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
    }
}
