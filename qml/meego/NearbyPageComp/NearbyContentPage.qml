import QtQuick 1.1
import com.nokia.meego 1.0
import "../Component"
import "../../js/main.js" as Script

Page {
    id: page;

    property bool loading: false;
    property string threadId: "";

    property variant user: null;
    property variant forum: null;
    property variant thread: null;
    property variant location: null;

    property int currentPage: 1;
    property int totalPage: 1;
    property bool hasPrev: false;
    property bool hasMore: false;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            iconSource: theme.inverted ? "../gfx/map.svg" : "../gfx/map_inverted.svg";
            onClicked: {
                Qt.openUrlExternally("geo:"+location.lat+","+location.lng);
            }
        }
    }

    function getlist(option){
        option = option || "renew";
        var opt = { kz: threadId, model: listModel, weipost: 1 }
        if (option == "renew"){
            currentPage = 1;
            opt.pn = 1;
            opt.renew = true;
        } else if (option == "more"){
            opt.pid = listModel.get(listModel.count-1).modelData.id;
            if (hasMore) { opt.pn = currentPage + 1; }
        }
        Script.getPostList(page, opt);
    }

    function reply(vcode, vcodeMd5){
        if (replyField.text.length == 0){
            signalCenter.showMessage(qsTr("Content is required"));
            return;
        }
        var opt = {
            content: replyField.text,
            fid: forum.id,
            kw: forum.name,
            tid: thread.id
        }
        if (vcode){
            opt.vcode = vcode;
            opt.vcodeMd5 = vcodeMd5;
        }
        Script.addPost(page, opt);
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
        onPostStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onPostFinished: {
            if (caller == page.toString()){
                loading = false;
                replyField.text = "";
                if (!hasMore){
                    getlist("more");
                }
            }
        }
        onPostFailed: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onVcodeSent: {
            if (caller == page.toString()){
                reply(vcode, vcodeMd5);
            }
        }
        onEmotionSelected: {
            if (caller == page.toString()){
                var c = replyField.cursorPosition;
                replyField.text = replyField.text.substring(0,c)+name+replyField.text.substring(c);
                replyField.cursorPosition = c+name.length;
            }
        }
        onLoadFailed: loading = false;
    }

    ViewHeader {
        id: viewHeader;
        loading: page.loading;
        headerText: location ? location.name||qsTr("lat:%1, lon:%2").arg(location.lat).arg(location.lng)
                             : qsTr("Weipost");
    }

    ListView {
        id: view;
        anchors { left: parent.left; right: parent.right; top: viewHeader.bottom; bottom: replyArea.top; }
        model: ListModel { id: listModel; }
        delegate: Loader { source: modelData.floor == 1 ? "NearbyAuthorDelegate.qml" : "NearbyReplyDelegate.qml" }
        footer: FooterItem {
            visible: listModel.count > 0;
            enabled: !loading;
            text: hasMore ? qsTr("Next Page") : qsTr("Load More");
            onClicked: getlist("more");
        }
        header: PullToActivate {
            myView: view;
            onRefresh: getlist();
        }
    }

    Item {
        id: replyArea;
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; }
        height: childrenRect.height;
        Button {
            id: emoBtn;
            platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
            iconSource: theme.inverted ? "../gfx/btn_insert_face_res.png" : "../gfx/btn_insert_face_nor.png";
            onClicked: dialog.selectEmotion(page, true);
        }
        Button {
            id: replyButton;
            anchors.right: parent.right;
            platformStyle: ButtonStyle { buttonWidth: buttonHeight*2; inverted: !theme.inverted; }
            enabled: !loading && forum != null;
            text: qsTr("Reply").substring(0, 2);
            onClicked: reply();
        }
        TextField {
            id: replyField;
            anchors { left: emoBtn.right; right: replyButton.left; verticalCenter: emoBtn.verticalCenter; }
            placeholderText: qsTr("Add Reply");
        }
    }
}
