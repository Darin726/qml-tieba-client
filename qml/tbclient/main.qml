import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import HttpUp 1.0
import "js/main.js" as Script
import "js/storage.js" as Database
import "js/linkDecoder.js" as Helper

PageStackWindow {
    id: app

    property alias title: titleText.text
    property bool loading

    platformInverted: tbsettings.whiteTheme
    platformSoftwareInputPanelEnabled: tbsettings.splitScreenInput

    Row {
        visible: showStatusBar
        BusyIndicator {
            visible: app.loading
            running: true
            height: privateStyle.statusBarHeight
            width: height
        }
        Flickable {
            id: titleFlicy
            clip: true
            interactive: false
            height: privateStyle.statusBarHeight
            width: parent.parent.width - 200

            contentWidth: Math.max(titleText.width,width)
            contentHeight: platformStyle.fontSizeSmall
            contentItem.anchors.verticalCenter: verticalCenter

            Label {
                id: titleText
                font.pixelSize: platformStyle.fontSizeSmall
                textFormat: Text.PlainText
                onTextChanged: {
                    titleAnimation.stop()
                    titleFlicy.contentX = 0
                    if (titleFlicy.contentWidth>titleFlicy.width)
                        titleAnimation.start()
                }
            }
            SequentialAnimation {
                id: titleAnimation
                running: Qt.application.active
                ScriptAction { script: titleFlicy.contentX = 0; }
                NumberAnimation { duration: 1000 }
                PropertyAnimation {
                    target: titleFlicy;
                    property: "contentX";
                    to: titleFlicy.contentWidth - titleFlicy.width;
                    duration: ( titleFlicy.contentWidth - titleFlicy.width )*30
                    onToChanged: {
                        if (to<=0) {
                            titleAnimation.stop()
                            titleFlicy.contentX = 0
                        } else {
                            titleAnimation.restart()
                        }
                    }
                }
                NumberAnimation { duration: 1000 }
                PropertyAnimation { target: titleFlicy; property: "contentX"; to: 0}
            }
        }
    }

    PinchArea {
        z: -1;
        anchors.fill: parent
        visible: platformPopupManager.popupStackDepth == 0
        onPinchFinished: {
            var delta1 = pinch.point1.x - pinch.startPoint1.x
            var delta2 = pinch.point2.x - pinch.startPoint2.x
            if (Math.abs(pinch.point2.y-pinch.startPoint2.y)<200 && Math.abs(pinch.point1.y - pinch.startPoint1.y)<200){
                if ( Math.max(delta1, delta2) < -50 ) signalCenter.swipeLeft()
                else if ( Math.min(delta1, delta2)>50 ) signalCenter.swipeRight()
            }
        }
    }

    SignalCenter { id: signalCenter }
    InfoBanner { id: infoBanner; platformInverted: tbsettings.whiteTheme }
    AutoCheck { id: autoCheck }

    Image {
        parent: pageStack; width: screen.width; height: screen.height
        sourceSize.height: 640; fillMode: Image.PreserveAspectCrop
        source: tbsettings.backgroundImage
        visible: source != ""
        smooth: true
        asynchronous: true
        opacity: tbsettings.whiteTheme ? 0.7 : 0.5
    }

    HttpUploader {
        id: uploader
        property string currentCaller
        onUploadStateChanged: {
            if (uploadState == HttpUploader.Opened){
                signalCenter.uploadStarted()
            } else if (uploadState == HttpUploader.Done){
                if (status!= 200 && status!=0){
                    signalCenter.uploadFailed(errorString)
                } else {
                    var obj = JSON.parse(responseText)
                    if (obj.error_code!=0)
                        signalCenter.uploadFailed(obj.error_msg)
                    else
                        signalCenter.uploadFinished(uploader.currentCaller, obj.info)
                }
            }
        }
    }

    Connections {
        target: signalCenter
        onPostImage: {
            if (uploader.uploadState == HttpUploader.Loading){
                Qt.createComponent("Dialog/AbortUploadDialog.qml").createObject(app).open()
                return
            }
            uploader.clear()
            uploader.currentCaller = caller
            uploader.open(tbsettings.host +"/c/c/img/upload")
            uploader.addField("BDUSS", Script.BDUSS)
            uploader.addField("_client_type", tbsettings.clientType)
            uploader.addField("_phone_imei", tbsettings.imei)
            uploader.addField("from", tbsettings.from)
            uploader.addField("net_type", tbsettings.netType)
            uploader.addField("pic_type", 0)
            uploader.addFile("pic", url)
            uploader.send()
        }
        onLoadStarted: {
            app.loading = true
            processTimer.restart()
        }
        onLoadFinished: {
            app.loading = false
            processTimer.stop()
        }
        onLoadFailed: {
            app.loading = false
            processTimer.stop()
            app.showMessage(errorString)
        }
        onNeedVCode: {
            var s = Qt.createComponent(Qt.resolvedUrl("Dialog/VCodeInput.qml")).createObject(app)
            s.picurl = picurl; s.vcodeMd5 = vcodeMd5; s.caller = caller
            s.open();
        }
        onLinkActivated: Helper.linkActivated(link)
    }
    Timer {
        id: processTimer
        interval: 30000
        onTriggered: signalCenter.loadFailed("联网超时> <")
    }

    MyBarPage { id: myBarPage }
    MessagePage { id: messagePage }
    ThreadGroupPage { id: threadGroupPage }
    ProfilePage {
        id: profilePage
        property bool firstStart: true
        tools: homeTools
        onUserChanged: {
            if (user.portrait){
                firstStart = false
                utility.setCache("myProfile", JSON.stringify(user))
            }
        }
        onVisibleChanged: {
            if (visible){
                profilePage.forceActiveFocus()
                if (firstStart){
                    firstStart = false
                    try {
                        user = JSON.parse(utility.getCache("myProfile"))
                    } catch(e){
                        Script.getProfile(profilePage)
                    }
                }
            }
        }
        Keys.onLeftPressed: enterMessagePage()
        Connections {
            target: signalCenter
            onSwipeRight: {
                if (profilePage.status == PageStatus.Active)
                    enterMessagePage()
            }
            onCurrentUserChanged: {
                profilePage.userId = Script.userId
                profilePage.firstStart = true
            }
        }
    }
    HotPointPage { id: hotPointPage }
    Connections {
        target: pageStack.toolBar
        onToolsChanged: {
            for (var i=0, l=pageStack.toolBar.tools.children.length; i<l; i++){
                pageStack.toolBar.tools.children[i].platformInverted = tbsettings.whiteTheme
            }
        }
    }
    ToolBarLayout {
        id: homeTools
        ToolButton {
            iconSource: app.pageStack.depth <= 1 ? "qrc:/gfx/tb_close_stop%1.svg".arg(platformInverted?"_inverted":"") : "toolbar-back"
            onClicked: {
                if (app.pageStack.depth <= 1){
                    Qt.createComponent("Dialog/QuitDialog.qml").createObject(app).open()
                } else {
                    pageStack.pop()
                }
            }
        }
        ToolButton {
            iconSource: "toolbar-home"
            onClicked: {
                if (pageStack.currentPage == myBarPage)
                    pageStack.push(hotPointPage)
                else
                    pageStack.pop(myBarPage)
            }
        }
        ToolButton {
            iconSource: "qrc:/gfx/messaging%1.svg".arg(platformInverted?"_inverted":"")
            onClicked: enterMessagePage()
        }
        ToolButton {
            iconSource: "qrc:/gfx/contacts%1.svg".arg(platformInverted?"_inverted":"")
            onClicked: enterProfilePage(Script.userId)
        }
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
            }
        }

    }

    function showMessage(msg){
        if (msg||false){
            infoBanner.text = msg
            infoBanner.open()
        }
    }
    function multiThread(func){
        var timer = Qt.createQmlObject('import QtQuick 1.0; Timer{interval:10}',app)
        timer.triggered.connect(function(){try{func()}catch(e){}; timer.destroy()})
        timer.start()
    }

    function enterMessagePage(tab){
        if (pageStack.currentPage != messagePage)
            pageStack.push(messagePage)
        if (tab)
            messagePage.currentTab = tab
    }

    function enterForum(forumName){
        pageStack.push(Qt.resolvedUrl("ForumPage.qml"),{ forumName: forumName }).internal.getList()
    }

    function enterThread(threadId, threadName, postId, isMark, isLz){
        var opt = {pid: postId||0, mark: isMark||0, lz: isLz=="true"?1:0, jumpable: postId?false:true}
        threadGroupPage.internal.addThreadPage(threadId, threadName, opt)
        if (pageStack.currentPage != threadGroupPage)
            pageStack.push(threadGroupPage)
    }

    function enterSubfloor(threadId, postId, subpostId, isLz, manageGroup){
        var page = pageStack.push(Qt.resolvedUrl("SubfloorPage.qml"),
                                  { threadId: threadId,
                                      postId: postId||0,
                                      subpostId: subpostId||0,
                                      isLz: isLz||false,
                                      manageGroup: manageGroup||0})
        page.getlist(true);
    }

    function enterProfilePage(userId){
        if (userId == Script.userId){
            if (pageStack.currentPage != profilePage)
                pageStack.push(profilePage)
        } else {
            Script.getProfile(pageStack.push(Qt.resolvedUrl("ProfilePage.qml"),{userId: userId}))
        }
    }
    function addBookmark(threadId, postId, author, title, isLz){
        try {
            if (Database.saveBookMark(threadId, postId, author, title, isLz))
                showMessage("书签保存成功")
            else
                showMessage("保存出错> <")
        } catch(e){
            showMessage(JSON.stringify(e))
        }
    }
    Component.onCompleted: {
        Script.signalCenter = signalCenter
        Script.tbsettings = tbsettings
        Database.initialize()
        var u = Database.getUserInfo(tbsettings.defaultId)
        if (u.length > 0){
            Script.userId = u[0].userId; Script.userName = u[0].userName; Script.BDUSS = u[0].BDUSS
            signalCenter.currentUserChanged()
            pageStack.push(myBarPage)
        } else {
            pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
        }
    }
}
