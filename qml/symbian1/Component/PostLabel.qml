import QtQuick 1.0
import com.nokia.symbian 1.0

Text {
    width: root.paddingItem.width;
    wrapMode: Text.Wrap;
    font {
        family: platformStyle.fontFamilyRegular;
        pixelSize: tbsettings.fontSize;
    }
    color: symbianStyle.colorLight;
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
