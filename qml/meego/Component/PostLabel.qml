import QtQuick 1.1
import com.nokia.meego 1.0

Text {
    width: root.paddingItem.width;
    wrapMode: Text.Wrap;
    font.pixelSize: tbsettings.fontSize;
    color: constant.colorLight;
    onLinkActivated: signalCenter.linkActivated(link);
    Component.onCompleted: {
        if (modelData[2]){
            textFormat = Text.RichText;
            text = modelData[1].replace(/\n/g,"<br/>");
        } else {
            textFormat = Text.PlainText;
            text = modelData[1];
        }
    }
}
