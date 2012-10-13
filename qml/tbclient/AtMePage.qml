import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

Page {
    id: atMePage

    property bool loading: false

    property int pageNumber: 1
    property bool firstStart: true

    function setComp(flag){
        if (!flag)
            atMeLoader.sourceComponent = undefined
        else if (flag && atMeLoader.status == Loader.Null)
            atMeLoader.sourceComponent = atMeComp
    }
    onVisibleChanged: {
        setComp(visible)
        if (visible){
            atMeLoader.forceActiveFocus()
            if (firstStart){
                firstStart = false
                try {
                    Script.loadAtMeList(utility.getCache("atMeList"), [true, atMeModel], true)
                } catch(e){
                    getlist(true)
                }
            }
        }
    }
    function getlist(isRenew){
        if (isRenew) pageNumber = 1
        else pageNumber ++
        Script.getAtMeList(pageNumber, isRenew, atMeModel)
    }

    Connections {
        target: signalCenter
        onGetAtListStarted: loading = true
        onGetAtListFailed: {
            loading = false
            app.showMessage(errorString)
        }
        onGetAtListSuccessed: {
            loading = false
            pageNumber = page.current_page
            if (!cached)
                utility.setCache("atMeList", result)
        }
        onCurrentUserChanged: firstStart = true
    }
    ListModel { id: atMeModel }
    Label {
        anchors.centerIn: parent
        text: loading ? "正在加载数据..." : "无结果"
        visible: atMeLoader.status == Loader.Ready && atMeLoader.item.count == 0
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
        font.pixelSize: platformStyle.graphicSizeSmall
    }
    Loader {
        id: atMeLoader
        anchors.fill: parent
    }
    Component {
        id: atMeComp
        ListView {
            id: atMeView
            clip: true
            cacheBuffer: height
            model: atMeModel
            header: myHeader
            delegate: myDelComp
            focus: true
            Component {
                id: myHeader
                PullToActivate {
                    myView: atMeView
                    onRefresh: getlist(true)
                }
            }
            Component {
                id: myDelComp
                ListItem {
                    id: listItem
                    implicitHeight: delCol.height + platformStyle.paddingLarge*2
                    platformInverted: tbsettings.whiteTheme
                    onClicked: {
                        var itemMenu = Qt.createComponent("Dialog/EnterThreadMenu.qml").createObject(atMePage)
                        itemMenu.threadId = thread_id; itemMenu.postId = post_id; itemMenu.isFloor = is_floor == 1
                        itemMenu.open()
                    }
                    Image {
                        id: avatarImage
                        x: platformStyle.paddingLarge
                        y: platformStyle.paddingLarge
                        sourceSize.height: platformStyle.graphicSizeMedium
                        Component.onCompleted: if (tbsettings.showAvatar)
                                                   source = "http://tb.himg.baidu.com/sys/portraitn/item/"+replyer.portrait
                    }
                    Column {
                        id: delCol
                        anchors {
                            left: avatarImage.right; leftMargin: platformStyle.paddingMedium
                            top: parent.paddingItem.top; right: parent.paddingItem.right
                        }
                        spacing: platformStyle.paddingMedium
                        ListItemText {
                            platformInverted: listItem.platformInverted
                            text: replyer.name_show
                            role: "SubTitle"
                        }
                        Label {
                            text: content
                            width: parent.width
                            wrapMode: Text.Wrap
                            platformInverted: listItem.platformInverted
                        }
                        ListItemText {
                            anchors.right: parent.right
                            platformInverted: listItem.platformInverted
                            role: "SubTitle"
                            Component.onCompleted: text = Script.formatDateTime(model.time*1000)
                        }
                    }
                }
            }
        }
    }
}
