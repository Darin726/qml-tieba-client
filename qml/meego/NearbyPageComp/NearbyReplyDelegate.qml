import QtQuick 1.1
import com.nokia.meego 1.0
import "../Delegate"
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitWidth: screen.rotation === 0 || screen.rotation === 180 ? screen.displayWidth : screen.displayHeight
    implicitHeight: Math.max(authorRow.height, contentCol.height) + constant.paddingLarge*2;

    Row {
        id: authorRow;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; }
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

    Column {
        id: contentCol;
        anchors {
            left: authorRow.right; leftMargin: constant.paddingMedium;
            top: root.paddingItem.top; right: root.paddingItem.right;
        }
        Repeater {
            model: modelData.contentData;
            Loader {
                sourceComponent: modelData[0] ? contentLabel : undefined;
                Component {
                    id: contentLabel;
                    Text {
                        width: contentCol.width;
                        wrapMode: Text.Wrap;
                        font.pixelSize: tbsettings.fontSize;
                        onLinkActivated: signalCenter.linkActivated(link);
                        textFormat: modelData[2] ? Text.RichText : Text.PlainText;
                        text: modelData[2] ? modelData[1].replace(/\n/g,"<br/>") : modelData[1];
                        color: constant.colorLight;
                    }
                }
            }
        }
    }
}
