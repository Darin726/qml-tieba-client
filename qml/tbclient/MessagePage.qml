import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: messagePage
    title: "消息提醒"
    tools: homeTools

    property alias currentTab: messageGroup.currentTab
    property alias replyToMePage: replyToMePage
    property alias atMePage: atMePage

    Keys.onPressed: {
        switch(event.key){
        case Qt.Key_Left: {
            if(currentTab == replyToMePage)
                pageStack.pop(myBarPage)
            else
                currentTab = replyToMePage
            event.accepted = true;
            break;
        }
        case Qt.Key_Right: {
            if (currentTab == replyToMePage)
                currentTab = atMePage
            else
                app.enterProfilePage(Script.userId)
            event.accepted = true;
            break;
        }
        }
    }

    Connections {
        target: signalCenter
        onSwipeLeft: {
            if (status == PageStatus.Active){
                if (currentTab == replyToMePage)
                    currentTab = atMePage
                else
                    app.enterProfilePage(Script.userId)
            }
        }
        onSwipeRight: {
            if (status == PageStatus.Active){
                if(currentTab == replyToMePage)
                    pageStack.pop(myBarPage)
                else
                    currentTab = replyToMePage
            }
        }
    }

    TabBar {
        id: tabBar
        platformInverted: tbsettings.whiteTheme
        TabButton { text: "回复我的"; tab: replyToMePage; platformInverted: tbsettings.whiteTheme }
        TabButton { text: "@我的"; tab: atMePage; platformInverted: tbsettings.whiteTheme }
    }
    TabGroup {
        id: messageGroup
        anchors { fill: parent; topMargin: tabBar.height }
        currentTab: replyToMePage
        ReplyToMePage { id: replyToMePage }
        AtMePage { id: atMePage }
    }
}
