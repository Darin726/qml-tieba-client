import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: friendListPage

    property bool loading: false

    property string type
    property int pageNumber: 1
    property variant page: ({})
    property string userId

    function getlist(isRenew){
        if (isRenew) pageNumber = 1
        else pageNumber ++
        Script.getFriendList(friendListPage.toString(), type, "page", userId, listModel, isRenew, pageNumber)
    }

    title: (type=="follow"?"关注":"粉丝")+"(%1)".arg(page.total_count||0)

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
    }

    Connections {
        target: signalCenter
        onGetFriendListStarted: {
            if (caller == friendListPage.toString())
                loading = true
        }
        onGetFriendListFailed: {
            if (caller == friendListPage.toString()){
                loading = false
                app.showMessage(errorString)
            }
        }
        onGetFriendListSuccessed: {
            if (caller == friendListPage.toString()){
                loading = false
                friendListPage.page = page
                pageNumber = page.current_page
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        model: ListModel { id: listModel }
        delegate: ListItem {
            id: root
            onClicked: app.enterProfilePage(model.id)
            platformInverted: tbsettings.whiteTheme
            Row {
                anchors {
                    left: parent.paddingItem.left
                    verticalCenter: parent.verticalCenter
                }
                spacing: platformStyle.paddingLarge
                Image {
                    width: root.paddingItem.height
                    height: width
                    fillMode: Image.PreserveAspectFit
                    source: "http://tb.himg.baidu.com/sys/portraitn/item/"+model.portrait
                }
                ListItemText {
                    platformInverted: root.platformInverted
                    text: model.name_show
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        footer: Item {
            width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0
            visible: page.has_more == 1
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !loading
                text: loading ? "正在加载..." : "点击加载更多"
                onClicked: getlist()
            }
        }
    }
    Label {
        anchors.centerIn: parent
        text: "正在加载数据..."
        visible: view.count == 0 && loading
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
    }

    ScrollDecorator {
        flickableItem: view
        platformInverted: tbsettings.whiteTheme
    }
}
