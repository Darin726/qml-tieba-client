import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root

    titleText: "设定签名"
    buttonTexts: ["确定","清空","取消"]

    height: 300

    content: TextArea {
        id: textArea
        anchors {
            fill: parent; margins: platformStyle.paddingMedium
        }
        text: tbsettings.signText
    }
    onButtonClicked: {
        switch (index){
        case 0: tbsettings.signText = textArea.text; break;
        case 1: tbsettings.signText = ""; break;
        }
    }

    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
