import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: forumPage

    property string forumName
    property bool loading

    property variant page: ({})
    property variant forum: ({})
    property bool isGood
    property int pageNumber: 1
    onIsGoodChanged: pageNumber = 1
    onPageNumberChanged: {
        if (pageNumber > page.total_page) pageNumber = page.total_page
        else if (pageNumber < 1) pageNumber = 1
    }
    property alias internal: internal

    title: (forum.name || forumName)+"吧"

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "toolbar-refresh"
            RotationAnimation on rotation {
                running: loading
                loops: Animation.Infinite
                from: 360; to: 0
                duration: 500
            }
            onClicked: internal.getList()
        }
        ToolButton {
            iconSource: platformInverted ? "qrc:/gfx/switch_windows_inverted.svg"
                                         : "qrc:/gfx/switch_windows.svg"
            onClicked: pageStack.push(threadGroupPage)
        }
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: forumMenu.open()
        }
    }
    Keys.onPressed: {
        switch (event.key){
        case Qt.Key_Backspace:
            pageStack.pop();
            event.accepted = true;
            break;
        }
    }

    Connections {
        target: signalCenter
        onLoadForumStarted:  {
            if (caller == forumPage.toString())
                loading = true
        }
        onLoadForumSuccessed: {
            if (caller == forumPage.toString()){
                loading = false
                if (!forumPage.forum.name) app.showMessage(forbidInfo)
                forumPage.forum = forum; forumPage.page = page;
            }
        }
        onLoadForumFailed: {
            if (caller == forumPage.toString()){
                loading = false
                app.showMessage(errorString)
            }
        }
        onSignInFailed: {
            if (caller == forumPage.toString()){
                app.showMessage(errorString)
            }
        }
        onSignInSuccessed: {
            if (caller == forumPage.toString()){
                app.showMessage("签到成功！您今天第"+info.user_sign_rank+"个签到")
            }
        }

        onLikeForumFailed: {
            if (caller == forumPage.toString()){
                app.showMessage(errorString)
            }
        }
        onLikeForumSuccessed: {
            if (caller == forumPage.toString()){
                app.showMessage("成功")
            }
        }
        onSwipeLeft: {
            if (forumPage.status == PageStatus.Active){
                pageStack.push(threadGroupPage)
            }
        }
        onSwipeRight: {
            if (forumPage.status == PageStatus.Active){
                pageStack.pop()
            }
        }
        onLoadFailed: loading = false;
    }
    Label {
        anchors.centerIn: parent
        text: loading ? "正在加载列表..." : "暂无贴子"
        visible: view.count == 0
        font.pixelSize: platformStyle.graphicSizeSmall
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                     : platformStyle.colorDisabledMid
    }

    QtObject {
        id: internal
        function getClassNameByClassId(){
            var id = page.cur_good_id
            for (var i in forum.good_classify){
                var a = forum.good_classify[i]
                if (a.class_id == id)
                    return a.class_name
            }
            return "精品区"
        }
        function getList(clsId){
            Script.getArticleList(forumPage.toString(), forumModel, goodModel, pageNumber, clsId||page.cur_good_id, isGood, forum.name||forumName)
        }
        function prevPage(){
            pageNumber --
            getList()
        }
        function nextPage(){
            pageNumber ++
            getList()
        }
    }

    ListModel { id: forumModel }
    ListModel { id: goodModel }

    Menu {
        id: forumMenu
        MenuLayout {
            MenuItem {
                text: "设置中心"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
            }
            MenuItem {
                text: "跳页"
                visible: forum.name != undefined
                onClicked: {
                    var diag = Qt.createComponent("Dialog/PageJumper.qml").createObject(forumPage);
                    diag.totalPage = page.total_page
                    diag.currentValue = pageNumber;
                    diag.pageJumped.connect(function(){ forumPage.pageNumber = diag.currentValue; internal.getList() })
                    diag.open()
                }
            }
            MenuItem {
                text: "其它"
                visible: forum.name != undefined
                ButtonRow {
                    exclusive: false
                    anchors {
                        verticalCenter: parent.verticalCenter; right: parent.right;
                        rightMargin: platformStyle.paddingLarge
                    }
                    ToolButton {
                        iconSource: "qrc:/gfx/calendar_week.svg"
                        visible: forum.sign_in_info == undefined || forum.sign_in_info.forum_info.is_on == 1
                        onClicked: {
                            forumMenu.close()
                            var i = forum.sign_in_info.user_info
                            if (i.is_sign_in == 0){
                                Script.signIn(forumPage)
                            } else {
                                app.showMessage("您今天第"+i.user_sign_rank+"个签到，已经连续签到"+i.cont_sign_num+"天，累计签到"+i.cout_total_sing_num+"天，记得明天要来哦~")
                            }
                        }
                    }
                    ToolButton {
                        iconSource: privateStyle.imagePath(forum.is_like==1?"qtg_graf_rating_rated":"qtg_graf_rating_unrated")
                        onClicked: {
                            forumMenu.close()
                            if (forum.is_like == 1){
                                var diag = Qt.createComponent("Dialog/UnlikeForumCheck.qml").createObject(forumPage)
                                diag.open()
                                diag.accepted.connect(function(){Script.likeForum(forumPage, false)})
                            } else {
                                Script.likeForum(forumPage, true)
                            }
                        }
                    }
                    ToolButton {
                        iconSource: "qrc:/gfx/edit.svg"
                        onClicked: {
                            forumMenu.close()
                            pageStack.push(Qt.resolvedUrl("PostPage.qml"),{ forumPage: forumPage})
                        }
                    }
                }
            }
        }
    }

    ViewHeader {
        id: viewHeader
        headerText: forumPage.isGood ? internal.getClassNameByClassId() : (forum.name||forumName)+"吧"
        MouseArea {
            id: viewHeaderMA
            anchors.fill: parent
            enabled: forum.name != undefined
            onClicked: {
                if (forum.good_classify.length == 0){
                    isGood = !isGood
                    internal.getList()
                } else {
                    var diag = Qt.createComponent("Dialog/GoodSelector.qml").createObject(forumPage)
                    diag.model = goodModel; diag.open()
                }
            }
        }
        Image {
            anchors {
                right: parent.right; rightMargin: platformStyle.paddingSmall; verticalCenter: parent.verticalCenter
            }
            source: privateStyle.imagePath("qtg_graf_choice_list_indicator", tbsettings.whiteTheme)
            visible: viewHeaderMA.enabled;
        }
        Rectangle {
            anchors.fill: parent
            color: "#80000000"
            visible: viewHeaderMA.pressed
        }
    }
    ListView {
        id: view
        anchors {
            fill: parent; topMargin: viewHeader.height
        }
        clip: true
        cacheBuffer: height
        model: forumModel
        onVisibleChanged: forceActiveFocus()
        highlightMoveDuration: 400
        header: PullToActivate {
            myView: view
            pullDownMessage: page.has_prev == 1 ? "下拉返回上一页" : "下拉可以刷新"
            onRefresh: page.has_prev == 1 ? internal.prevPage() : internal.getList()
        }
        footer: Item {
            width: screen.width; height: platformStyle.graphicSizeLarge
            visible: forum.name ? true : false
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                enabled: !loading && page.has_more == 1
                text: loading ? "加载中..." : page.has_more==1 ? "下一页" : "已到最后"
                onClicked: internal.nextPage()
            }
        }
        delegate: ListItemF {
            id: listItem
            implicitHeight: contentCol.height + platformStyle.paddingLarge*2
            platformInverted: tbsettings.whiteTheme
            onClicked: {
                app.enterThread(modelData.id, modelData.title)
            }
            Column {
                id: contentCol
                anchors {
                    left: listItem.paddingItem.left; right: listItem.paddingItem.right;
                    top: listItem.paddingItem.top
                }
                spacing: platformStyle.paddingSmall
                ListItemText {
                    text: modelData.author.name_show
                    role: "SubTitle"
                    platformInverted: listItem.platformInverted
                }
                Label {
                    width: parent.width
                    text: modelData.title
                    platformInverted: listItem.platformInverted
                    font.pixelSize: tbsettings.fontSize
                    wrapMode: Text.Wrap
                    textFormat: Text.PlainText
                }
                ListItemText {
                    width: parent.width;
                    platformInverted: listItem.platformInverted
                    role: "SubTitle"
                    visible: tbsettings.showAbstract && modelData.abstract.length > 0
                    font.pixelSize: platformStyle.fontSizeMedium
                    text: visible ? modelData.abstract[0].text : ""
                }
                Loader {
                    Component.onCompleted: {
                        if (tbsettings.showAbstract && tbsettings.showImage && modelData.pic.length>0)
                            source = "Component/AbstractImage.qml"
                    }
                }
                ListItemText {
                    text: modelData.reply_num+"/"+modelData.view_num+"  "+modelData.last_replyer.name_show
                    role: "SubTitle"
                    platformInverted: listItem.platformInverted
                }
            }
            Row {
                anchors {
                    right: listItem.paddingItem.right; top: listItem.paddingItem.top
                }
                Image {
                    visible: modelData.is_top == 1
                    source: visible ? "qrc:/gfx/frs_post_top.png" : ""
                    asynchronous: true;
                }
                Image {
                    visible: modelData.is_good == 1
                    source: visible ? "qrc:/gfx/frs_post_good.png" : ""
                    asynchronous: true
                }
                Image {
                    visible: modelData.comment_num > 0
                    source: visible ? "qrc:/gfx/frs_post_ding.png" : ""
                    asynchronous: true
                }
                Label {
                    visible: modelData.comment_num > 0
                    text: visible ? modelData.comment_num : ""
                    color: listItem.platformInverted ? "blue" : "yellow"
                }
            }
            ListItemText {
                anchors {
                    right: parent.paddingItem.right; bottom: parent.paddingItem.bottom
                }
                role: "SubTitle"
                platformInverted: listItem.platformInverted
                text: Script.formatDateTime(modelData.last_time_int*1000)
            }
        }
    }
}
