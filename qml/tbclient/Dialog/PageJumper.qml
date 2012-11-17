import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root

    property int currentValue: 1
    property int totalPage: 1

    signal pageJumped

    titleText: "跳转到页码：[1-%1]".arg(String(totalPage))
    buttonTexts: ["确定", "取消"]
    privateCloseIcon: true
    content: Row {
        id: row
        anchors {
            left: parent.left; right: parent.right; margins: platformStyle.paddingLarge
            verticalCenter: parent.verticalCenter
        }
        Slider {
            id: slider
            width: parent.width - textField.width
            value: root.currentValue
            maximumValue: root.totalPage
            minimumValue: 1
            stepSize: 1
            onValueChanged: root.currentValue = value
        }
        TextField {
            id: textField
            anchors.verticalCenter: parent.verticalCenter
            text: root.currentValue
            validator: IntValidator { bottom: 1; top: root.totalPage }
            onTextChanged: root.currentValue = text || 1
            inputMethodHints: Qt.ImhDigitsOnly
        }
    }
    onClickedOutside: close()
    onButtonClicked: {
        if (index == 0){
            root.pageJumped()
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
