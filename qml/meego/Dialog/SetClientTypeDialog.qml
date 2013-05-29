import QtQuick 1.1
import com.nokia.meego 1.0

SelectionDialog {
    id: root;
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    titleText: qsTr("Select Client Type");
    model: ["iPhone", "Android", "WindowsPhone"];
    selectedIndex: tbsettings.clientType - 1;
    onAccepted: {
        if (selectedIndex != -1){
            tbsettings.clientType = selectedIndex+1;
        }
    }
    Component.onCompleted: open();
}
