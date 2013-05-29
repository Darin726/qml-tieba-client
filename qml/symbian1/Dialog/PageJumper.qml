import QtQuick 1.0
import com.nokia.symbian 1.0
import "../Component"

CustomDialog {
    id: root

    property int currentValue: 1
    property int totalPage: 1

    titleText: qsTr("Jump To Page: [1-%1]").arg(String(totalPage));
    buttonTexts: [qsTr("OK"), qsTr("Cancel")];
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
            inputMethodHints: Qt.ImhDigitsOnly;
        }
    }
    onClickedOutside: close()
    onButtonClicked: {
        if (index == 0){
            root.accept();
        } else {
            root.reject();
        }
    }
}
