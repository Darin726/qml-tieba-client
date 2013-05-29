import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "../js/main.js" as Script

Page {
    id: page;

    property bool loading: false;
    property variant param: null;

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

    Item {
        id: viewHeader
        opacity: app.inPortrait ? 1 : 0;
        width: parent.width;
        height: opacity ? headerBackground.height : 0;
        Image {
            id: headerBackground
            source: "image://theme/meegotouch-sheet-header"+(theme.inverted?"-inverted":"")+"-background";
            width: viewHeader.width
        }
        SheetButton {
            anchors { left: parent.left; leftMargin: constant.paddingXLarge; verticalCenter: parent.verticalCenter; }
            text: qsTr("Cancel");
            onClicked: {
                tbsettings.draftBox = contentArea.text;
                pageStack.pop();
            }
        }
        Text {
            id: headerText;
            anchors { right: parent.right; rightMargin: constant.paddingXLarge; verticalCenter: parent.verticalCenter; }
            text: qsTr("Create A New Thread");
            font.pixelSize: constant.fontSizeXXLarge;
            color: constant.colorLight;
        }
    }

    Flickable {
        id: contentFlickable;
        anchors {
            left: parent.left; right: parent.right; top: viewHeader.bottom; bottom: toolsBanner.top;
        }
        contentWidth: parent.width;
        contentHeight: contentCol.height;

        clip: true;

        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            spacing: constant.paddingLarge;
            Item { width: 1; height: 1; visible: app.inPortrait; }
            TextField {
                id: titleField;
                anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge; }
                height: opacity ? implicitHeight : 0;
                maximumLength: 31;
                placeholderText: qsTr("Pleast Input Title (Required)");
            }
            TextArea {
                id: contentArea;
                property int minHeight: contentFlickable.height
                                        - titleField.height
                                        - imagePreviewLoader.height
                                        - (app.inPortrait ? constant.paddingLarge*3 : constant.paddingLarge*2);
                anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge; }
                textFormat: TextEdit.PlainText;
                placeholderText: qsTr("Tap To Input");
                Component.onCompleted: text = tbsettings.draftBox;
                function setHeight(){ contentArea.height = Math.max(implicitHeight, minHeight) }
                onMinHeightChanged: setHeight();
                onImplicitHeightChanged: setHeight();
            }
            Loader {
                id: imagePreviewLoader;
                anchors.horizontalCenter: parent.horizontalCenter;
                width: status == Loader.Null ? 0 : constant.thumbnailSize;
                height: width;
                sourceComponent: internal.selectedImageUrl ? imagePreview : undefined;
                Component {
                    id: imagePreview;
                    Item {
                        MouseArea {
                            anchors.fill: parent;
                            enabled: uploader.caller != page.toString() || uploader.uploadState == 0;
                            onClicked: {
                                pageStack.push(Qt.resolvedUrl("ImagePage.qml"), { imageUrl: internal.selectedImageUrl });
                            }
                        }
                        Image {
                            anchors.fill: parent;
                            sourceSize.height: constant.thumbnailSize;
                            fillMode: Image.PreserveAspectCrop;
                            source: internal.selectedImageUrl;
                            clip: true;
                        }
                        Rectangle {
                            anchors.centerIn: parent;
                            width: constant.graphicSizeMedium;
                            height: constant.graphicSizeMedium;
                            color: constant.colorDisabled;
                            radius: constant.paddingSmall;
                            visible: uploader.caller == page.toString() && uploader.uploadState == 2;
                            Text {
                                anchors.centerIn: parent;
                                text: Math.floor(uploader.progress*100)+"%";
                                font.pixelSize: constant.fontSizeMedium;
                                color: "white";
                            }
                        }
                        ToolIcon {
                            anchors {
                                right: parent.right; top: parent.top;
                                margins: -constant.paddingLarge;
                            }
                            platformIconId: "toolbar-close";
                            enabled: !loading;
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
        }
    }

    Item {
        id: toolsBanner;
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: constant.paddingLarge; }
        height: childrenRect.height;
        Row {
            id: toolsRow;
            spacing: constant.paddingSmall;
            Button {
                platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                iconSource: theme.inverted ? "gfx/btn_insert_face_res.png" : "gfx/btn_insert_face_nor.png";
                onClicked: dialog.selectEmotion(page, false);
            }
            Button {
                platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                iconSource: theme.inverted ? "gfx/btn_insert_at_res.png" : "gfx/btn_insert_at_nor.png";
                onClicked: pageStack.push(Qt.resolvedUrl("SelectFriendPage.qml"), {caller: page});
            }
            Button {
                platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                iconSource: theme.inverted ? "gfx/btn_insert_pics_res.png" : "gfx/btn_insert_pics_nor.png"
                onClicked: dialog.createImageSelectDialog(page);
            }
        }
        Button {
            anchors.right: parent.right;
            platformStyle: ButtonStyle { buttonWidth: buttonHeight*2; inverted: !theme.inverted; }
            text: qsTr("Post");
            enabled: (uploader.caller != page.toString()||uploader.uploadState == 0)&&!loading;
            onClicked: internal.post();
        }
    }

    states: [
        State {
            name: "post";
            PropertyChanges { target: headerText; text: qsTr("Add A Reply"); }
            PropertyChanges { target: titleField; opacity: 0; }
        },
        State {
            name: "weipost";
            PropertyChanges { target: headerText; text: qsTr("Create A Weipost"); }
            PropertyChanges { target: titleField; opacity: 0; }
        }
    ]
}
