import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

Page {
    id: page;

    property string name: "";
    property bool loading: false;

    property variant forum: null;
    property bool hasMore: false;

    property int batchStart: 1;
    property int batchEnd: 240;
    property int cursor: 0;

    property variant photolist: [];

    property QtObject forumInfoDialog: null;

    orientationLock: PageOrientation.LockPortrait;

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
            platformIconId: "toolbar-list";
            enabled: forum != null;
            onClicked: {
                tbsettings.viewPhoto = false;
                var p = pageStack.replace(Qt.resolvedUrl("ForumPage.qml"), { forum: forum })
                p.getlist();
            }
        }
        ToolIcon {
            platformIconId: "toolbar-edit";
            enabled: forum != null;
            onClicked: {
                if (tbsettings.shareLocation) positionSource.update();
                var param = {fid: forum.id, kw: forum.name, caller: page}
                pageStack.push(Qt.resolvedUrl("PostPage.qml"), {param: param});
            }
        }
    }

    function getlist(option){
        option = option || "renew";
        var opt = { kw: forum?forum.name:name, model1: listModel1, model2: listModel2 }
        if (option == "renew"){
            page.hasMore = false;
            batchStart = 1;
            batchEnd = 240;
            photolist = [];
            opt.bs = batchStart;
            opt.be = batchEnd;
            Script.getPhotoBatch(page, opt);
        } else if (option == "more"){
            if (cursor < photolist.length){
                var list = photolist.slice(cursor, Math.min(cursor+30, photolist.length));
                opt.ids = list;
                Script.getPhotoList(page, opt);
            } else if (hasMore){
                opt.bs = batchEnd+1;
                opt.be = batchEnd+240;
                Script.getPhotoBatch(page, opt);
            }
        } else if (option == "prev"){
            if (batchStart > 240){
                opt.bs = batchStart - 240;
                opt.be = batchStart - 1;
            } else {
                opt.bs = 1;
                opt.be = 240;
            }
            Script.getPhotoBatch(page, opt);
        }
    }

    Connections {
        target: signalCenter;
        onGetThreadListStarted: {
            if (caller == page.toString()){
                page.loading = true;
            }
        }
        onGetThreadListFinished: {
            if (caller == page.toString()){
                page.loading = false;
            }
        }
        onLoadFailed: {
            page.loading = false;
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: (forum?forum.name:name)+qsTr("Bar");
        loading: page.loading;
        enabled: forum != null;
        onClicked: {
            if (!forumInfoDialog){
                forumInfoDialog = Qt.createComponent("Dialog/ForumInfoDialog.qml").createObject(page);
            }
            forumInfoDialog.open();
        }
    }

    Flickable {
        id: flickable;

        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: parent.width;
        contentHeight: contentCol.height;

        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            FooterItem {
                visible: batchStart > 240;
                enabled: !loading;
                text: qsTr("Prev Page");
                onClicked: getlist("prev");
            }
            Row {
                anchors { left: parent.left; right: parent.right; }
                Column {
                    width: parent.width / 2;
                    Repeater {
                        model: ListModel { id: listModel1; property int cursor: 0; }
                        PhotoDelegate {}
                    }
                }
                Column {
                    width: parent.width / 2;
                    Repeater {
                        model: ListModel { id: listModel2; property int cursor: 0; }
                        PhotoDelegate {}
                    }
                }
            }
            FooterItem {
                visible: cursor < photolist.length || hasMore;
                enabled: !loading;
                onClicked: getlist("more");
            }
        }
    }

    ScrollDecorator { flickableItem: flickable; }
}
