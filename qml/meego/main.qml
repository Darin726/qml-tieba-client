import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import QtMobility.location 1.2
import HttpUp 1.0
import "Component"
import "../js/main.js" as Script
import "../js/storage.js" as Database
import "../js/const.js" as Const
import "../js/linkDecoder.js" as Link

PageStackWindow {
    id: app

    property QtObject threadPage: null;
    property QtObject recomPage: null;
    property QtObject signPage: null;

    showStatusBar: inPortrait;
    initialPage: MainPage { id: mainPage; }
    platformStyle: PageStackWindowStyle {
        background: tbsettings.backgroundImage.length == 0 ? "" : "image://background/"+tbsettings.backgroundImage+__invertedString;
        backgroundFillMode: Image.PreserveAspectCrop;
    }
    // Meego Style
    Constant { id: constant; }

    // Signal Center;
    SignalCenter { id: signalCenter; }

    Connections {
        target: signalCenter;
        onNeedAuthorization: {
            var prop = { forceLogin: forceLogin };
            pageStack.push(Qt.resolvedUrl("LoginPage.qml"), prop);
        }
        onLoadStarted: processingTimer.restart();
        onLoadFinished: processingTimer.stop();
        onLoadFailed: {
            signalCenter.hideBusyIndicator();
            signalCenter.showMessage(errorString);
            processingTimer.stop();
        }
        onShowMessage: {
            if (message||false){
                infoBanner.text = message;
                infoBanner.show();
            }
        }
        onNeedVCode: {
            dialog.createVCodeInputDialog(caller, vcodePicUrl, vcodeMd5);
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
            uploader.addFile("pic", url.replace("file://", ""));
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
        topMargin: app.showStatusBar ? 36 : 0;
        iconSource: "gfx/tb_mini.svg";
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
        property bool valid: position.longitudeValid && position.latitudeValid;
        updateInterval: 1000;
        onPositionChanged: stop();
        function update(){ start(); }
    }

    // Image Downloader
    Connections {
        target: downloader;
        onStateChanged: {
            if (downloader.state == 1){
                downloadInfoBanner.show();
            }
            else if (downloader.state == 3){
                downloadInfoBanner.hide();
                if (downloader.error == 0){
                    Qt.openUrlExternally("file:///"+downloader.currentFile);
                }
            }
        }
    }

    InfoBanner {
        id: downloadInfoBanner;
        topMargin: app.showStatusBar ? 36 : 0;
        iconSource: "gfx/tb_mini.svg";
        timerEnabled: false;
        text: qsTr("Downloading image: %1%(Click to cancel)").arg(Math.floor(downloader.progress*100));
        MouseArea {
            anchors.fill: parent;
            onClicked: downloader.abortDownload(false);
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
        property Component __gallerySheet: null;
        property Component __scribbleSheet: null;
        property Component __readerSheet: null;

        function createVCodeInputDialog(caller, vcodePicUrl, vcodeMd5){
            if (!__vcodeDialog){ __vcodeDialog = Qt.createComponent("Dialog/VCodeDialog.qml"); }
            var prop = {caller: caller, vcodePicUrl: vcodePicUrl, vcodeMd5: vcodeMd5};
            __vcodeDialog.createObject(pageStack.currentPage, prop);
        }
        function createImageSelectDialog(caller){
            if (!__imageDialog){ __imageDialog = Qt.createComponent("Dialog/ImageSelectDialog.qml"); }
            __imageDialog.createObject(pageStack.currentPage, {caller: caller});
        }
        function createQueryDialog(title, message, acceptText, rejectText, acceptCallback, rejectCallback){
            if (!__queryDialog){ __queryDialog = Qt.createComponent("Dialog/DynamicQueryDialog.qml"); }
            var prop = { titleText: title, message: message.concat("\n"), acceptButtonText: acceptText, rejectButtonText: rejectText };
            var diag = __queryDialog.createObject(pageStack.currentPage, prop);
            if (acceptCallback) diag.accepted.connect(acceptCallback);
            if (rejectCallback) diag.rejected.connect(rejectCallback);
        }
        function selectEmotion(caller, isFloor){
            if (!__emotionDialog){ __emotionDialog = Qt.createComponent("Dialog/EmotionDialog.qml"); }
            var prop = { caller: caller, isFloor: isFloor }
            __emotionDialog.createObject(pageStack.currentPage, prop);
        }
        function threadManage(page){
            if (!__threadManageDialog){ __threadManageDialog = Qt.createComponent("Dialog/ThreadManageDialog.qml"); }
            __threadManageDialog.createObject(pageStack.currentPage, {page: page});
        }
        function commitGood(catelist, param){
            if (!__goodlistDialog){ __goodlistDialog = Qt.createComponent("Dialog/CommitGoodDialog.qml") };
            var prop = { catelist: catelist, param: param };
            __goodlistDialog.createObject(pageStack.currentPage, prop);
        }
        function createThreadMenu(page, index, modelData){
            if (!__threadMenu) { __threadMenu = Qt.createComponent("Dialog/ThreadMenu.qml") };
            var prop = { modelData: modelData, currentIndex: index, page: page };
            __threadMenu.createObject(pageStack.currentPage, prop);
        }
        function commitPrison(manager, param){
            if (!__commitPrisonDialog){ __commitPrisonDialog = Qt.createComponent("Dialog/CommitPrisonDialog.qml"); }
            var prop = { manager: manager, param: param }
            __commitPrisonDialog.createObject(pageStack.currentPage, prop);
        }
        function launchGallery(caller){
            if (!__gallerySheet){ __gallerySheet = Qt.createComponent("Dialog/GallerySheet.qml"); }
            __gallerySheet.createObject(pageStack.currentPage, { caller: caller });
        }
        function scribble(caller){
            if (!__scribbleSheet){ __scribbleSheet = Qt.createComponent("ScribblePage.qml"); }
            __scribbleSheet.createObject(pageStack.currentPage, { caller: caller });
        }
        function createReaderPage(prop){
            if (!__readerSheet){ __readerSheet = Qt.createComponent("ReaderPage.qml"); }
            __readerSheet.createObject(pageStack.currentPage, prop);
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
        tbsettings.fontSize = tbsettings.fontSize||constant.fontSizeMedium;
        if (!tbsettings.whiteTheme) theme.inverted = true;
        Database.initialize();
        Script.signalCenter = signalCenter;
        Script.tbsettings = tbsettings;
        Script.utility = utility;
        Script.loadAuthData();
    }
}
