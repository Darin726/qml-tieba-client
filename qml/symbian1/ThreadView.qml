import QtQuick 1.0
import com.nokia.symbian 1.0
import "../js/main.js" as Script
import "Delegate"
import "Component"

Page {
    id: page;

    property bool loading: false;
    property string title: thread ? thread.title : qsTr("New Tab");
    property string threadId: "";

    property variant user: null;
    property variant forum: null;
    property variant thread: null;

    property int currentPage: 1;
    property bool __currentPageAvailable: true;

    property int totalPage: 1;
    property bool hasMore: false;
    property bool hasPrev: false;

    property bool isLz: false;
    property bool isReverse: false;

    property alias listView: view;

    function positionAtTop(){
        internal.openTabMenu();
    }

    function getlist(option){
        option = option||"renew";
        var opt = { kz: threadId, model: listModel, lz: isLz, r: isReverse };
        if (option == "renew"){
            __currentPageAvailable = true;
            opt.renew = true;
            if (isReverse){
                if (listModel.count > 0){
                    opt.pid = listModel.get(listModel.count-1).modelData.id;
                    opt.pn = totalPage;
                } else {
                    opt.last = 1;
                }
            } else {
                opt.pn = 1;
            }
        } else if (option == "next"){
            opt.pid = listModel.get(listModel.count-1).modelData.id;
            if (hasMore && __currentPageAvailable){ opt.pn = isReverse ? currentPage-1 : currentPage+1 }
        } else if (option == "prev"){
            opt.back = true;
            opt.pid = listModel.get(0).modelData.id;
            if (hasPrev && __currentPageAvailable){ opt.pn = isReverse ? currentPage+1 : currentPage-1 }
        } else if (option == "jump"){
            __currentPageAvailable = true;
            opt.renew = true;
            opt.pn = currentPage;
        } else if (/\d+/.test(option)){
            __currentPageAvailable = false;
            opt.renew = true;
            opt.mark = true;
            opt.st = "tb_bookmarklist";
            opt.pid = option;
        }
        Script.getPostList(page, opt);
    }

    function removefloor(pid){
        for (var i=0, l=listModel.count;i<l;i++){
            if (pid == listModel.get(i).modelData.id){
                listModel.remove(i);
                break;
            }
        }
    }

    Connections {
        target: signalCenter;
        onGetPostListStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetPostListFinished: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onLoadFailed: {
            loading = false;
        }
        onThreadDeleted: {
            if (caller == page.toString()){
                internal.removeThreadPage(page);
            }
        }
        onPostDeleted: {
            if (caller == page.toString()){
                removefloor(pid);
            }
        }
    }

    ListView {
        id: view;
        anchors.fill: parent;
        pressDelay: 50;
        model: ListModel { id: listModel; }
        delegate: PostListDelegate {
            onClicked: {
                if (modelData.floor == 1){
                    pressAndHold();
                } else {
                    app.enterFloor({threadId: threadId, postId: modelData.id, manager: page.user.is_manager});
                }
            }
            onPressAndHold: {
                dialog.createThreadMenu(page, index, modelData);
            }
        }
        header: FooterItem {
            visible: listModel.count > 0 && (isReverse || hasPrev);
            text: isReverse ? hasPrev ? qsTr("Next Page") : qsTr("Load More") : qsTr("Prev Page");
            enabled: !loading;
            onClicked: {
                getlist("prev");
            }
        }
        footer: FooterItem {
            visible: listModel.count > 0 && (!isReverse || hasMore);
            text: isReverse ? qsTr("Prev Page") : hasMore ? qsTr("Next Page") : qsTr("Load More");
            enabled: !loading;
            onClicked: {
                getlist("next");
            }
        }
    }

    Column {
        id: naviButton;
        anchors {
            right: parent.right; rightMargin: platformStyle.paddingSmall; verticalCenter: parent.verticalCenter;
        }
        opacity: view.moving ? 0 : 0.5;
        Behavior on opacity { NumberAnimation { duration: 200; } }
        spacing: platformStyle.paddingLarge*2;
        Button {
            iconSource: privateStyle.toolBarIconPath("toolbar-mediacontrol-play");
            rotation: -90;
            enabled: !view.atYBeginning;
            onClicked: {
                view.contentY -= view.height;
                if (view.atYBeginning) view.positionViewAtBeginning();
            }
            onPlatformPressAndHold: view.positionViewAtBeginning();
        }
        Button {
            iconSource: privateStyle.toolBarIconPath("toolbar-mediacontrol-play");
            rotation: 90;
            enabled: !view.atYEnd;
            onClicked: {
                view.contentY += view.height;
                if (view.atYEnd) view.positionViewAtEnd();
            }
            onPlatformPressAndHold: view.positionViewAtEnd();
        }
    }

}
