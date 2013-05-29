import QtQuick 1.1
import com.nokia.symbian 1.1
import "../Delegate"
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitWidth: screen.width;
    implicitHeight: Math.max(authorRow.height, contentCol.height) + platformStyle.paddingLarge*2;

    Row {
        id: authorRow;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; }
        spacing: platformStyle.paddingMedium;
        Image {
            width: platformStyle.graphicSizeMedium;
            height: platformStyle.graphicSizeMedium;
            source: Calc.getAvatar(modelData.author.portrait);
        }
        ListItemText {
            anchors.verticalCenter: parent.verticalCenter;
            role: "SubTitle";
            platformInverted: root.platformInverted;
            text: modelData.author.name_show + "\n" + modelData.time_ex;
        }
    }

    Column {
        id: contentCol;
        anchors {
            left: authorRow.right; leftMargin: platformStyle.paddingMedium;
            top: root.paddingItem.top; right: root.paddingItem.right;
        }
        Repeater {
            model: modelData.contentData;
            Loader {
                sourceComponent: modelData[0] ? contentLabel : undefined;
                Component {
                    id: contentLabel;
                    Label {
                        width: contentCol.width;
                        wrapMode: Text.Wrap;
                        platformInverted: root.platformInverted;
                        font.pixelSize: tbsettings.fontSize;
                        onLinkActivated: signalCenter.linkActivated(link);
                        textFormat: modelData[2] ? Text.RichText : Text.PlainText;
                        text: modelData[2] ? modelData[1].replace(/\n/g,"<br/>") : modelData[1];
                    }
                }
            }
        }
    }
}
