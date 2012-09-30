import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

Page {
    id: replyToMe

    property int pageNumber: 1
    property bool firstStart: true
    property bool loading: false

    function setComp(flag){
        if (!flag)
            replyLoader.sourceComponent = undefined
        else if (flag && replyLoader.status == Loader.Null)
            replyLoader.sourceComponent = replyComp
    }
    onVisibleChanged: {
        setComp(visible)
        if (visible){
            replyLoader.forceActiveFocus()
            if (firstStart){
                firstStart = false
                try {
                    Script.loadReplyToMeResult(utility.getCache("replyToMeList"),[true, replyModel], true)
                } catch (e){
                    getlist(true)
                }
            }
        }
    }

    function getlist(isRenew){
        if (isRenew) pageNumber = 1
        else pageNumber ++
        Script.getReplyList(pageNumber, isRenew, replyModel)
    }

    Connections {
        target: signalCenter
        onGetReplyListStarted: loading = true
        onGetReplyListFailed: {
            loading = false
            app.showMessage(errorString)
        }
        onGetReplyListSuccessed: {
            pageNumber = page.current_page
            if (!cached)
                utility.setCache("replyToMeList", result)
        }
        onCurrentUserChanged: firstStart = true
    }
    ListModel { id: replyModel }
    Loader {
        id: replyLoader
        anchors.fill: parent
    }
    Component {
        id: replyComp
        ListView {
            id: replyView
            clip: true
            cacheBuffer: height
            model: replyModel
            delegate: replyDelegate
            header: headerComp
            focus: true
            Component {
                id: headerComp
                PullToActivate {
                    myView: replyView
                    onRefresh: getlist(true)
                }
            }
            Component {
                id: replyDelegate
                ListItemT {
                    id: listItem
                    platformInverted: tbsettings.whiteTheme
                    implicitHeight: contCol.height + platformStyle.paddingLarge*2
                    onClicked: {    
                        var itemMenu = Qt.createComponent("Dialog/EnterThreadMenu.qml").createObject(replyToMe)
                        itemMenu.threadId = thread_id; itemMenu.postId = post_id; itemMenu.isFloor = is_floor == 1
                        itemMenu.open()
                    }
                    ListItemText {
                        platformInverted: listItem.platformInverted
                        anchors {
                            right: parent.paddingItem.right
                            bottom: parent.paddingItem.bottom
                        }
                        width: listItem.paddingItem.width*0.7
                        text: fname+"吧"
                        horizontalAlignment: Text.AlignRight
                        role: "SubTitle"
                    }
                    Column {
                        id: contCol
                        x: platformStyle.paddingLarge; y: platformStyle.paddingLarge
                        width: parent.paddingItem.width
                        spacing: platformStyle.paddingMedium
                        Row {
                            spacing: platformStyle.paddingMedium
                            width: parent.width
                            Image {
                                visible: source != ""
                                sourceSize.height: platformStyle.graphicSizeMedium
                                Component.onCompleted: if (tbsettings.showAvatar)
                                                           source = "http://tb.himg.baidu.com/sys/portraitn/item/"+replyer.portrait
                            }
                            ListItemText {
                                role: "SubTitle"
                                platformInverted: listItem.platformInverted
                                Component.onCompleted: {
                                    var r = ""
                                    switch (model.type){
                                    case 1: r = "帖子："+quote_content; break;
                                    case 2: r = "主题："+model.title; break;
                                    default: r = type; break
                                    }
                                    text  = replyer.name_show + "\n" + r
                                }
                            }
                        }
                        BorderImage {
                            width: parent.width
                            height: contStr.height + platformStyle.paddingLarge*2
                            source: "qrc:/gfx/popup.9.png"
                            border {
                                left: 30; right: 17
                                top: 15; bottom: 7
                            }
                            Label {
                                id: contStr
                                x: platformStyle.paddingLarge
                                y: platformStyle.paddingLarge
                                width: parent.width - platformStyle.paddingLarge*2
                                text: content
                                font.weight: Font.Light
                                wrapMode: Text.Wrap
                                platformInverted: true
                            }
                        }
                        ListItemText {
                            role: "SubTitle"
                            platformInverted: listItem.platformInverted
                            Component.onCompleted: text = Script.formatDateTime(model.time*1000)
                        }
                    }
                }
            }
        }
    }
}
