import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool loading: false;
    property variant forum: null;

    property string tid: "";
    property int picAmount: 0;

    tools: defaultTools;

    ToolBarLayout {
        id: defaultTools;
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Reply");
            enabled: view.currentItem != null;
            iconSource: "gfx/edit.svg";
            onClicked: replyArea.state = "show";
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Save image");
            enabled: view.currentItem != null;
            iconSource: "gfx/save.svg";
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
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            id: replyButton;
            toolTipText: qsTr("Reply");
            text: qsTr("Reply");
            onClicked: reply();
        }
        ToolButtonWithTip {
            enabled: replyButton.enabled;
            toolTipText: qsTr("Close input area");
            iconSource: "gfx/tb_close_stop.svg";
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
        headerIcon: "gfx/photos.svg";
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
        height: emoBtn.height;
        opacity: 0;
        Button {
            id: emoBtn;
            anchors { left: parent.left; bottom: parent.bottom; }
            iconSource: "gfx/btn_insert_face_res.png";
            onClicked: {
                dialog.selectEmotion(page, true);
            }
        }
        TextField {
            id: replyField;
            anchors { left: emoBtn.right; right: parent.right; verticalCenter: parent.verticalCenter; }
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
