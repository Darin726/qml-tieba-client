import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/main.js" as Script

ContextMenu {
    id: root

    property int currentIndex
    property variant modelData: ({})

    MenuLayout {
        MenuItem {
            text: "添加到书签"
            onClicked: {
                app.addBookmark(threadId, modelData.id, thread.author.name_show, thread.title, isLz)
            }
        }
        MenuItem {
            text: "回复"
            onClicked: {
                threadPage.state = "replyAreaOpened"
                replyLoader.item.floorNum = modelData.floor
                replyLoader.item.quoteId = modelData.id
            }
        }
        MenuItem {
            text: "阅读模式"
            onClicked: app.pageStack.push(Qt.resolvedUrl("../Reader.qml")
                                          ,{ currentIndex: root.currentIndex, myView: threadView})
        }
        MenuItem {
            text: "复制内容"
            onClicked: app.pageStack.push(Qt.resolvedUrl("../Component/CopyPage.qml"),
                                          { sourceObject: modelData.content })
        }
        MenuItem {
            text: "删除" + (modelData.floor == 1 ? "主题" : "此贴")
            visible: {
                switch (manageGroup){
                case 0: return false;
                case 1: return true;
                case 2: return true;
                default: return modelData.floor != 1
                }
            }
            onClicked: {
                Script.threadManage(threadPage,
                                    modelData.floor==1?"delthread":"delpost",
                                    modelData.id,
                                    manageGroup==3,
                                    false,
                                    1)
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
