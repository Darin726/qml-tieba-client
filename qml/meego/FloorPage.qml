import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script
import "../js/Calculate.js" as Calc

Page {
    id: page;

    property bool loading: false;

    property variant forum: null;
    property variant thread: null;
    property variant post: null;
    property int manager: 0;

    property int currentPage: 1;
    property int totalPage: 1;
    property int totalCount: 0;

    property string threadId: "";
    property string postId: "";
    property string subpostId: "";

    property QtObject floorMenu: null;
    property QtObject pageJumper: null;

    function getlist(option){
        option = option||"renew";
        var opt = { kz: threadId, pid: postId, spid: subpostId, model: listModel, renew: true }
        if (option == "renew"){
            opt.pn = 1;
        } else if (option == "next"){
            opt.pn = currentPage+1;
            opt.renew = false;
        } else if (option == "prev"){
            opt.pn = currentPage-1;
        } else if (option == "jump"){
            opt.pn = currentPage;
        }
        Script.getFloorList(page, opt);
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
            tid: thread.id,
            quote_id: post.id,
            floor_num: 0
        }
        if (vcode){
            opt.vcode = vcode;
            opt.vcodeMd5 = vcodeMd5;
        }
        Script.addPost(page, opt);
    }

    function jumpToPage(){
        if (!pageJumper) return;
        currentPage = pageJumper.currentValue;
        getlist("jump");
    }

    function removefloor(pid){
        if (pid == post.id){ pageStack.pop(); }
        else {
            for (var i=0, l=listModel.get(i).id; i<l; i++){
                if (pid == listModel.get(i).id){
                    listModel.remove(i);
                    break;
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu";
            enabled: post != null;
            onClicked: {
                if (!floorMenu){
                    floorMenu = menuComp.createObject(page);
                }
                floorMenu.open();
            }
        }
    }

    Connections {
        target: signalCenter;
        onGetFloorListStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetFloorListFinished: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onLoadFailed: {
            loading = false;
            replyButton.enabled = post != null;
        }
        onLoadFinished: {
            replyButton.enabled = post != null;
        }
        onPostStarted: {
            if (caller == page.toString()){
                signalCenter.showBusyIndicator();
                replyButton.enabled = false;
            }
        }
        onPostFinished: {
            if (caller == page.toString()){
                replyField.text = "";
                getlist("renew");
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
        onPostDeleted: {
            if (caller == page.toString()){
                removefloor(pid);
            }
        }
    }

    Component {
        id: menuComp;
        Menu {
            id: menu;
            MenuLayout {
                MenuItem {
                    text: qsTr("Add to bookmark");
                    onClicked: {
                        app.addBookmark(thread.id, post.id, thread.author.name_show, thread.title, false);
                    }
                }
                MenuItem {
                    text: qsTr("Jump To Page");
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
                    text: qsTr("View Original Thread");
                    onClicked: {
                        app.enterThread({ threadId: threadId });
                    }
                }
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: post ? post.floor + qsTr("#") : qsTr("Subfloor");
        loading: page.loading;
    }

    ListView {
        id: view;
        anchors {
            fill: parent;
            topMargin: viewHeader.height+constant.paddingSmall;
            bottomMargin: replyArea.height;
        }
        clip: true;
        model: ListModel { id: listModel; }
        header: post ? floorHeader : refreshHeader;
        delegate: FloorDelegate {
            onClicked: replyField.text = qsTr("Reply %1 :").arg(model.author.name);
            onPressAndHold: dialog.createThreadMenu(page, -1, model);
        }
        footer: FooterItem {
            visible: totalPage > currentPage;
            enabled: !loading;
            onClicked: {
                getlist("next");
            }
        }
    }

    Component {
        id: refreshHeader;
        PullToActivate { myView: view; onRefresh: getlist(); }
    }

    Component {
        id: floorHeader;
        Rectangle {
            id: root;

            width: ListView.view ? ListView.view.width : 0;
            height: contentCol.height + constant.paddingLarge;

            color: theme.inverted ? "#C0202020" : "#C0E6E6E6";
            radius: 5;

            opacity: mouseArea.pressed ? 0.7 : 1;

            PullToActivate { myView: view; onRefresh: getlist(); }

            Image {
                id: avatar;
                anchors { left: parent.left; top: parent.top; margins: constant.paddingMedium; }
                width: constant.graphicSizeMedium;
                height: constant.graphicSizeMedium;
                source: {
                    if (tbsettings.showAvatar){
                        return Calc.getAvatar(post.author.portrait);
                    } else {
                        return "gfx/photo.png";
                    }
                }
            }

            Column {
                id: contentCol;
                anchors { left: avatar.right; top: parent.top; right: parent.right; margins: constant.paddingMedium; }
                spacing: constant.paddingMedium;
                Item {
                    width: parent.width; height: childrenRect.height;
                    Text {
                        anchors.left: parent.left;
                        text: post.author.name_show + (post.author.is_like==1?"    Lv."+post.author.level_id:"");
                        font {
                            pixelSize: constant.fontSizeSmall;
                            weight: Font.Light;
                        }
                        color: constant.colorMid;
                    }
                    Text {
                        anchors.right: parent.right;
                        text: post.floor+"#";
                        font {
                            pixelSize: constant.fontSizeSmall;
                            weight: Font.Light;
                        }
                        color: constant.colorMid;
                    }
                }
                Text {
                    width: parent.width;
                    text: post.content.length > 150 ? post.content.substring(0, 149)+"..." : post.content;
                    font.pixelSize: tbsettings.fontSize;
                    wrapMode: Text.Wrap;
                    color: constant.colorLight;
                }
                Item {
                    width: parent.width; height: childrenRect.height;
                    Text {
                        anchors.left: parent.left;
                        text: Qt.formatDateTime(new Date(post.time*1000), "yyyy-MM-dd hh:mm:ss");
                        font {
                            pixelSize: constant.fontSizeSmall;
                            weight: Font.Light;
                        }
                        color: constant.colorMid;
                    }
                    Row {
                        anchors.right: parent.right;
                        Image { source: "gfx/pb_reply.png"; }
                        Text {
                            text: page.totalCount;
                            font {
                                pixelSize: constant.fontSizeSmall;
                                weight: Font.Light;
                            }
                            color: constant.colorMid;
                        }
                    }
                }
            }

            MouseArea {
                id: mouseArea;
                anchors.fill: parent;
                onPressAndHold: dialog.createThreadMenu(page, -1, post);
            }
        }
    }

    ScrollDecorator { flickableItem: view; }

    Item {
        id: replyArea;
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; }
        height: childrenRect.height;
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
            enabled: post != null;
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
