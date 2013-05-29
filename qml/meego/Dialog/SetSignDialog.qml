import QtQuick 1.1
import com.nokia.meego 1.0

Sheet {
    id: root;

    acceptButtonText: qsTr("Save");
    rejectButtonText: qsTr("Cancel");

    title: SheetButton {
        anchors.centerIn: parent;
        text: qsTr("Clear");
        onClicked: {
            textArea.text = "";
            root.accept();
        }
    }

    onAccepted: tbsettings.signText = textArea.text;

    content: Flickable {
        id: flickable;
        anchors { fill: parent; margins: constant.paddingLarge; }
        contentWidth: width;
        contentHeight: textArea.height;
        onHeightChanged: textArea.setHeight();

        TextArea {
            id: textArea;
            width: parent.width;
            text: tbsettings.signText;

            function setHeight() { height = Math.max(implicitHeight, flickable.height) }
            onImplicitHeightChanged: setHeight();
        }
    }

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: open();
}
