import QtQuick 1.1
import com.nokia.meego 1.0

SelectionDialog {
    id: root;

    property Item caller;
    property bool __isClosing: false;

    titleText: qsTr("Select Image");
    model: [qsTr("From Library"), qsTr("Take A Photo"), qsTr("Draw A Picture")]

    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: open();
    onAccepted: {
        if (selectedIndex == 0){
            dialog.launchGallery(caller);
        } else if (selectedIndex == 2){
            dialog.scribble(caller);
        } else if (selectedIndex == 1){
            pageStack.push(Qt.resolvedUrl("../CameraPage.qml"), { caller: caller })
        }
    }
}
