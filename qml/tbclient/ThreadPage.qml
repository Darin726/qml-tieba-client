import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

Page {
    id: threadPage

    property string threadId

    property variant forum: ({})
    property variant thread: ({})
    property alias listModel: threadModel
    property alias threadView: view
//    property variant imageList: []

    property bool hasFloor
    property bool isLz: false
    property bool hasMore: false
    property bool hasPrev: false
    property bool isReverse: false

    property bool loading: false

    function loadMore(){
        if (threadModel.count > 0)
            Script.getThreadList(threadPage, threadModel.get(threadModel.count-1).data.id, false)
    }
    function loadPrev(){
        if (threadModel.count > 0)
            Script.getThreadList(threadPage, threadModel.get(0).data.id, true)
    }
    function reverseList(){
        isReverse = !isReverse
        isLz = false
        Script.getThreadList(threadPage, undefined, false, true, undefined, undefined, true)
    }
    function changeLz(){
        isLz = !isLz
        isReverse = false
        Script.getThreadList(threadPage, undefined, undefined, undefined, undefined, undefined, true)
    }
    function postReply(){
        replyLoader.item.postReply()
    }
    function ding(){
        Script.ding(threadPage.toString(), forum, threadId)
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
        onLoadFailed: loading = false;
    }

    ListModel { id: threadModel }
    ListView {
        id: view
        property bool atYEndCache
        anchors { fill: parent; bottomMargin: replyLoader.height }
        clip: true
        cacheBuffer: height
        focus: true
        model: threadModel
        delegate: ListItemT {
            id: listItem
            implicitHeight: contentCol.height + platformStyle.paddingLarge
            platformInverted: tbsettings.whiteTheme
            onClicked: {
                if (threadPage.hasFloor && modelData.floor!=1)
                    app.enterSubfloor(threadId, modelData.id, undefined, isLz)
                else
                    pressAndHold()
            }
            onPressAndHold: {
                itemMenu.currentIndex = index
                itemMenu.open()
            }
            ListItemText {
                anchors.right: parent.right
                text: modelData.floor+"#"
                role: "SubTitle"
                platformInverted: parent.platformInverted
            }
            Row {
                anchors {
                    left: listItem.paddingItem.left; bottom: listItem.paddingItem.bottom
                }
                Component.onCompleted: if (modelData.floor == 1 || !threadPage.hasFloor)
                                           visible = false
                Image {
                    y: 1
                    source: "qrc:/gfx/pb_reply.png"
                }
                ListItemText {
                    platformInverted: listItem.platformInverted
                    text: modelData.sub_post_number||0
                    role: "SubTitle"
                }
            }
            Column {
                id: contentCol
                width: parent.width
                spacing: platformStyle.paddingMedium
                Row {
                    height: platformStyle.graphicSizeMedium
                    spacing: platformStyle.paddingMedium
                    Image {
                        sourceSize.height: platformStyle.graphicSizeMedium
                        Component.onCompleted: if (tbsettings.showAvatar && modelData.author.type != 0)
                                                   source = "http://tb.himg.baidu.com/sys/portraitn/item/"+modelData.author.portrait
                    }
                    ListItemText {
                        anchors.verticalCenter: parent.verticalCenter
                        platformInverted: listItem.platformInverted
                        role: "SubTitle"
                        Component.onCompleted: {
                            var a = modelData.author
                            text = a.name_show + (a.is_like==1?"\nLv."+a.level_id:"")
                        }
                    }
                }
                Repeater {
                    model: modelData.contentData
                    Loader {
                        anchors {
                            left: parent.left; right: parent.right; margins: platformStyle.paddingLarge
                        }
                        Component.onCompleted: {
                            if (modelData[0])
                                sourceComponent = delegateLabel
                            else
                                source = "Component/DelegateImage.qml"
                        }
                        Component {
                            id: delegateLabel
                            Label {
                                wrapMode: Text.Wrap
                                platformInverted: listItem.platformInverted
                                font.pixelSize: tbsettings.fontSize
                                onLinkActivated: signalCenter.linkActivated(link)
                                Component.onCompleted: {
                                    if (modelData[2]){
                                        text = modelData[1].replace(/\n/g,"<br/>")
                                        textFormat = Text.RichText
                                    } else {
                                        text = modelData[1]
                                        textFormat = Text.PlainText
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
        }
        header: Item {
            width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0
            visible: (threadPage.isReverse || threadPage.hasPrev) && view.count>0
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !threadPage.loading
                text: threadPage.loading ? "加载中..." : threadPage.hasPrev ? "加载更多" : "已无更多，点击继续加载"
                onClicked: loadPrev()
            }
        }

        footer: Item {
            width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0
            visible: (!threadPage.isReverse || threadPage.hasMore) && view.count>0
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !threadPage.loading
                text: threadPage.loading?"加载中...":threadPage.hasMore?"加载更多":"已无更多，点击继续加载"
                onClicked: loadMore()
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

    ContextMenu {
        id: itemMenu
        property int currentIndex
        MenuLayout {
            MenuItem {
                text: "添加到书签"
                onClicked: {
                    app.addBookmark(threadId, threadModel.get(itemMenu.currentIndex).data.id, thread.author.name_show, thread.title, isLz)
                }
            }
            MenuItem {
                text: "回复"
                onClicked: {
                    threadPage.state = "replyAreaOpened"
                    replyLoader.item.floorNum = threadModel.get(itemMenu.currentIndex).data.floor
                    replyLoader.item.quoteId = threadModel.get(itemMenu.currentIndex).data.id
                }
            }
            MenuItem {
                text: "阅读模式"
                onClicked: app.pageStack.push(Qt.resolvedUrl("Reader.qml")
                                              ,{ currentIndex: itemMenu.currentIndex, myView: threadView})
            }
            MenuItem {
                text: "复制内容"
                onClicked: app.pageStack.push(Qt.resolvedUrl("Component/CopyPage.qml"),
                                              { sourceObject: threadModel.get(itemMenu.currentIndex).data.content })
            }
            MenuItem {
                text: "查看用户资料"
                onClicked: {
                    var a = threadModel.get(itemMenu.currentIndex).data.author
                    if (a.type == 0)
                        app.showMessage("匿名用户")
                    else
                        app.enterProfilePage(a.id)
                }
            }
        }
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
