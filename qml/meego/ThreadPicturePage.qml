import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

Page {
    id: page;

    property bool loading: false;
    property variant forum: null;

    property string tid: "";
    property int picAmount: 0;

    tools: defaultTools;

    ToolBarLayout {
        id: defaultTools;
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-edit";
            enabled: view.currentItem != null;
            onClicked: replyArea.state = "show";
        }
        ToolIcon {
            platformIconId: "toolbar-down";
            enabled: view.currentItem != null;
            onClicked: {
                var url = listModel.get(view.currentIndex).img.original.url;
                var path = tbsettings.savePath + "/" + url.split("/").pop();
                if (utility.saveCache(url, path)){
                    signalCenter.showMessage(qsTr("Image saved to ")+path);
                } else {
                    downloader.appendDownload(url, path);
                }
            }
        }
    }
    ToolBarLayout {
        id: replyTools;
        parent: null;
        visible: parent != null;
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-close";
            onClicked: replyArea.state = "";
        }
    }

    function getlist(option){
        option = option || "renew";
        var opt = { kw: forum.name, tid: tid, model: listModel, prev: 0 };
        if (option == "renew"){
            opt.renew = true;
            opt.next = 9;
        } else if (option == "more"){
            opt.next = 10;
            opt.picid = listModel.get(listModel.count-1).img.original.id;
        }
        Script.getPhotoPage(page, opt);
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
            tid: tid,
            quote_id: listModel.get(view.currentIndex).post_id,
            floor_num: 0
        }
        if (vcode){
            opt.vcode = vcode;
            opt.vcodeMd5 = vcodeMd5;
        }
        Script.addPost(view.currentItem, opt);
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
            replyButton.enabled = true;
        }
        onPostStarted: {
            signalCenter.showBusyIndicator();
            replyButton.enabled = false;
        }
        onPostFinished: {
            replyArea.state = "";
            replyButton.enabled = true;
        }
        onPostFailed: {
            replyButton.enabled = true;
        }
        onVcodeSent: {
            if (caller == view.currentItem.toString()){
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
    }

    ViewHeader {
        id: viewHeader;
        headerText: (view.currentItem?listModel.get(view.currentIndex).index:0) + "/" + picAmount;
        loading: page.loading;
    }

    ListView {
        id: view;
        anchors { left: parent.left; right: parent.right; top: viewHeader.bottom; bottom: replyArea.top; }
        onCurrentIndexChanged: {
            var data = listModel.get(currentIndex);
            if (data && currentIndex == listModel.count-1 && data.index < picAmount && !loading){
                getlist("more");
            }
        }
        cacheBuffer: 1;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        snapMode: ListView.SnapOneItem;
        orientation: ListView.Horizontal;
        boundsBehavior: Flickable.StopAtBounds;
        model: ListModel { id: listModel; }
        delegate: ThreadPictureDelegate {}
    }

    Item {
        id: replyArea;
        anchors { left: parent.left; right: parent.right; top: parent.bottom; }
        height: childrenRect.height;
        opacity: 0;
        Button {
            id: emoBtn;
            platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
            iconSource: theme.inverted ? "gfx/btn_insert_face_res.png" : "gfx/btn_insert_face_nor.png";
            onClicked: dialog.selectEmotion(page, true);
        }
        Button {
            id: replyButton;
            anchors.right: parent.right;
            platformStyle: ButtonStyle { buttonWidth: buttonHeight*2; inverted: !theme.inverted; }
            text: qsTr("Reply").substring(0, 2);
            onClicked: reply();
        }
        TextField {
            id: replyField;
            anchors { left: emoBtn.right; right: replyButton.left; verticalCenter: emoBtn.verticalCenter; }
            placeholderText: qsTr("Add Reply");
        }
        states: [
            State {
                name: "show";
                AnchorChanges { target: replyArea; anchors.top: undefined; anchors.bottom: page.bottom; }
                PropertyChanges { target: replyArea; opacity: 1; }
                PropertyChanges { target: replyField; text: ""; }
            }
        ]
        transitions: [
            Transition {
                to: "";
                AnchorAnimation { duration: 200; }
                PropertyAnimation { property: "opacity"; duration: 200; }
                ScriptAction { script: pageStack.toolBar.setTools(defaultTools, "replace"); }
            },
            Transition {
                to: "show";
                AnchorAnimation { duration: 200; }
                PropertyAnimation { property: "opacity"; duration: 200; }
                ScriptAction { script: pageStack.toolBar.setTools(replyTools, "replace"); }
            }
        ]
    }
}
