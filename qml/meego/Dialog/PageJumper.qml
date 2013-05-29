import QtQuick 1.1
import com.nokia.meego 1.0

QueryDialog {
    id: root

    property int currentValue: 1
    property int totalPage: 1

    titleText: qsTr("Jump To Page: [1-%1]").arg(String(totalPage));
    acceptButtonText: qsTr("OK");
    rejectButtonText: qsTr("Cancel");

    content: Row {
        id: row
        anchors {
            left: parent.left; right: parent.right; margins: constant.paddingLarge
        }
        Slider {
            id: slider
            width: parent.width - textField.width
            value: root.currentValue
            maximumValue: root.totalPage
            minimumValue: 1
            stepSize: 1
            onValueChanged: root.currentValue = value;
            platformStyle: SliderStyle { inverted: true; }
        }
        TextField {
            id: textField;
            width: 100;
            anchors.verticalCenter: parent.verticalCenter
            text: root.currentValue
            validator: IntValidator { bottom: 1; top: root.totalPage }
            onTextChanged: root.currentValue = text || 1
            inputMethodHints: Qt.ImhDigitsOnly;
            Keys.onReturnPressed: accept();
        }
    }
}
