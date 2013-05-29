import QtQuick 1.0
import com.nokia.symbian 1.0
import com.nokia.extras 1.0
import LocationAPI 1.0
import HttpUp 1.0
import "Component"
import "../js/main.js" as Script
import "../js/storage.js" as Database
import "../js/const.js" as Const
import "../js/linkDecoder.js" as Link

PageStackWindow {
    id: app

    property alias title: titleText.text;

    property QtObject threadPage: null;
    property QtObject messagePage: null;
    property QtObject userPage: null;
    property QtObject morePage: null;
    property QtObject recomPage: null;
    property QtObject signPage: null;

    initialPage: HomePage { id: homePage; }

    // Status Pane;
    Row {
        opacity: app.showStatusBar ? 1 : 0;
        anchors { left: parent.left; top: parent.top; }
        BusyIndicator {
            id: busyIndicator;
            width: privateStyle.statusBarHeight;
            height: privateStyle.statusBarHeight;
            running: true;
            visible: false;
        }
        Flickable {
            id: scrollingTitle;
            clip: true;
            interactive: false;
            height: privateStyle.statusBarHeight;
            width: screen.width - 200;

            contentWidth: Math.max(titleText.width, width);
            contentHeight: privateStyle.statusBarHeight;

            onWidthChanged: resetAnimation();

            function resetAnimation(){
                scrollingAnimation.complete();
                if (titleText.width > scrollingTitle.width){
                    scrolling.to = titleText.width - scrollingTitle.width;
                    scrollingAnimation.start();
                }
            }

            Label {
                id: titleText;
                height: parent.height;
                verticalAlignment: Text.AlignVCenter;
                font.pixelSize: platformStyle.fontSizeSmall;
                textFormat: Text.PlainText;
                onTextChanged: scrollingTitle.resetAnimation();
            }

            SequentialAnimation {
                id: scrollingAnimation;
                PropertyAction { target: scrollingTitle; property: "contentX"; value: 0; }
                PauseAnimation { duration: 1000; }
                PropertyAnimation {
                    id: scrolling;
                    target: scrollingTitle;
                    property: "contentX";
                    duration: to*30;
                }
                PauseAnimation { duration: 1000; }
                PropertyAnimation { target: scrollingTitle; property: "contentX"; to: 0; }
            }
        }
    }

    // Symbian Style
    SymbianStyle { id: symbianStyle; }

    // Signal Center;
    SignalCenter { id: signalCenter; }

    Connections {
        target: signalCenter;
        onNeedAuthorization: {
            var prop = { forceLogin: forceLogin };
            pageStack.push(Qt.resolvedUrl("LoginPage.qml"), prop);
        }
        onLoadStarted: processingTimer.restart();
        onLoadFinished: {
            signalCenter.hideBusyIndicator();
            processingTimer.stop();
        }
        onLoadFailed: {
            signalCenter.hideBusyIndicator();
            signalCenter.showMessage(errorString);
            processingTimer.stop();
        }
        onShowMessage: {
            if (message||false){
                infoBanner.text = message;
                infoBanner.open();
            }
        }
        onNeedVCode: {
            dialog.createVCodeInputDialog(caller, vcodePicUrl, vcodeMd5);
        }
        onShowBusyIndicator: {
            busyIndicator.visible = true;
        }
        onHideBusyIndicator: {
            busyIndicator.visible = false;
        }
        onLinkActivated: {
            Link.linkActivated(link);
        }
        onPostImage: {
            if (uploader.uploadState == HttpUploader.Loading){
                function abort(){
                    if (uploader.uploadState == HttpUploader.Loading){ uploader.abort(); }
                }
                dialog.createQueryDialog(qsTr("Confirm Operation"),
                                         qsTr("Another upload process is running, cancel it to create a new upload?"),
                                         qsTr("Yes"),
                                         qsTr("No"),
                                         abort);
                return;
            }
            uploader.caller = caller;
            uploader.open(Const.C_IMG_UPLOAD);
            uploader.addField("BDUSS", Script.BDUSS);
            uploader.addField("_client_id", tbsettings.clientId||"wappc_1362027349698_178");
            uploader.addField("_client_type", tbsettings.clientType);
            uploader.addField("_client_version", tbsettings.clientVersion);
            uploader.addField("_phone_imei", tbsettings.imei);
            uploader.addField("from", "baidu_appstore");
            uploader.addField("net_type", 1);
            uploader.addField("pic_type", 0);
            uploader.addFile("pic", url);
            uploader.send();
        }
        onCommitGood: {
            dialog.commitGood(catelist, param);
        }
    }

    Timer {
        id: processingTimer;
        interval: 30000;
        onTriggered: {
            signalCenter.loadFailed(qsTr("Network Time out > <"));
        }
    }

    // Message Reminder
    AutoCheck { id: autoCheck; }

    InfoBanner {
        id: infoBanner;
        iconSource: "gfx/tb_mini.svg";
    }

    ToolTip {
        id: toolTip;
        visible: false;
    }

    // List Parser
    WorkerScript { id: worker; source: "../js/listparser.js"; }

    // Image Uploader
    HttpUploader {
        id: uploader;
        property string caller: "";
        onUploadStateChanged: {
            if (uploadState == HttpUploader.Aborting){
                signalCenter.showMessage(qsTr("Operation Canceled"));
            } else if (uploadState == HttpUploader.Done){
                if (status != 200){
                    signalCenter.showMessage(errorString);
                } else {
                    try {
                        var obj = JSON.parse(responseText);
                        if (obj.error_code != 0){
                            signalCenter.showMessage(obj.error_msg);
                        } else {
                            signalCenter.uploadFinished(caller, obj.info);
                        }
                    } catch(e){
                        console.log(JSON.stringify(e));
                    }
                }
                uploader.clear();
            }
        }
    }

    // Location Caller
    PositionSource {
        id: positionSource;
    }

    // Image Downloader
    Connections {
        target: downloader;
        onStateChanged: {
            if (downloader.state == 1){
                downloadInfoBanner.open();
            }
            else if (downloader.state == 3){
                downloadInfoBanner.close();
                if (downloader.error == 0){
                    Qt.openUrlExternally("file:///"+downloader.currentFile);
                }
            }
        }
    }

    InfoBanner {
        id: downloadInfoBanner;
        iconSource: "gfx/tb_mini.svg";
        timeout: 0;
        interactive: true;
        text: qsTr("Downloading image: %1%(Click to cancel)").arg(Math.floor(downloader.progress*100));
        onClicked: downloader.abortDownload(false);
    }

    // Background Image
    Image {
        id: backgroundImage;
        parent: pageStack;
        width: screen.width; height: screen.height;
        sourceSize.height: 640;
        fillMode: Image.PreserveAspectCrop;
        source: tbsettings.backgroundImage;
        visible: tbsettings.backgroundImage.length > 0;
        asynchronous: true;
        opacity: 0.5;
    }

    ToolBarLayout {
        id: mainTools;

        function switchToPage(page){
            if (pageStack.currentPage != page){
                pageStack.push(page);
            }
        }

        ToolButtonWithTip {
            toolTipText: pageStack.depth <= 1 ? qsTr("Quit") : qsTr("Back");
            iconSource: pageStack.depth <= 1 ? "gfx/tb_close_stop.svg" : "toolbar-back";
            onClicked: {
                if (pageStack.depth <= 1){
                    dialog.createQueryDialog(qsTr("Confirm Operation"),
                                             qsTr("Do you want to close this applicaton?"),
                                             qsTr("Yes"),
                                             qsTr("No"),
                                             Qt.quit);
                } else {
                    pageStack.pop();
                }
            }
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Home");
            iconSource: "toolbar-home";
            onClicked: {
                if (pageStack.currentPage != homePage){
                    pageStack.pop(homePage);
                }
            }
        }
        ToolButtonWithTip {
            id: messageToolButton;
            toolTipText: qsTr("Message");
            iconSource: "gfx/messaging.svg";
            onClicked: {
                if (!messagePage){ messagePage = Qt.createComponent("MessagePage.qml").createObject(app) }
                mainTools.switchToPage(messagePage);
            }
            Bubble {
                anchors.verticalCenter: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: autoCheck.replyme + autoCheck.atme > 20 ? "20+" : autoCheck.replyme + autoCheck.atme;
                visible: autoCheck.replyme + autoCheck.atme > 0;
            }
        }
        ToolButtonWithTip {
            toolTipText: qsTr("User Center");
            iconSource: "gfx/contacts.svg";
            onClicked: {
                if (!userPage){
                    userPage = Qt.createComponent("UserPage.qml").createObject(app);
                    userPage.tools = mainTools;
                    userPage.uid = Script.uid;
                    userPage.title = qsTr("User Center");
                    try {
                        Script.loadUserProfile(utility.getCache("Profile"), {caller: userPage});
                    } catch(e){
                        userPage.getlist();
                    }
                    signalCenter.userChanged.connect(userPage.resetUser);
                }
                mainTools.switchToPage(userPage);
            }
            Bubble {
                anchors.verticalCenter: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: autoCheck.fans > 20 ? "20+" : autoCheck.fans;
                visible: autoCheck.fans > 0;
            }
        }
        ToolButtonWithTip {
            toolTipText: qsTr("More");
            iconSource: "gfx/toolbar_extension.svg";
            onClicked: {
                if (!morePage){ morePage = Qt.createComponent("MorePage.qml").createObject(app) }
                mainTools.switchToPage(morePage);
            }
        }
    }

    // Dynamic Dialog Creator
    QtObject {
        id: dialog;

        property Component __vcodeDialog: null;
        property Component __imageDialog: null;
        property Component __queryDialog: null;
        property Component __emotionDialog: null;
        property Component __threadManageDialog: null;
        property Component __goodlistDialog: null;
        property Component __threadMenu: null;
        property Component __commitPrisonDialog: null;
        property Component __floorMenu: null;

        function createVCodeInputDialog(caller, vcodePicUrl, vcodeMd5){
            if (!__vcodeDialog){ __vcodeDialog = Qt.createComponent("Dialog/VCodeDialog.qml"); }
            var diag = __vcodeDialog.createObject(pageStack.currentPage);
            diag.caller = caller;
            diag.vcodePicUrl = vcodePicUrl;
            diag.vcodeMd5 = vcodeMd5;
            diag.open();
        }
        function createImageSelectDialog(caller){
            if (!__imageDialog){ __imageDialog = Qt.createComponent("Dialog/ImageSelectDialog.qml"); }
            var diag = __imageDialog.createObject(pageStack.currentPage);
            diag.caller = caller;
            diag.open();
        }
        function createQueryDialog(title, message, acceptText, rejectText, acceptCallback, rejectCallback){
            if (!__queryDialog){ __queryDialog = Qt.createComponent("Dialog/DynamicQueryDialog.qml"); }
            var diag = __queryDialog.createObject(pageStack.currentPage);
            diag.titleText = title;
            diag.message = message.concat("\n");
            diag.acceptButtonText = acceptText;
            diag.rejectButtonText = rejectText;
            if (acceptCallback) diag.accepted.connect(acceptCallback);
            if (rejectCallback) diag.rejected.connect(rejectCallback);
            diag.open();
        }
        function selectEmotion(caller, isFloor){
            if (!__emotionDialog){ __emotionDialog = Qt.createComponent("Dialog/EmotionDialog.qml"); }
            var diag = __emotionDialog.createObject(pageStack.currentPage);
            diag.caller = caller;
            diag.isFloor = isFloor;
            diag.open();
        }
        function threadManage(page){
            if (!__threadManageDialog){ __threadManageDialog = Qt.createComponent("Dialog/ThreadManageDialog.qml"); }
            var diag = __threadManageDialog.createObject(pageStack.currentPage);
            diag.page = page;
            diag.open();
        }
        function commitGood(catelist, param){
            if (!__goodlistDialog){ __goodlistDialog = Qt.createComponent("Dialog/CommitGoodDialog.qml") };
            var diag = __goodlistDialog.createObject(pageStack.currentPage);
            diag.model = catelist;
            diag.param = param;
            diag.open();
        }
        function createThreadMenu(page, index, modelData){
            if (!__threadMenu) { __threadMenu = Qt.createComponent("Dialog/ThreadMenu.qml") };
            var diag = __threadMenu.createObject(pageStack.currentPage);
            diag.modelData = modelData;
            diag.currentIndex = index;
            diag.page = page;
            diag.open();
        }
        function commitPrison(manager, param){
            if (!__commitPrisonDialog){ __commitPrisonDialog = Qt.createComponent("Dialog/CommitPrisonDialog.qml"); }
            var diag = __commitPrisonDialog.createObject(pageStack.currentPage);
            diag.manager = manager;
            diag.param = param;
            diag.open();
        }
    }

    function enterForum(name){
        var qmlstring = tbsettings.viewPhoto ? "ForumPicturePage.qml" : "ForumPage.qml";
        var page = pageStack.push(Qt.resolvedUrl(qmlstring),{ name: name });
        page.getlist();
    }

    function enterThread(option){
        if (!threadPage){ threadPage = Qt.createComponent("ThreadPage.qml").createObject(app); }
        if (option){ threadPage.addThreadView(option); }
        if (pageStack.currentPage != threadPage){ pageStack.push(threadPage); }
    }

    function enterFloor(option){
        var page = pageStack.push(Qt.resolvedUrl("FloorPage.qml"), option);
        page.getlist();
    }

    function addBookmark(threadId, postId, author, title, isLz){
        try {
            if (Database.saveBookMark(threadId, postId, author, title, isLz)){
                signalCenter.showMessage(qsTr("Bookmark is saved"));
            } else {
                signalCenter.showMessage(qsTr("Bookmark cannot be saved > <"));
            }
        } catch(e){
            signalCenter.showMessage(JSON.stringify(e));
        }
    }

    Component.onCompleted: {
        tbsettings.fontSize = tbsettings.fontSize||platformStyle.fontSizeMedium;
        Database.initialize();
        Script.signalCenter = signalCenter;
        Script.tbsettings = tbsettings;
        Script.utility = utility;
        Script.loadAuthData();
    }
}
