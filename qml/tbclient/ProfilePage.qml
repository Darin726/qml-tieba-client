import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: profilePage

    title: "用户资料"

    property string userId
    property variant user: ({})

    property bool hasConcerned: user.has_concerned == 1
    property bool loading

    tools: ToolBarLayout {
        ToolButton { iconSource: "toolbar-back"; onClicked: pageStack.pop() }
        ToolButton {
            enabled: !loading
            text: loading ? "正在加载" : hasConcerned ? "取消关注" : "关注"
            onClicked: Script.concern(profilePage, !hasConcerned)
        }
    }

    Label {
        anchors.centerIn: parent
        visible: loading && !user.name_show
        text: "正在加载数据..."
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMid
                                     : platformStyle.colorDisabledMidInverted
    }

    Connections {
        target: signalCenter
        onGetProfileStarted: {
            if (caller == profilePage.toString()) loading = true
        }
        onGetProfileFailed: {
            if (caller == profilePage.toString()){
                loading = false
                app.showMessage(errorString)
            }
        }
        onGetProfileSuccessed: {
            if (caller == profilePage.toString()){
                loading = false
            }
        }
        onConcernFailed: {
            if (caller == profilePage.toString()){
                app.showMessage(errorString)
            }
        }
        onConcernSuccessed: {
            if (caller == profilePage.toString()){
                app.showMessage("成功")
            }
        }
    }

    Flickable {
        id: contFlicky
        visible: !loading
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentCol.height

        Column {
            id: contentCol
            width: parent.width
            PullToActivate {
                id: pullHeader
                myView: contFlicky
                onRefresh: Script.getProfile(profilePage)
            }
            ViewHeader {
                headerText: user.name_show || ""
            }
            Item { width: 1; height: platformStyle.paddingLarge }
            Row {
                spacing: platformStyle.paddingLarge
                Image {
                    width: platformStyle.graphicSizeLarge
                    height: platformStyle.graphicSizeLarge
                    source: user.portrait ? "http://tb.himg.baidu.com/sys/portraitn/item/"+user.portrait : ""
                    fillMode: Image.PreserveAspectFit
                }
                Label {
                    id: userName
                    anchors.verticalCenter: parent.verticalCenter
                    text: user.name_show || ""
                    font.pixelSize: platformStyle.fontSizeLarge
                    platformInverted: tbsettings.whiteTheme
                }
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: user.sex == 1 ? "qrc:/gfx/male.png" : "qrc:/gfx/female.png"
                }
            }
            Item {
                x: platformStyle.paddingLarge
                width: parent.width - platformStyle.paddingLarge*2
                height: intro.height + platformStyle.paddingLarge
                Label {
                    id: intro
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    wrapMode: Text.Wrap
                    platformInverted: app.platformInverted
                    text: user.intro || ""
                }
            }
            Rectangle {
                width: screen.width; height: 1
                color: tbsettings.whiteTheme ? platformStyle.colorDisabledLightInverted
                                             : platformStyle.colorDisabledMid
            }
            ListItem {
                platformInverted: tbsettings.whiteTheme
                ListItemText {
                    platformInverted: parent.platformInverted
                    anchors { left: parent.paddingItem.left; verticalCenter: parent.verticalCenter }
                    text: "喜欢的贴吧  "+user.like_forum_num
                }
                onClicked: {
                    if (userId == Script.userId){
                        pageStack.pop(myBarPage)
                    }
                }
            }
            ListItem {
                platformInverted: tbsettings.whiteTheme
                ListItemText {
                    platformInverted: parent.platformInverted
                    anchors { left: parent.paddingItem.left
                        verticalCenter: parent.verticalCenter }
                    text: "关注  "+user.concern_num
                }
                onClicked: {
                    if (userId==Script.userId)
                        pageStack.push(Qt.resolvedUrl("FriendListPage.qml"),
                                       { userId: userId, type: "follow" }).getlist(true)
                }
            }
            ListItem {
                platformInverted: tbsettings.whiteTheme
                ListItemText {
                    platformInverted: parent.platformInverted
                    anchors { left: parent.paddingItem.left
                        verticalCenter: parent.verticalCenter }
                    text: "粉丝  "+user.fans_num
                }
                onClicked: {
                    if (userId==Script.userId)
                        pageStack.push(Qt.resolvedUrl("FriendListPage.qml"),
                                       { userId: userId, type: "fans" }).getlist(true)
                }
            }
        }
    }
}
