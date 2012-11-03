import QtQuick 1.1
import com.nokia.symbian 1.1

ContextMenu {
    id: root

    property Item caller

    MenuLayout {
        MenuItem {
            text: "拍摄"
            visible: false
            onClicked: app.pageStack.push(Qt.resolvedUrl("../Component/CameraPage.qml"),
                                          { caller: root.caller })
        }
        MenuItem {
            text: "从照片库"
            onClicked: signalCenter.imageSelected(caller.toString(), utility.choosePhoto())
        }
        MenuItem {
            text: "涂鸦"
            onClicked: app.pageStack.push(Qt.resolvedUrl("../Component/ScribblePage.qml"),
                                          { caller: root.caller })
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
