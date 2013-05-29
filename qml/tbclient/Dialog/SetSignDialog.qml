import QtQuick 1.1
import com.nokia.symbian 1.1


CommonDialog {
    id: root;

    titleText: qsTr("Set Sign");
    buttonTexts: [qsTr("Save"), qsTr("Clear"), qsTr("Cancel")];

    content: Item {
        width: platformContentMaximumWidth;
        height: Math.min(platformContentMaximumHeight, 180);
        TextArea {
            id: textArea;
            anchors { fill: parent; margins: platformStyle.paddingMedium; }
            text: tbsettings.signText;
        }
    }

    onButtonClicked: {
        if (index == 0){
            tbsettings.signText = textArea.text;
            root.accept();
        } else if (index == 1){
            tbsettings.signText = "";
            root.accept();
        } else {
            root.reject();
        }
    }

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
    Component.onCompleted: open();
}
