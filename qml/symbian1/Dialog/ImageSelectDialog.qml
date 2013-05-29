import QtQuick 1.0
import com.nokia.symbian 1.0

ContextMenu {
    id: root;

    property Item caller;
    property bool __isClosing: false;

    content: MenuLayout {
        MenuItem {
            text: qsTr("From Library");
            onClicked: {
                signalCenter.imageSelected(caller.toString(), utility.selectImage());
            }
        }
        MenuItem {
            text: qsTr("From Folders");
            onClicked: {
                signalCenter.imageSelected(caller.toString(), utility.selectImage(1));
            }
        }
        MenuItem {
            text: qsTr("Take A Photo");
            onClicked: {
                signalCenter.imageSelected(caller.toString(), utility.selectImage(2));
            }
        }
        MenuItem {
            text: qsTr("Draw A Picture");
            onClicked: {
                pageStack.push(Qt.resolvedUrl("../ScribblePage.qml"), {caller: caller});
            }
        }
    }

    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
}
