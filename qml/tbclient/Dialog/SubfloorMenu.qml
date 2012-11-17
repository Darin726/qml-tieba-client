import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/main.js" as Script

ContextMenu {
    id: root

    property variant modelData: ({})

    MenuLayout {
        MenuItem {
            text: "复制内容"
            onClicked: {
                pageStack.push(Qt.resolvedUrl("../Component/CopyPage.qml"),
                               { "sourceObject": modelData.content })
            }
        }
        MenuItem {
            text: "删除此贴"
            visible: manageGroup != 0
            onClicked: {
                Script.threadManage(subFloorPage, "delpost", modelData.id, manageGroup == 3, true, 3)
            }
        }
        MenuItem {
            text: "封禁用户"
            visible: manageGroup == 1 || manageGroup == 2 && (modelData.author?modelData.author.type!=0:false)
            onClicked: commitprison(modelData.author.name)
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
