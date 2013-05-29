import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

MyPage {
    id: page;

    property QtObject pageJumper: null;
    property QtObject threadMenu: null;
    property QtObject tabMenu: null;

    title: internal.getTitle();

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
            onPlatformPressAndHold: internal.removeThreadPage(tabGroup.currentTab);
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Refresh");
            iconSource: "toolbar-refresh";
            visible: tabGroup.currentTab != null;
            onClicked: {
                tabGroup.currentTab.getlist();
            }
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Reply");
            iconSource: platformInverted ? "gfx/edit_inverted.svg" : "gfx/edit.svg";
            visible: tabGroup.currentTab != null;
            enabled: tabGroup.currentTab != null && tabGroup.currentTab.thread != null;
            onClicked: {
                var view = tabGroup.currentTab;
                var param = { caller: view, fid: view.forum.id, kw: view.forum.name, tid: view.thread.id };
                pageStack.push(Qt.resolvedUrl("PostPage.qml"), { param: param, state: "post" });
            }
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Menu");
            iconSource: "toolbar-menu";
            visible: tabGroup.currentTab != null;
            onClicked: {
                if (!threadMenu){
                    threadMenu = menuComp.createObject(page);
                }
                threadMenu.open();
            }
        }
    }

    function addThreadView(opt){
        internal.addThreadPage(opt);
    }

    QtObject {
        id: internal;

        property variant viewComp: null;
        property variant tabComp: null;

        function addThreadPage(option){
            var exist = findTabButtonByThreadId(option.threadId);
            if (exist){
                tabGroup.currentTab = exist.tab;
                return;
            }
            restrictTabCount();

            var prop = { threadId: option.threadId, pageStack: page.pageStack };
            if (!viewComp) viewComp = Qt.createComponent("ThreadView.qml");
            var view = viewComp.createObject(tabGroup, prop);
            if (option.title){ view.title = option.title; }
            if (option.isLz) { view.isLz = option.isLz; }
            if (option.pid){
                view.getlist(option.pid);
            } else {
                view.getlist();
            }

            if (!tabComp) tabComp = Qt.createComponent("Component/ThreadButton.qml");
            tabComp.createObject(viewHeader.layout, { tab: view });
        }

        function removeThreadPage(page){
            var button = findTabButtonByTab(page);
            if (button){
                button.destroy();
                page.destroy();
            }
            tabGroup.currentTab = null;
        }

        function removeAllThread(){
            for (var i=viewHeader.layout.children.length-1; i>=0; i--){
                var button = viewHeader.layout.children[i];
                button.tab.destroy();
                button.destroy();
            }
            tabGroup.currentTab = null;
        }

        function removeOtherThread(page){
            for (var i=viewHeader.layout.children.length-1; i>=0; i--){
                var button = viewHeader.layout.children[i];
                if (button.tab != page){
                    button.tab.destroy();
                    button.destroy();
                }
            }
        }

        function findTabButtonByThreadId(threadId){
            for (var i=0, l=viewHeader.layout.children.length; i<l; i++){
                var btn = viewHeader.layout.children[i];
                if (btn.tab.threadId == threadId){
                    return btn;
                }
            }
            return null;
        }
        function findTabButtonByTab(tab){
            for (var i=0, l=viewHeader.layout.children.length; i<l; i++){
                var btn = viewHeader.layout.children[i];
                if (btn.tab == tab){
                    return btn;
                }
            }
            return null;
        }

        function restrictTabCount(){
            var deleteCount = viewHeader.layout.children.length - tbsettings.maxThreadCount + 1;
            for (var i=0; i<deleteCount; i++){
                viewHeader.layout.children[i].tab.destroy();
                viewHeader.layout.children[i].destroy();
            }
            tabGroup.currentTab = null;
        }

        function jumpToPage(){
            if (!pageJumper || !tabGroup.currentTab) return;
            tabGroup.currentTab.currentPage = pageJumper.currentValue;
            tabGroup.currentTab.getlist("jump");
        }

        function getTitle(){
            var page = tabGroup.currentTab;
            if (page == null){
                return qsTr("Tab Page");
            } else if (page.thread == null){
                return page.title;
            } else {
                return page.thread.title + "-" + page.forum.name + qsTr("Bar");
            }
        }

        function openTabMenu(){
            if (!tabMenu) { tabMenu = tabMenuComp.createObject(page); }
            tabMenu.caller = tabGroup.currentTab;
            tabMenu.open();
        }

        function getCurrentUrl(){
            var tid = tabGroup.currentTab.threadId;
            return "http://tieba.baidu.com/p/"+tid;
        }
    }

    Component {
        id: menuComp;
        Menu {
            id: menu;
            MenuLayout {
                MenuItem {
                    text: qsTr("Open Browser");
                    enabled: tabGroup.currentTab != null;
                    onClicked: {
                        utility.openURLDefault(internal.getCurrentUrl());
                    }
                    ToolButton {
                        width: 0.4 * parent.width;
                        anchors {
                            right: parent.right; rightMargin: platformStyle.paddingLarge;
                            verticalCenter: parent.verticalCenter;
                        }
                        text: qsTr("Copy Url")
                        flat: false;
                        onClicked: {
                            utility.copyToClipbord(internal.getCurrentUrl());
                            signalCenter.showMessage(qsTr("Url is copied to system clipboard"));
                            menu.close();
                        }
                    }
                }
                MenuItem {
                    platformSubItemIndicator: true;
                    text: qsTr("Jump Page");
                    enabled: tabGroup.currentTab != null && tabGroup.currentTab.thread != null;
                    onClicked: {
                        if (!pageJumper){
                            pageJumper = Qt.createComponent("Dialog/PageJumper.qml").createObject(page);
                            pageJumper.accepted.connect(internal.jumpToPage);
                        }
                        pageJumper.totalPage = tabGroup.currentTab.totalPage;
                        pageJumper.currentValue = tabGroup.currentTab.currentPage;
                        pageJumper.open();
                    }
                }
                MenuItem {
                    text: qsTr("Options");
                    enabled: tabGroup.currentTab != null && tabGroup.currentTab.thread != null;
                    ButtonRow {
                        exclusive: false;
                        anchors {
                            right: parent.right; rightMargin: platformStyle.paddingLarge;
                            verticalCenter: parent.verticalCenter;
                        }
                        width: parent.width - 100;
                        ToolButton {
                            text: qsTr("View Original");
                            visible: tabGroup.currentTab ? tabGroup.currentTab.isLz || tabGroup.currentTab.isReverse : false;
                            flat: false;
                            onClicked: {
                                menu.close();
                                var c = tabGroup.currentTab;
                                c.isLz = false;
                                c.isReverse = false;
                                c.getlist();
                            }
                        }
                        ToolButton {
                            text: qsTr("Author Only");
                            visible: tabGroup.currentTab ? !tabGroup.currentTab.isLz : false;
                            flat: false;
                            onClicked: {
                                menu.close();
                                var c = tabGroup.currentTab;
                                c.isLz = true;
                                c.isReverse = false;
                                c.getlist();
                            }
                        }
                        ToolButton {
                            text: qsTr("Reverse");
                            visible: tabGroup.currentTab ? !tabGroup.currentTab.isReverse : false;
                            flat: false;
                            onClicked: {
                                menu.close();
                                var c = tabGroup.currentTab;
                                c.isLz = false;
                                c.isReverse = true;
                                c.getlist();
                            }
                        }
                    }
                }
                MenuItem {
                    platformSubItemIndicator: true;
                    text: qsTr("Manage");
                    enabled: tabGroup.currentTab != null
                             && tabGroup.currentTab.user != null
                             && tabGroup.currentTab.user.is_manager != 0;
                    onClicked: dialog.threadManage(tabGroup.currentTab);
                }
            }
        }
    }

    Component {
        id: tabMenuComp;
        ContextMenu {
            id: tabMenu;
            property variant caller: null;
            MenuLayout {
                MenuItem {
                    text: qsTr("Close current tab");
                    onClicked: internal.removeThreadPage(tabMenu.caller);
                }
                MenuItem {
                    text: qsTr("Close other tabs");
                    onClicked: internal.removeOtherThread(tabMenu.caller);
                }
                MenuItem {
                    text: qsTr("Close all tabs");
                    onClicked: internal.removeAllThread();
                }
            }
        }
    }

    TabHeader { id: viewHeader; }
    ViewHeader {
        opacity: viewHeader.layout.children.length == 0 ? 1 : 0;
        headerText: qsTr("Tab Page");
        headerIcon: "gfx/switch_windows.svg";
        enabled: false;
    }

    TabGroup {
        id: tabGroup;
        anchors { fill: parent; topMargin: viewHeader.height; }
    }
}
