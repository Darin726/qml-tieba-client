import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/storage.js" as Database

MyPage {
    id: bookMarkPage
    title: "我的书签"

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
        ToolButton {
            text: "清空"
            onClicked: diag.open()
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active)
            Database.getBookMark(bookmarkModel)
    }

    Label {
        anchors.centerIn: parent
        text: "没有保存的书签"
        visible: view.count == 0
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
    }

    QueryDialog {
        id: diag
        titleText: "清空书签"
        height: platformStyle.graphicSizeMedium
        message: "确定要删除所有保存的书签吗？"
        acceptButtonText: "确定"
        rejectButtonText: "取消"
        onAccepted: {
            Database.deleteBookMark()
            bookmarkModel.clear()
        }
    }

    ViewHeader {
        id: viewHeader
        headerText: "我的书签"
    }
    ListView {
        id: view
        anchors {
            fill: parent; topMargin: viewHeader.height
        }
        clip: true
        model: ListModel { id: bookmarkModel }
        delegate: ListItem {
            id: root
            platformInverted: tbsettings.whiteTheme
            implicitHeight: contentCol.height + platformStyle.paddingLarge*2
            onClicked: app.enterThread(threadId, title, postId, 1, isLz)
            Column {
                id: contentCol
                anchors {
                    top: parent.paddingItem.top; left: parent.paddingItem.left; right: btn.left
                }
                Label {
                    width: parent.width
                    text: model.title
                    wrapMode: Text.Wrap
                    platformInverted: root.platformInverted
                }
                ListItemText {
                    platformInverted: root.platformInverted
                    width: parent.width
                    text: model.author
                    role: "SubTitle"
                }
            }
            Button {
                id: btn
                platformInverted: root.platformInverted
                anchors {
                    right: parent.paddingItem.right; verticalCenter: parent.verticalCenter
                }
                iconSource: privateStyle.toolBarIconPath("toolbar-delete", platformInverted)
                onClicked:  {
                    Database.deleteBookMark(model.threadId)
                    bookmarkModel.remove(index)
                }
            }
        }
    }
}

