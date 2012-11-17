import QtQuick 1.1
import com.nokia.symbian 1.1

ContextMenu {
    id: root

    property string threadId
    property string postId
    property bool isFloor

    content: MenuLayout {
        MenuItem {
            text: "查看该回复"
            onClicked: {
                if (isFloor){
                    app.enterSubfloor(threadId, null, postId)
                } else {
                    app.enterSubfloor(threadId, postId)
                }
            }
        }
        MenuItem {
            text: "查看该主题"
            onClicked: app.enterThread(threadId)
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

