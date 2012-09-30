import QtQuick 1.1
import com.nokia.symbian 1.1

ContextMenu {
    id: root

    MenuLayout {
        MenuItem {
            text: "从照片库"
            onClicked: signalCenter.imageSelected(root.parent.toString(), utility.choosePhoto())
        }
        MenuItem {
            text: "涂鸦"
            onClicked: app.pageStack.push(Qt.resolvedUrl("../Component/ScribblePage.qml"),
                                          { caller: root.parent })
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
