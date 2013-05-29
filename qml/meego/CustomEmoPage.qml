import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/storage.js" as Database

Page {
    id: page;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-add";
            enabled: uploader.caller != page.toString()||uploader.uploadState==0;
            onClicked: internal.openDialog();
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active){
            internal.loadEmoList();
        }
    }

    Connections {
        target: signalCenter;
        onUploadFinished: {
            if (caller == page.toString()){
                internal.uploadFinished(info);
            }
        }
    }

    QtObject {
        id: internal;
        property variant customEmoList: [];
        property string selectedImage: "";
        property string selectedName: "";
        property QtObject emoDialog: null;

        function loadEmoList(){
            customEmoList = Database.getCustomEmo();
        }

        function startUpload(){
            if (selectedImage.length > 0){
                signalCenter.postImage(page.toString(), selectedImage);
            }
        }

        function uploadFinished(imageinfo){
            var name = selectedName||"MyEmo";
            if (checkNameExists(name)){
                var i = 1;
                while (checkNameExists(name+"-"+i))
                    i ++;
                name += "-"+i;
            }
            Database.addCustomEmo(name,
                                  utility.createThumbnail(selectedImage, Qt.size(46, 46))||selectedImage,
                                  "pic,"+imageinfo.pic_id+","+imageinfo.width+","+imageinfo.height);
            loadEmoList();
        }

        function removeEmo(name, url){
            Database.deleteCustomEmo(name);
            loadEmoList();
            utility.removeFile(url);
        }

        function checkNameExists(name){
            return customEmoList.some(function(value){return value.name == name});
        }

        function openDialog(){
            if (!emoDialog){ emoDialog = diagComp.createObject(page); }
            emoDialog.open();
        }
    }

    Component {
        id: diagComp;
        Sheet {
            id: emoDialog;
            acceptButtonText: qsTr("Upload");
            rejectButtonText: qsTr("Cancel");

            content: Flickable {
                anchors.fill: parent;
                clip: true;
                contentWidth: parent.width;
                contentHeight: dialogCol.height;
                Column {
                    id: dialogCol;
                    anchors { left: parent.left; right: parent.right; }
                    spacing: constant.paddingSmall;
                    SelectionListItem {
                        id: imgSrc;
                        width: parent.width;
                        title: qsTr("Select image");
                        onClicked: dialog.createImageSelectDialog(page);
                        Connections {
                            target: signalCenter;
                            onImageSelected: {
                                if (caller == page.toString() && url){
                                    imgSrc.subTitle = url.replace("file://", "");
                                }
                            }
                        }
                    }
                    TextField {
                        id: nameField;
                        placeholderText: qsTr("Set name (optional)");
                        anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                    }
                }
            }

            onStatusChanged: {
                if (status == DialogStatus.Opened){
                    imgSrc.subTitle = "";
                    nameField.text = "";
                }
            }

            onAccepted: {
                internal.selectedImage = imgSrc.subTitle;
                internal.selectedName = nameField.text;
                internal.startUpload();
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: qsTr("%1 records in all").arg(internal.customEmoList.length)
        loading: uploader.caller == page.toString() && uploader.uploadState == 2;
    }

    ListView {
        id: view;
        anchors { left: parent.left; right: parent.right; top: viewHeader.bottom; bottom: uploadIndicator.top; }
        model: internal.customEmoList;
        delegate: deleComp;
        Component {
            id: deleComp;
            AbstractDelegate {
                id: root;
                Image {
                    id: thumbnail;
                    anchors { left: root.paddingItem.left; top: root.paddingItem.top; bottom: root.paddingItem.bottom; }
                    asynchronous: true;
                    cache: false;
                    width: height;
                    source: modelData.thumbnail;
                }
                Button {
                    id: removeButton;
                    anchors { right: root.paddingItem.right; verticalCenter: parent.verticalCenter; }
                    platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                    iconSource: "image://theme/icon-m-toolbar-delete"+(theme.inverted?"-white":"");
                    onClicked: internal.removeEmo(modelData.name, modelData.thumbnail);
                }
                Text {
                    anchors {
                        left: thumbnail.right; right: removeButton.left;
                        margins: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: modelData.name;
                    elide: Text.ElideRight;
                    font.pixelSize: constant.fontSizeLarge;
                    color: constant.colorLight;
                }
            }
        }
    }

    AbstractDelegate {
        id: uploadIndicator;
        enabled: false;
        anchors { left: parent.left; right: parent.right; top: parent.bottom; }
        opacity: 0;
        Image {
            id: thumbnail;
            anchors {
                left: uploadIndicator.paddingItem.left;
                top: uploadIndicator.paddingItem.top;
                bottom: uploadIndicator.paddingItem.bottom;
            }
            width: height;
            sourceSize.height: height;
            source: internal.selectedImage;
        }
        Column {
            anchors {
                left: thumbnail.right; leftMargin: constant.paddingMedium;
                right: uploadIndicator.paddingItem.right;
                top: uploadIndicator.paddingItem.top;
            }
            spacing: constant.paddingSmall;
            Text {
                width: parent.width;
                text: internal.selectedImage;
                font.pixelSize: constant.fontSizeLarge;
                color: constant.colorLight;
            }
            ProgressBar {
                id: progressBar;
                width: parent.width;
                value: viewHeader.loading ? uploader.progress : 0;
            }
        }
        states: [
            State {
                name: "uploading";
                AnchorChanges { target: uploadIndicator; anchors.top: undefined; anchors.bottom: page.bottom; }
                PropertyChanges { target: uploadIndicator; opacity: 1; }
                PropertyChanges { target: progressBar; value: uploader.progress; }
                when: uploader.caller == page.toString() && uploader.uploadState == 2;
            }
        ]
        transitions: Transition {
            AnchorAnimation { duration: 200; }
            PropertyAnimation { property: "opacity"; duration: 200; }
        }
    }
}
