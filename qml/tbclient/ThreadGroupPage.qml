import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: threadGroupPage

    property alias currentTab: threadGroup.currentTab
    property alias internal: internal
    property bool closeWhenDeactive: false

    title: currentTab ?
               currentTab.thread.title ?
                   currentTab.thread.title+"-"+currentTab.forum.name+"吧"
                 : "新标签" :"标签页"
    tools: {
        if (state == "replyOpened")
            return replyTools
        else if (state == "replyClosed")
            return viewTools
        else
            return defaultTools
    }

    onStatusChanged: {
        if(status==PageStatus.Inactive && closeWhenDeactive)
            internal.removeThreadPage(currentTab)
        if(status==PageStatus.Activating)
            closeWhenDeactive = false
        if (status==PageStatus.Active && currentTab)
            currentTab.threadView.forceActiveFocus()
    }

    Connections {
        target: signalCenter
        onSwipeRight: {
            if (status == PageStatus.Active){
                closeWhenDeactive = true
                pageStack.pop()
            }
        }
    }

    QtObject {
        id: internal
        function addThreadPage(threadId, threadName, postId, isMark, from, isLz){
            var _i = findTabIndexByThreadId(threadId)
            if (_i!=-1){
                currentTab = threadTab.layout.children[_i].tab
                return
            }
            restrictThreadNum()

            var page = Qt.createComponent("ThreadPage.qml").createObject(threadGroup)
            page.threadId = threadId; page.isLz = isLz||false;
            Script.getThreadList(page, postId, false, false, isMark, from, true)

            var button = Qt.createComponent("Component/ThreadTabButton.qml").createObject(threadTab.layout)
            button.tab = page
            if (threadName) button.text = threadName
            currentTab = page

            tabFlickable.contentX = tabFlickable.contentWidth - tabFlickable.width
        }

        function removeThreadPage(page){
            var i = findTabIndexByTab(page)
            if (i != -1){
                threadTab.layout.children[i].tab.destroy()
                threadTab.layout.children[i].destroy()
            }
            currentTab = null
        }
        function removeAllThread(){
            for (var i=threadTab.layout.children.length-1; i>=0; i--){
                threadTab.layout.children[i].tab.destroy()
                threadTab.layout.children[i].destroy()
            }
            currentTab = null
        }
        function removeOtherThread(page){
            var x = findTabIndexByTab(page)
            for (var i=threadTab.layout.children.length-1; i>=0; i--){
                if (i!=x){
                    threadTab.layout.children[i].tab.destroy()
                    threadTab.layout.children[i].destroy()
                }
            }
        }

        function findTabIndexByThreadId(threadId){
            for (var i=0, l=threadTab.layout.children.length; i<l; i++){
                if (threadTab.layout.children[i].tab.threadId == threadId)
                    return i
            }
            return -1
        }
        function findTabIndexByTab(tab){
            for (var i=0, l=threadTab.layout.children.length; i<l;i++){
                if (threadTab.layout.children[i].tab == tab)
                    return i
            }
            return -1
        }

        function restrictThreadNum(){
            if (tbsettings.maxThreadCount < 1) return
            var deleNum = threadTab.layout.children.length - tbsettings.maxThreadCount + 1
            for (var i =0; i< deleNum; i++){
                threadTab.layout.children[i].tab.destroy()
                threadTab.layout.children[i].destroy()
            }
            currentTab = null
        }
    }
    ContextMenu {
        id: removeMenu
        MenuLayout {
            MenuItem {
                text: "关闭当前标签"
                onClicked: internal.removeThreadPage(currentTab)
            }
            MenuItem {
                text: "关闭其他标签"
                onClicked: internal.removeOtherThread(currentTab)
            }
            MenuItem {
                text: "关闭全部标签"
                onClicked: internal.removeAllThread()
            }
        }
    }
    ToolBarLayout {
        id: defaultTools
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                closeWhenDeactive = false
                pageStack.pop()
            }
        }
    }
    ToolBarLayout {
        id: replyTools
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                closeWhenDeactive = false
                pageStack.pop()
            }
            onPlatformPressAndHold: {
                app.multiThread(function(){internal.removeThreadPage(currentTab)})
            }
        }
        ToolButton {
            text: "发表回复"
            enabled: currentTab!=null && !currentTab.loading
            onClicked: currentTab.postReply()
        }
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: replyMenu.open()
        }
    }
    ToolBarLayout {
        id: viewTools
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                closeWhenDeactive = false
                pageStack.pop()
            }
            onPlatformPressAndHold: {
                app.multiThread(function(){internal.removeThreadPage(currentTab)})
            }
        }
        ToolButton {
            iconSource: "toolbar-refresh"
            RotationAnimation on rotation {
                running: currentTab!=null && currentTab.loading
                loops: Animation.Infinite
                from: 360; to: 0
                duration: 500
            }
            onClicked: Script.getThreadList(currentTab, undefined, false, false, false, false, true)
        }
        ToolButton {
            iconSource: "qrc:/gfx/edit%1.svg".arg(platformInverted?"_inverted":"")
            enabled: currentTab != null && !currentTab.loading
            onClicked: currentTab.state = "replyAreaOpened"
        }
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: threadMenu.open()
        }
    }
    Menu {
        id: threadMenu
        content: MenuLayout {
            MenuItem {
                visible: currentTab != null && currentTab.thread.author != undefined
                text: visible ? (currentTab.thread.has_commented == 1 ? "已顶" : "顶")+"    "+currentTab.thread.comment_num : ""
                enabled: visible && currentTab.thread.has_commented == 0
                onClicked: currentTab.ding()
            }
            MenuItem {
                visible: currentTab != null && currentTab.thread.author != undefined && currentTab.thread.author.type != 0
                text: visible ? currentTab.isLz ? "查看全部" : "只看楼主" : ""
                onClicked: currentTab.changeLz()
            }
            MenuItem {
                visible: currentTab != null && currentTab.thread.author != undefined
                text: visible ? currentTab.isReverse ? "查看原贴" : "倒序查看" : ""
                onClicked: currentTab.reverseList()
            }
            MenuItem {
                visible: currentTab != null
                text: "用浏览器打开"
                onClicked: utility.openURLDefault("http://tieba.baidu.com/p/"+currentTab.threadId)
                ToolButton {
                    width: 0.4 * parent.width
                    anchors {
                        right: parent.right; rightMargin: platformStyle.paddingLarge; verticalCenter: parent.verticalCenter
                    }
                    text: "复制网址"
                    flat: false
                    onClicked: {
                        var o = Qt.createQmlObject('import QtQuick 1.1;TextInput{}', parent)
                        o.text = "http://tieba.baidu.com/p/"+currentTab.threadId
                        o.selectAll (); o.copy(); o.destroy()
                        app.showMessage("已复制到剪贴板")
                    }
                }
            }
        }
    }
    Menu {
        id: replyMenu
        content: MenuLayout {
            MenuItem {
                text: "关闭输入框"
                onClicked: currentTab.state = ""
            }
        }
    }

    Label {
        anchors.centerIn: parent
        text: {
            if (currentTab == null)
                return "没有打开的标签"
            else if (currentTab.threadView.count == 0 && currentTab.loading)
                return "正在加载数据..."
            else
                return ""
        }
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
    }

    Flickable {
        id: tabFlickable
        width: screen.width; height: threadTab.height
        contentHeight: threadTab.height; contentWidth: threadTab.width
        TabBar {
            id: threadTab
            platformInverted: tbsettings.whiteTheme
            visible: layout.children.length > 0
            width: Math.max(platformStyle.graphicSizeLarge*layout.children.length, threadGroupPage.width)
        }
    }
    TabGroup {
        id: threadGroup
        anchors { fill: parent; topMargin: threadTab.height }
    }
    Label {
        anchors.centerIn: parent
    }
    states: [
        State {
            name: "replyOpened"
            when: currentTab != null && currentTab.state == "replyAreaOpened"
        },
        State {
            name: "replyClosed"
            when: currentTab != null && currentTab.state == ""
        }
    ]
    transitions: [
        Transition {
            to: ""
            ScriptAction {
                script: {
                    console.log("state changed")
                    if (status == PageStatus.Active)
                        pageStack.toolBar.setTools(defaultTools)
                }
            }
        },
        Transition {
            to: "replyOpened"
            ScriptAction {
                script: {
                    console.log("state changed 2")
                    if (status == PageStatus.Active)
                        pageStack.toolBar.setTools(replyTools)
                }
            }
        },
        Transition {
            to: "replyClosed"
            ScriptAction {
                script: {
                    console.log("state changed 3")
                    if (status == PageStatus.Active)
                        pageStack.toolBar.setTools(viewTools)
                }
            }
        }
    ]
}
