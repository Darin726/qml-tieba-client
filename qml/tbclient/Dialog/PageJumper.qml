import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root

    titleText: "跳转到页码：[1-%1]".arg(String(page.total_page))
    buttonTexts: ["确定", "取消"]
    privateCloseIcon: true
    content: Row {
        id: row
        property int currentValue: pageNumber
        onCurrentValueChanged: {
            slider.value = currentValue
            textField.text = currentValue
        }
        anchors {
            left: parent.left; right: parent.right; margins: platformStyle.paddingLarge
            verticalCenter: parent.verticalCenter
        }
        Slider {
            id: slider
            width: parent.width - textField.width
            value: pageNumber
            maximumValue: page.total_page
            minimumValue: 1
            stepSize: 1
            onValueChanged: row.currentValue = value
        }
        TextField {
            id: textField
            anchors.verticalCenter: parent.verticalCenter
            text: pageNumber
            validator: IntValidator { bottom: 1; top: page.total_page }
            onTextChanged: row.currentValue = text || 1
            inputMethodHints: Qt.ImhDigitsOnly
        }
    }
    onClickedOutside: close()
    onButtonClicked: {
        if (index == 0){
            pageNumber = row.currentValue
            internal.getList()
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
