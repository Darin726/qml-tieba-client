import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/main.js" as Script

MyPage {
    id: friendSelector

    title: "选择好友"

    property bool loading: false
    property Item caller

    Component.onCompleted: getlist()

    function getlist(){
        Script.getFriendList(friendSelector.toString(), "follow", "list", undefined, friendModel, true)
    }

    tools: ToolBarLayout {
        ToolButton { iconSource: "toolbar-back"; onClicked: pageStack.pop() }
    }
    Connections {
        target: signalCenter
        onGetFriendListStarted: {
            if (caller == friendSelector.toString())
                loading = true
        }
        onGetFriendListFailed: {
            if (caller == friendSelector.toString())
                app.showMessage(errorString)
        }
        onGetFriendListSuccessed: {
            if (caller == friendSelector.toString())
                loading = false
        }
    }

    ViewHeader {
        id: viewHeader
        implicitHeight: privateStyle.tabBarHeightPortrait
        SearchInput {
            id: searchInput
            width: parent.paddingItem.width
            anchors.centerIn: parent
            placeholderText: "搜索好友"
            onTypeStopped: {
                if (text == ""){
                    filterModel.clear()
                } else {
                    Script.getFollowSuggest(friendSelector.toString(), text, friendModel, filterModel)
                }
            }
            onCleared: friendSelector.focus = true
            platformInverted: tbsettings.whiteTheme
        }
    }
    Label {
        anchors.centerIn: parent
        text: loading ? "正在加载..." : "未找到结果"
        visible: friendView.model.count == 0
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
    }

    ListModel { id: friendModel }
    ListModel { id: filterModel }

    ListView {
        id: friendView
        anchors {
            fill: parent; topMargin: viewHeader.height
        }
        clip: true
        model: searchInput.text == "" ?  friendModel : filterModel
        delegate: friendComp
        header: searchInput.text == "" ? header : null
        Component {
            id: header
            PullToActivate {
                myView: friendView
                onRefresh: getlist()
            }
        }
        Component {
            id: friendComp
            ListItem {
                id: listItem
                platformInverted: tbsettings.whiteTheme
                onClicked: {
                    signalCenter.friendSelected(caller.toString(), "@"+name+" ")
                    pageStack.pop()
                }
                Row {
                    anchors {
                        left: parent.paddingItem.left
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: platformStyle.paddingLarge
                    Image {
                        height: listItem.paddingItem.height
                        width: height
                        fillMode: Image.PreserveAspectFit
                        source: "http://tb.himg.baidu.com/sys/portraitn/item/"+portrait
                    }
                    ListItemText {
                        platformInverted: listItem.platformInverted
                        text: name_show
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
