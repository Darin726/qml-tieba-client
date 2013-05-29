import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

Page {
    id: page;

    property string name: "";
    property variant forum: null;
    property int currentPage: 1;
    property int totalPage: 1;
    property bool hasMore: false;
    property bool hasPrev: false;
    property int curGoodId: 0;
    property bool loading: false;
    property bool isGood: false;

    property string title: (forum?forum.name:name)+qsTr("Bar");

    property QtObject forumInfoDialog: null;
    property QtObject goodSelector: null;
    property QtObject forumMenu: null;
    property QtObject pageJumper: null;

    function getlist(option){
        option = option||"renew";
        if (option == "renew"){
            hasPrev = false;
            hasMore = false;
            currentPage = 1;
        } else if (option == "more"){
            currentPage ++;
        } else if (option == "prev"){
            currentPage --;
        }
        var opt = {
            kw: forum?forum.name:name,
            pn: currentPage,
            classModel: classModel,
            threadModel: threadModel,
            isGood: isGood,
            cid: curGoodId
        }
        Script.getThreadList(page, opt);
    }

    function goodSelected(){
        if (!goodSelector){
            curGoodId = 0;
            isGood = !isGood;
            getlist();
        } else {
            if (goodSelector.selectedIndex == -1){
                isGood = false;
                getlist();
            } else {
                curGoodId = classModel.get(goodSelector.selectedIndex).id;
                isGood = true;
                getlist();
            }
        }
    }

    function jumpToPage(){
        if (!pageJumper) return;
        currentPage = pageJumper.currentValue;
        getlist("jump");
    }

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: getlist();
        }
        ToolIcon {
            platformIconId: "toolbar-pages-all";
            onClicked: app.enterThread();
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu";
            enabled: forum?true:false;
            onClicked: {
                if (!forumMenu){ forumMenu = menuComp.createObject(page); }
                forumMenu.open();
            }
        }
    }

    Connections {
        target: signalCenter;
        onGetThreadListStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetThreadListFinished: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onLoadFailed: {
            loading = false;
        }
    }

    ListModel { id: classModel; }
    ListModel { id: threadModel; }

    Component {
        id: menuComp;
        Menu {
            id: menu;
            MenuLayout {
                MenuItem {
                    text: qsTr("Boutique");
                    onClicked: {
                        if (forum.good_classify.length == 0){
                            goodSelected();
                        } else {
                            if (!goodSelector){
                                goodSelector = Qt.createComponent("Dialog/GoodSelector.qml").createObject(page, { model: classModel });
                                goodSelector.accepted.connect(goodSelected);
                            }
                            goodSelector.open();
                        }
                    }
                }
                MenuItem {
                    text: qsTr("Image Zone");
                    onClicked: {
                        tbsettings.viewPhoto = true;
                        var p = pageStack.replace(Qt.resolvedUrl("ForumPicturePage.qml"), { forum: forum });
                        p.getlist();
                    }
                }
                MenuItem {
                    text: qsTr("Jump Page");
                    onClicked: {
                        if (!pageJumper){
                            pageJumper = Qt.createComponent("Dialog/PageJumper.qml").createObject(page);
                            pageJumper.accepted.connect(jumpToPage);
                        }
                        pageJumper.totalPage = totalPage;
                        pageJumper.currentValue = currentPage;
                        pageJumper.open();
                    }
                }
                MenuItem {
                    text: qsTr("Create A New Thread");
                    onClicked: {
                        if (tbsettings.shareLocation) positionSource.update();
                        var param = {fid: forum.id, kw: forum.name, caller: page}
                        pageStack.push(Qt.resolvedUrl("PostPage.qml"), {param: param});
                    }
                }
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: {
            if (!isGood){
                return page.title;
            } else {
                if (goodSelector){
                    return classModel.get(goodSelector.selectedIndex).name;
                } else {
                    return qsTr("Boutique");
                }
            }
        }
        loading: page.loading;
        enabled: forum != null;
        onClicked: {
            if (!forumInfoDialog){
                forumInfoDialog = Qt.createComponent("Dialog/ForumInfoDialog.qml").createObject(page);
            }
            forumInfoDialog.open();
        }
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: threadModel;
        cacheBuffer: height * 3;
        delegate: ThreadListDelegate {}
        header: PullToActivate {
            enabled: !loading;
            pullDownMessage: hasPrev ? qsTr("Pull Down To Load Prev") : qsTr("Pull Down To Refresh");
            myView: view;
            onRefresh: {
                if (hasPrev){
                    getlist("prev");
                } else {
                    getlist();
                }
            }
        }
        footer: FooterItem {
            enabled: !loading;
            visible: hasMore;
            onClicked: getlist("more");
        }
    }

    ScrollDecorator { flickableItem: view; }
}
