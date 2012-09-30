import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root

    property alias picurl: vcodePic.source
    property string vcodeMd5
    property bool opened
    property string caller

    titleText: "请输入验证码"
    buttonTexts: ["确定", "取消"]
    width: platformContentMaximumWidth;
    height: platformContentMaximumHeight;

    content: Column {
        anchors.centerIn: parent
        spacing: platformStyle.paddingLarge
        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "请输入下图中的字符"
        }
        Image {
            id: vcodePic
            cache: false
            anchors.horizontalCenter: parent.horizontalCenter
            BusyIndicator {
                anchors.centerIn: parent
                running: visible
                visible: vcodePic.status == Image.Loading
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var t = vcodePic.source
                    vcodePic.source ="";
                    vcodePic.source = t
                }
            }
        }
        TextField {
            id: vcodeInput
            width: 150
            anchors.horizontalCenter: parent.horizontalCenter
            placeholderText: "输入验证码"
        }
    }
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
    onButtonClicked: if (index == 0) accept()
    onAccepted: signalCenter.vcodeSent(caller, vcodeInput.text, root.vcodeMd5)
}
