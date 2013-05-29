import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool loading: false;
    property variant param: null;

    title: qsTr("Create A New Thread");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Cancel");
            text: qsTr("Cancel");
            onClicked: {
                tbsettings.draftBox = contentArea.text;
                pageStack.pop();
            }
        }
    }

    QtObject {
        id: internal;

        property string selectedImageUrl: "";
        property variant selectedImageInfo: null;

        property QtObject emotionSelector: null;
        property QtObject imageSelectDialog: null;

        function post(vcode, vcodeMd5){
            if (page.state == ""){
                if (titleField.text.length == 0){
                    signalCenter.showMessage(qsTr("Title is required"));
                    return;
                }
            } else {
                if (contentArea.text.length == 0 && selectedImageUrl.length == 0){
                    signalCenter.showMessage(qsTr("Content is required"));
                    return;
                }
            }

            if (selectedImageUrl && !selectedImageInfo){
                signalCenter.postImage(page.toString(), selectedImageUrl);
                return;
            }

            var opt = new Object();
            if (vcode){ opt.vcode = vcode; opt.vcodeMd5 = vcodeMd5; }

            var content = contentArea.text;
            if (selectedImageInfo){
                content += "\n#(pic,"+selectedImageInfo.pic_id+","+selectedImageInfo.width+","+selectedImageInfo.height+")";
            }
            opt.content = content;

            if (page.state == ""){
                opt.fid = param.fid;
                opt.kw = param.kw;
                opt.title = titleField.text;
                if (tbsettings.shareLocation && positionSource.valid){
                    var coor = positionSource.position.coordinate;
                    opt.lbs = coor.latitude+"%2C"+coor.longitude;
                }
                Script.addThread(page, opt);
            } else if (page.state == "post"){
                opt.fid = param.fid;
                opt.kw = param.kw;
                opt.tid = param.tid;
                Script.addPost(page, opt);
            } else if (page.state == "weipost"){
                opt.weipost = true;
                opt.fid = "";
                if (positionSource.valid){
                    var coor = positionSource.position.coordinate;
                    opt.lbs = coor.latitude+"%2C"+coor.longitude;
                }
                Script.addThread(page, opt);
            }
        }
    }

    Connections {
        target: signalCenter;
        onPostStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onPostFinished: {
            if (caller == page.toString()){
                tbsettings.draftBox = "";
                loading = false;
                if (type == "thread"){
                    pageStack.pop();
                    param.caller.getlist("renew");
                } else if (type == "post"){
                    pageStack.pop();
                    var view = param.caller;
                    if (view.isReverse?!view.hasPrev:!view.hasMore){
                        view.getlist(view.isReverse?"prev":"next");
                    }
                }
            }
        }
        onPostFailed: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onVcodeSent: {
            if (caller == page.toString()){
                internal.post(vcode, vcodeMd5);
            }
        }
        onImageSelected: {
            if (caller == page.toString() && url){
                internal.selectedImageUrl = url;
            }
        }
        onUploadFinished: {
            if (caller == page.toString()){
                internal.selectedImageInfo = info;
                internal.post();
            }
        }
        onEmotionSelected: {
            if (caller == page.toString()){
                var c = contentArea.cursorPosition;
                contentArea.text = contentArea.text.substring(0,c)+name+contentArea.text.substring(c);
                contentArea.cursorPosition = c+name.length;
            }
        }
        onFriendSelected: {
            if (caller == page.toString()){
                var c = contentArea.cursorPosition;
                contentArea.text = contentArea.text.substring(0,c)+"@"+name+" "+contentArea.text.substring(c);
                contentArea.cursorPosition = c+name.length+2;
            }
        }
        onLoadFailed: loading = false;
    }

    ViewHeader {
        id: viewHeader;
        headerText: title;
        headerIcon: "gfx/edit.svg";
        loading: page.loading;
        opacity: app.inPortrait||!inputContext.visible ? 1 : 0;
        Behavior on opacity { NumberAnimation { duration: 200; } }
    }

    TextField {
        id: titleField;
        anchors {
            left: parent.left; leftMargin: platformStyle.paddingLarge;
            right: parent.right; rightMargin: platformStyle.paddingLarge;
            top: viewHeader.bottom; topMargin: platformStyle.paddingLarge;
        }
        maximumLength: 31;
        placeholderText: qsTr("Pleast Input Title (Required)");
        platformInverted: tbsettings.whiteTheme;
        states: State {
            name: "landscapeInput";
            AnchorChanges { target: titleField; anchors.top: page.top; }
            PropertyChanges { target: titleField; anchors.topMargin: 0; }
            when: titleField.visible && viewHeader.opacity == 0;
        }
        transitions: Transition { AnchorAnimation { duration: 200; } }
    }

    Item {
        id: toolsBanner;
        anchors {
            left: parent.left; leftMargin: platformStyle.paddingLarge;
            right: parent.right; rightMargin: platformStyle.paddingLarge;
            bottom: parent.bottom; bottomMargin: screen.width > screen.height ? platformStyle.paddingLarge : 180;
        }
        height: childrenRect.height;
        opacity: inputContext.visible ? 0 : 1;
        Behavior on opacity { NumberAnimation { duration: 250; } }
        Row {
            id: toolsRow;
            anchors.left: parent.left;
            spacing: platformStyle.paddingSmall;
            ToolButton {
                platformInverted: tbsettings.whiteTheme;
                iconSource: platformInverted?"gfx/btn_insert_face_nor.png":"gfx/btn_insert_face_res.png";
                onClicked: {
                    dialog.selectEmotion(page, false);
                }
            }
            ToolButton {
                platformInverted: tbsettings.whiteTheme;
                iconSource: platformInverted?"gfx/btn_insert_at_nor.png":"gfx/btn_insert_at_res.png";
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SelectFriendPage.qml"), {caller: page});
                }
            }
            ToolButton {
                platformInverted: tbsettings.whiteTheme;
                iconSource: platformInverted ? "gfx/btn_insert_pics_nor.png" : "gfx/btn_insert_pics_res.png";
                onClicked: dialog.createImageSelectDialog(page);
            }
        }
        ToolButton {
            anchors.top: screen.width > screen.height ? parent.top : toolsRow.bottom;
            anchors.right: parent.right;
            platformInverted: tbsettings.whiteTheme;
            text: qsTr("Post");
            enabled: (uploader.caller != page.toString()||uploader.uploadState == 0)&&!loading;
            onClicked: internal.post();
        }
    }
    TextArea {
        id: contentArea;
        anchors {
            left: parent.left;
            right: parent.right;
            top: titleField.bottom;
            bottom: inputContext.visible ? parent.bottom : toolsBanner.top;
            margins: platformStyle.paddingLarge;
        }
        textFormat: TextEdit.PlainText;
        platformInverted: tbsettings.whiteTheme;
        placeholderText: qsTr("Tap To Input");
        Component.onCompleted: {
            text = tbsettings.draftBox;
        }
    }
    Loader {
        id: imagePreviewLoader;
        width: 160; height: 160;
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 20; }
        sourceComponent: !inputContext.visible && internal.selectedImageUrl ? imagePreview : undefined;
        states: [
            State {
                name: "landscape";
                PropertyChanges {
                    target: imagePreviewLoader;
                    width: privateStyle.toolBarHeightLandscape;
                    height: privateStyle.toolBarHeightLandscape;
                    anchors.bottomMargin: platformStyle.paddingLarge;
                    anchors.horizontalCenterOffset: platformStyle.graphicSizeMedium;
                }
                when: screen.width > screen.height;
            }
        ]
        Component {
            id: imagePreview;
            Item {
                anchors.fill: parent;
                MouseArea {
                    anchors.fill: parent;
                    enabled: uploader.caller != page.toString() || uploader.uploadState == 0;
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("ImagePage.qml"), { imageUrl: internal.selectedImageUrl });
                    }
                }
                Image {
                    anchors.fill: parent;
                    sourceSize.height: 160;
                    fillMode: Image.PreserveAspectCrop;
                    source: internal.selectedImageUrl;
                    clip: true;
                }
                Rectangle {
                    anchors.centerIn: parent;
                    width: platformStyle.graphicSizeMedium;
                    height: platformStyle.graphicSizeMedium;
                    color: screen.width > screen.height ? "#C0000000" :platformStyle.colorDisabledMid;
                    radius: 5;
                    visible: uploader.caller == page.toString() && uploader.uploadState == 2;
                    Label {
                        anchors.centerIn: parent;
                        text: Math.floor(uploader.progress*100)+"%";
                    }
                }
                ToolButton {
                    anchors {
                        right: parent.right; top: parent.top;
                        margins: -platformStyle.paddingLarge;
                    }
                    platformInverted: tbsettings.whiteTheme;
                    enabled: !loading;
                    iconSource: platformInverted ? "gfx/tb_close_stop_inverted.svg"
                                                 : "gfx/tb_close_stop.svg";
                    onClicked: {
                        if (uploader.caller != page.toString() || uploader.uploadState == 0){
                            internal.selectedImageUrl = "";
                        } else if (uploader.uploadState == 2){
                            uploader.abort();
                        }
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "post";
            PropertyChanges { target: page; title: qsTr("Add A Reply"); }
            PropertyChanges { target: titleField; visible: false; }
            PropertyChanges {
                target: contentArea;
                anchors.top: app.inPortrait||!inputContext.visible ? viewHeader.bottom : page.top;
            }
        },
        State {
            name: "weipost";
            PropertyChanges { target: page; title: qsTr("Create A Weipost"); }
            PropertyChanges { target: titleField; visible: false; }
            PropertyChanges {
                target: contentArea;
                anchors.top: app.inPortrait||!inputContext.visible ? viewHeader.bottom : page.top;
            }
        }
    ]
}
