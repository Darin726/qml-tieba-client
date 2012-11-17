import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: subFloorPage

    title: thread.title || ""

    property bool loading

    property string threadId
    property bool isLz

    property variant forum: ({})
    property variant thread: ({})
    property variant post: ({})
    property variant page: ({})

    property string subpostId
    property string postId

    property int manageGroup

    property int pageNumber: 1
    onPageNumberChanged: {
        if(pageNumber>page.total_page) pageNumber = page.total_page
    }

    property alias view: subFloorView

    function getlist(isRenew){
        pageNumber = isRenew ? 1 : pageNumber + 1
        var opt = {
            pid: postId, pn: pageNumber, spid: postId==0?subpostId:0, renew: isRenew?1:0
        }
        Script.getSubfloorList(subFloorPage, threadId, opt)
    }

    function addReply(vcode, vcodeMd5){
        if (replyField.text==""){
            app.showMessage("请输入回复内容")
        } else {
            Script.postReply(subFloorPage, replyField.text, forum, threadId, post.floor, post.id, vcode, vcodeMd5)
        }
    }

    function commitprison(name){
        var diag = Qt.createComponent("Dialog/CommitPrisonDialog.qml").createObject(subFloorPage)
        diag.userName = name; diag.caller = subFloorPage;
        diag.open()
    }

    Connections {
        target: signalCenter
        onGetSubfloorListStarted: {
            if (caller == subFloorPage.toString())
                loading = true
        }
        onGetSubfloorListFailed: {
            if (caller == subFloorPage.toString()){
                loading = false
                app.showMessage(errorString)
            }
        }
        onGetSubfloorListSuccessed: {
            if (caller == subFloorPage.toString()){
                loading = false
            }
        }
        onPostReplyStarted: {
            if (caller == subFloorPage.toString()){
                loading = true
            }
        }
        onPostReplyFailed: {
            if (caller == subFloorPage.toString()){
                loading = false
                app.showMessage(errorString)
            }
        }
        onPostReplySuccessed: {
            if (caller == subFloorPage.toString()){
                loading = false
                app.showMessage("回复成功")
                replyField.text = ""
                app.multiThread(function(){getlist(true)})
            }
        }
        onVcodeSent: {
            if (caller == subFloorPage.toString()){
                addReply(vcode, vcodeMd5)
            }
        }
        onEmotionSelected: {
            if (caller == subFloorPage.toString()){
                var pos = replyField.cursorPosition
                var str1 = replyField.text.slice(0, pos)
                var str2 = replyField.text.slice(pos)
                replyField.text = str1 + name + str2
                replyField.cursorPosition = pos + name.length
            }
        }
        onSwipeRight: {
            if (status == PageStatus.Active)
                pageStack.pop()
        }
        onManageFailed: {
            if (caller == subFloorPage.toString()){
                app.showMessage(errorString)
            }
        }
        onManageSuccessed: {
            if (caller == subFloorPage.toString()){
                app.showMessage("操作成功");
                if (option == "delpost"){
                    if (postId == post.id){
                        pageStack.pop()
                    } else {
                        for (var i=0, l=subpostList.count;i<l;i++){
                            if (subpostList.get(i).data.id == postId){
                                subpostList.remove(i);
                                break;
                            }
                        }
                    }
                }
            }
        }
        onLoadFailed: loading = false;
    }
    onStatusChanged: {
        if (status == PageStatus.Active)
            subFloorView.forceActiveFocus()
    }
    Keys.onPressed: {
        switch (event.key){
        case Qt.Key_Backspace:
            pageStack.pop();
            event.accepted = true;
            break;
        case Qt.Key_Right:
            if(page.current_page < page.total_page)
                getlist()
            event.accepted = true;
            break;
        case Qt.Key_R:
            getlist(true);
            event.accepted = true;
            break;
        }
    }

    tools: ToolBarLayout {
        ToolButton { iconSource: "toolbar-back"; onClicked: pageStack.pop() }
        ToolButton { text: "回复"; onClicked: addReply(); enabled: !loading }
        ToolButton { iconSource: "qrc:/gfx/add_bookmark%1.svg".arg(platformInverted?"_inverted":"");
            onClicked: app.addBookmark(threadId, post.id, thread.author.name_show, thread.title, isLz) }
    }
    Label {
        anchors.centerIn: parent
        text: "正在加载数据..."
        visible: loading && !viewHeader.visible
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
    }

    ViewHeader {
        id: viewHeader
        visible: post.floor != undefined
        headerText: post.floor+"楼"
    }
    ListModel { id: subpostList }
    ListView {
        id: subFloorView
        anchors { fill: parent; topMargin: viewHeader.height; bottomMargin: replyArea.height }
        clip: true
        pressDelay: 200
        model: subpostList
        header: post.author ? postHeader : null
        delegate: subpostDelegateComp
        footer: Item {
            width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0
            visible: page.current_page < page.total_page
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !loading
                text: loading ? "加载中..." : "点击加载更多"
                onClicked: getlist()
            }
        }

        Component {
            id: postHeader
            Item {
                width: screen.width
                implicitHeight: headerCol.height + platformStyle.paddingLarge
                MouseArea{
                    anchors.fill: parent
                    onPressAndHold: {
                        var diag = Qt.createComponent("Dialog/SubfloorMenu.qml").createObject(subFloorPage)
                        diag.modelData = post;
                        diag.open()
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    color: tbsettings.whiteTheme ? "#C0E6E6E6" : "#C0202020"
                }
                ListItemText {
                    anchors {
                        right: parent.right; rightMargin: platformStyle.paddingSmall;
                        bottom: parent.bottom; bottomMargin: platformStyle.paddingLarge
                    }
                    platformInverted: tbsettings.whiteTheme
                    text: Qt.formatDateTime(new Date(post.time*1000), "yyyy-MM-dd hh:mm:ss")
                    role: "SubTitle"
                }
                Column {
                    id: headerCol
                    width: parent.width
                    spacing: platformStyle.paddingMedium
                    Row {
                        spacing: platformStyle.paddingMedium
                        Image {
                            width: platformStyle.graphicSizeMedium; height: platformStyle.graphicSizeMedium;
                            sourceSize: Qt.size(width, height)
                            Component.onCompleted: {
                                if (post.author.type != 0 && tbsettings.showAvatar){
                                    source = "http://tb.himg.baidu.com/sys/portraitn/item/"+post.author.portrait
                                } else {
                                    source = "qrc:/gfx/photo.png"
                                }
                            }
                        }
                        ListItemText {
                            text: post.author.name_show +
                                  ( post.author.is_like == 1 ? "\nLv."+post.author.level_id : "" )
                            platformInverted: tbsettings.whiteTheme
                            role: "SubTitle"
                        }
                    }
                    Label {
                        anchors {
                            left: parent.left; right: parent.right; margins: platformStyle.paddingLarge
                        }
                        text: post.contentString
                        font.pixelSize: tbsettings.fontSize
                        platformInverted: tbsettings.whiteTheme
                        wrapMode: Text.Wrap
                    }
                    Row {
                        anchors {
                            left: parent.left; leftMargin: platformStyle.paddingLarge
                        }
                        Image {
                            source: "qrc:/gfx/pb_reply.png"
                        }
                        ListItemText {
                            anchors.verticalCenter: parent.verticalCenter
                            platformInverted: tbsettings.whiteTheme
                            text: page.total_count || 0
                            role: "SubTitle"
                        }
                    }
                }
            }
        }
        Component {
            id: subpostDelegateComp
            ListItemT {
                id: listItem
                platformInverted: tbsettings.whiteTheme
                implicitHeight: authorShow.height + contentShow.height + 32
                onClicked: {replyField.text = "回复 "+modelData.author.name+" :"; replyField.focus = true;}
                onPressAndHold: {
                    var diag = Qt.createComponent("Dialog/SubfloorMenu.qml").createObject(subFloorPage)
                    diag.modelData = modelData;
                    diag.open()
                }
                ListItemText {
                    id: authorShow
                    anchors {
                        left: listItem.paddingItem.left; top: listItem.paddingItem.top;
                    }
                    text: modelData.author.name_show
                    platformInverted: listItem.platformInverted
                    role: "SubTitle"
                }
                ListItemText {
                    platformInverted: listItem.platformInverted
                    anchors {
                        right: listItem.paddingItem.right; top: listItem.paddingItem.top
                    }
                    text: Qt.formatDateTime(new Date(modelData.time*1000), "yyyy-MM-dd hh:mm:ss")
                    role: "SubTitle"
                }
                Label {
                    id: contentShow
                    anchors {
                        left: listItem.paddingItem.left; right: listItem.paddingItem.right;
                        top: authorShow.bottom; topMargin: platformStyle.paddingMedium
                    }
                    text: modelData.contentString
                    font.pixelSize: tbsettings.fontSize
                    platformInverted: listItem.platformInverted
                    wrapMode: Text.Wrap
                    onLinkActivated: signalCenter.linkActivated(link)
                }
            }
        }
    }
    Row {
        id: replyArea
        anchors.bottom: parent.bottom
        width: parent.width
        Button {
            id: emoBtn
            platformInverted: tbsettings.whiteTheme
            iconSource: "qrc:/gfx/write_face_%1.png".arg(pressed?"s":"n")
            onClicked: {
                var emo = Qt.createComponent("Dialog/EmotionSelector.qml").createObject(subFloorPage, {inSubfloor: true})
                emo.open()
            }
        }
        TextField {
            id: replyField
            width: parent.width - emoBtn.width
            platformInverted: tbsettings.whiteTheme
            placeholderText: "添加回复"
            KeyNavigation.up: subFloorView
        }
    }
}
