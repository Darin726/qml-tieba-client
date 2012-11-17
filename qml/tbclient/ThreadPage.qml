import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

Page {
    id: threadPage

    property string threadId

    property variant forum: ({})
    property variant thread: ({})
    property int manageGroup

    property alias listModel: threadModel
    property alias threadView: view

    property bool hasFloor
    property bool isLz: false
    property bool isReverse: false
    property bool hasUpwards: false
    property bool hasDownwards: false

    property int topPage: 1
    property int downPage: 1
    property int currentPage: 1
    property int totalPage: 1

    property bool loading: false
    property bool jumpable: true

    function getList(type, option){
        switch (type){
        case "lz": isLz = true; isReverse = false; jumpable = true; break;
        case "reverse": isReverse = true; isLz = false; jumpable = false; break;
        case "default": isLz = false; isReverse = false; jumpable = true; break;
        default: jumpable = true; break;
        }
        if (option && option.hasOwnProperty("jumpable")) jumpable = option.jumpable
        var opt = {
            lz: isLz?1:0, r: isReverse?1:0, last: isReverse?1:0, pn: jumpable?1:0, renew: 1
        }
        if (option){
            for (var i in option) opt[i] = option[i]
        }
        Script.getThreadList(threadPage, threadId, opt)
    }
    function loadUpwards(){
        if (threadModel.count > 0){
            var opt = {
                lz: isLz?1:0,
                pid: threadModel.get(0).data.id,
                pn: hasUpwards&&jumpable?isReverse?topPage+1:topPage-1:0,
                r: isReverse?1:0,
                back: 1
            }
            Script.getThreadList(threadPage, threadId, opt)
        }
    }
    function loadDownwards(){
        if (threadModel.count > 0){
            var opt = {
                lz: isLz?1:0,
                pid: threadModel.get(threadModel.count-1).data.id,
                pn: hasDownwards&&jumpable?isReverse?downPage-1:downPage+1:0,
                r: isReverse?1:0
            }
            Script.getThreadList(threadPage, threadId, opt)
        }
    }
    function jumpToPage(page){
        jumpable = true;
        var opt = {
            lz: isLz?1:0, pn: page, r: isReverse?1:0, renew: 1
        }
        Script.getThreadList(threadPage, threadId, opt)
    }
    function postReply(){
        replyLoader.item.postReply()
    }
    function ding(){
        Script.ding(threadPage.toString(), forum, threadId)
    }
    function commitprison(name){
        var diag = Qt.createComponent("Dialog/CommitPrisonDialog.qml").createObject(threadPage)
        diag.userName = name; diag.caller = threadPage;
        diag.open()
    }
    Connections {
        target: signalCenter
        onLoadThreadStarted: {
            if (caller == threadPage.toString())
                loading = true
        }
        onLoadThreadFailed: {
            if (caller == threadPage.toString())
                loading = false
            app.showMessage(errorString)
        }
        onLoadThreadSuccessed: {
            if (caller == threadPage.toString())
                loading = false
        }
        onDingFailed: {
            if (caller == threadPage.toString())
                app.showMessage(errorString)
        }
        onDingSuccessed: {
            if (caller == threadPage.toString())
                app.showMessage("成功")
        }
        onManageFailed: {
            if (caller == threadPage.toString()){
                app.showMessage(errorString)
            }
        }
        onManageSuccessed: {
            if (caller == threadPage.toString()){
                app.showMessage("操作成功");
                if (option == "delpost"){
                    for (var i=0,l=threadModel.count;i<l;i++){
                        if (threadModel.get(i).data.id == postId){
                            threadModel.remove(i);
                            break;
                        }
                    }
                } else if (option == "delthread"){
                    threadGroupPage.internal.removeThreadPage(threadPage)
                }
            }
        }

        onLoadFailed: loading = false;
    }

    ListModel { id: threadModel }
    ListView {
        id: view
        property bool atYEndCache
        anchors { fill: parent; bottomMargin: replyLoader.height }
        clip: true
        focus: true
        cacheBuffer: height
        model: threadModel
        highlightMoveDuration: 400
        delegate: delegateItem;
        header: Item {
            width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0
            visible: (threadPage.isReverse||threadPage.hasUpwards) && view.count > 0
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !threadPage.loading
                text: threadPage.loading ? "加载中..." : threadPage.hasUpwards ? "加载更多" : "已无更多，点击继续加载"
                onClicked: loadUpwards()
            }
        }
        footer: Item {
            width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0
            visible: (!threadPage.isReverse||threadPage.hasDownwards) && view.count>0
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !threadPage.loading
                text: threadPage.loading ? "加载中..." : threadPage.hasDownwards ? "加载更多" : "已无更多，点击继续加载"
                onClicked: loadDownwards()
            }
        }
        Component {
            id: delegateItem
            ListItemT {
                id: listItem
                implicitHeight: contentCol.height + platformStyle.paddingLarge
                platformInverted: tbsettings.whiteTheme
                onClicked: {
                    if (threadPage.hasFloor && modelData.floor!=1)
                        app.enterSubfloor(threadId, modelData.id, undefined, isLz, manageGroup)
                    else
                        pressAndHold()
                }
                onPressAndHold: {
                    var itemMenu = Qt.createComponent("Dialog/ThreadMenu.qml").createObject(threadPage)
                    itemMenu.currentIndex = index; itemMenu.modelData = modelData;
                    itemMenu.open()
                }
                Column {
                    id: contentCol
                    width: parent.width
                    spacing: platformStyle.paddingMedium
                    Item {
                        width: parent.width; height: platformStyle.graphicSizeMedium
                        Image {
                            id: avatarImage
                            width: platformStyle.graphicSizeMedium; height: platformStyle.graphicSizeMedium
                            sourceSize: Qt.size(width, height)
                            asynchronous: true;
                            Component.onCompleted: {
                                if (tbsettings.showAvatar && modelData.author.type != 0){
                                    source = "http://tb.himg.baidu.com/sys/portraitn/item/"+modelData.author.portrait
                                } else {
                                    source = "qrc:/gfx/photo.png"
                                }
                            }
                            Image {
                                asynchronous: true;
                                anchors.fill: parent
                                sourceSize: Qt.size(width, height)
                                visible: parent.status != Image.Ready
                                source: visible ? "qrc:/gfx/photo.png" : ""
                            }
                            MouseArea {
                                anchors.fill: parent;
                                onClicked: {
                                    if (modelData.author.type != 0)
                                        app.enterProfilePage(modelData.author.id)
                                }
                            }
                        }
                        ListItemText {
                            anchors {
                                left: avatarImage.right; leftMargin: platformStyle.paddingMedium; verticalCenter: parent.verticalCenter
                            }
                            platformInverted: listItem.platformInverted
                            role: "SubTitle"
                            Component.onCompleted: {
                                var a = modelData.author
                                text = a.name_show + (a.is_like==1?"\nLv."+a.level_id:"")
                            }
                        }
                        ListItemText {
                            anchors.right: parent.right
                            text: modelData.floor+"#"
                            role: "SubTitle"
                            platformInverted: listItem.platformInverted
                        }
                    }
                    Repeater {
                        model: modelData.contentData
                        Loader {
                            x: platformStyle.paddingLarge
                            Component.onCompleted: {
                                if (modelData[0])
                                    sourceComponent = delegateLabel
                                else
                                    source = "Component/DelegateImage.qml"
                            }
                            Component {
                                id: delegateLabel
                                Label {
                                    width: contentCol.width - platformStyle.paddingLarge*2
                                    wrapMode: Text.Wrap
                                    platformInverted: listItem.platformInverted
                                    font.pixelSize: tbsettings.fontSize
                                    onLinkActivated: signalCenter.linkActivated(link)
                                    Component.onCompleted: {
                                        if (modelData[2]){
                                            textFormat = Text.RichText
                                            text = modelData[1].replace(/\n/g,"<br/>")
                                        } else {
                                            textFormat = Text.PlainText
                                            text = modelData[1]
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ListItemText {
                        anchors {
                            right: parent.right; rightMargin: platformStyle.paddingSmall
                        }
                        platformInverted: listItem.platformInverted
                        text: Qt.formatDateTime(new Date(modelData.time*1000),"yyyy-MM-dd hh:mm:ss")
                        role: "SubTitle"
                    }
                }
                Row {
                    anchors {
                        left: listItem.paddingItem.left; bottom: listItem.paddingItem.bottom
                    }
                    Component.onCompleted: if (modelData.floor == 1 || !threadPage.hasFloor)
                                               visible = false
                    Image {
                        y: 1
                        asynchronous: true;
                        source: "qrc:/gfx/pb_reply.png"
                    }
                    ListItemText {
                        platformInverted: listItem.platformInverted
                        text: modelData.sub_post_number||0
                        role: "SubTitle"
                    }
                }
            }
        }
    }
    Column {
        anchors { right: view.right; verticalCenter: view.verticalCenter }
        spacing: platformStyle.graphicSizeMedium
        Button {
            id: upBtn
            opacity: enabled ? 0.2 : 0.1
            rotation: -90
            enabled: !view.atYBeginning
            platformInverted: tbsettings.whiteTheme
            iconSource: privateStyle.toolBarIconPath("toolbar-next", platformInverted)
            onPlatformPressAndHold: view.positionViewAtBeginning()
            onClicked: SequentialAnimation {
                NumberAnimation { target: view; property: "contentY"; duration: 200; to: view.contentY - view.height }
                ScriptAction { script: if (view.atYBeginning) view.positionViewAtBeginning() }
            }
        }
        Button {
            id: downBtn
            opacity: enabled ? 0.2 : 0.1
            rotation: 90
            enabled: !view.atYEnd
            platformInverted: tbsettings.whiteTheme
            iconSource: privateStyle.toolBarIconPath("toolbar-next", platformInverted)
            onPlatformPressAndHold: view.positionViewAtEnd()
            onClicked: SequentialAnimation {
                NumberAnimation { target: view; property: "contentY"; duration: 200; to: view.contentY + view.height }
                ScriptAction { script: if (view.atYEnd) view.positionViewAtEnd() }
            }
        }
    }

    Loader {
        id: replyLoader
        anchors.bottom: parent.bottom
        width: parent.width
        height: 0
    }

    states: [
        State {
            name: "replyAreaOpened"
            PropertyChanges {
                target: replyLoader
                height: Math.max(100, threadPage.height/2)
            }
        }
    ]
    transitions: [
        Transition {
            to: "replyAreaOpened"
            SequentialAnimation {
                ScriptAction { script: { replyLoader.source = "Component/ReplyArea.qml"; view.atYEndCache = view.atYEnd } }
                NumberAnimation { target: replyLoader; property: "height"; duration: 200 }
                ScriptAction { script: if (view.atYEndCache) view.positionViewAtEnd() }
            }
        },
        Transition {
            to: ""
            SequentialAnimation {
                ScriptAction { script: view.atYEndCache = view.atYEnd; }
                NumberAnimation { target: replyLoader; property: "height"; duration: 200 }
                ScriptAction { script: { if (view.atYEndCache) view.positionViewAtEnd(); replyLoader.source = "" } }
            }
        }
    ]
}
