import QtQuick 1.1
import com.nokia.symbian 1.1
import "js/storage.js" as Database
import "Component"

MyPage {
    id: page

    title: "表情管理"

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active){
            internal.loadEmoList()
        }
    }

    QtObject {
        id: internal
        property variant customEmoList: []
        property string selectedImage
        property string selectedName
        function loadEmoList(){
            customEmoList = Database.getCustomEmo()
        }
        function startUpload(){
            if (selectedImage != ""){
                signalCenter.postImage(page.toString(), selectedImage)
            }
        }
        function uploadFinished(imageinfo){
            var name = selectedName || "MyEmo"
            if (checkNameExists(name)){
                var i = 1;
                while (checkNameExists(name+"-"+i))
                    i ++;
                name += "-"+i;
            }
            Database.addCustomEmo(name,
                                  utility.resizeImage(selectedImage,Qt.size(46, 46))||selectedImage,
                                  "pic,"+imageinfo.pic_id+","+imageinfo.width+","+imageinfo.height)
            loadEmoList()
        }
        function removeEmo(name, url){
            Database.deleteCustomEmo(name)
            loadEmoList()
            utility.removeFile(url)
        }
        function checkNameExists(name){
            for (var i in customEmoList){
                if (customEmoList[i].name == name)
                    return true;
            }
            return false;
        }
    }

    Connections {
        target: signalCenter
        onUploadFinished: {
            if (caller == page.toString()){
                internal.uploadFinished(info)
            }
        }
    }

    CommonDialog {
        id: addEmoDialog
        titleText: "添加一个自定义表情"
        buttonTexts: ["上传","取消"]
        content: Column {
            width: parent.width
            spacing: platformStyle.paddingSmall;
            MenuItem {
                id: imgSrc
                ListItemText {
                    role: "SubTitle"
                    text: "选择图片"
                    anchors {
                        left: parent.left; leftMargin: imgSrc.platformLeftMargin;
                        verticalCenter: parent.verticalCenter
                    }
                    visible: imgSrc.text == ""
                }
                onClicked: imgSrc.text = utility.choosePhoto() || imgSrc.text
            }
            TextField {
                id: nameField
                placeholderText: "设定名称"
                anchors {
                    left: parent.left; right: parent.right; margins: platformStyle.paddingLarge
                }
            }
        }
        onButtonClicked: {
            if (index == 0){
                internal.selectedImage = imgSrc.text;
                internal.selectedName = nameField.text;
                internal.startUpload()
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        model: internal.customEmoList
        header: ListHeading {
            platformInverted: tbsettings.whiteTheme
            ListItemText {
                anchors.fill: parent.paddingItem; role: "Heading";
                text: "共%1条记录".arg(internal.customEmoList.length)
                platformInverted: tbsettings.whiteTheme
            }
        }
        delegate: ListItem {
            id: listItem
            platformInverted: tbsettings.whiteTheme
            Image {
                id: thumbnail
                anchors {
                    left: listItem.paddingItem.left; top: listItem.paddingItem.top;
                    bottom: listItem.paddingItem.bottom
                }
                asynchronous: true;
                cache: false;
                width: height;
                source: modelData.thumbnail
            }
            Button {
                id: removeButton
                anchors {
                    right: listItem.paddingItem.right; verticalCenter: parent.verticalCenter
                }
                platformInverted: tbsettings.whiteTheme
                iconSource: privateStyle.toolBarIconPath("toolbar-delete", platformInverted)
                onClicked: internal.removeEmo(modelData.name, modelData.thumbnail)
            }
            ListItemText {
                anchors {
                    left: thumbnail.right; right: removeButton.left; margins: platformStyle.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
                platformInverted: tbsettings.whiteTheme
                text: modelData.name
            }
        }
        footer: ListItem {
            property int index: -1
            platformInverted: tbsettings.whiteTheme
            onClicked: {
                if (state == "uploading"){
                    Qt.createComponent("Dialog/AbortUploadDialog.qml").createObject(page).open()
                } else {
                    imgSrc.text = "";
                    nameField = "";
                    addEmoDialog.open()
                }
            }
            states: [
                State {
                    name: "uploading"
                    when: uploader.currentCaller == page.toString() && uploader.uploadState == 2
                    PropertyChanges { target: footerThumb; visible: true; source: internal.selectedImage }
                    PropertyChanges { target: footerCol; visible: true;}
                    PropertyChanges { target: addImage; visible: false; }
                    PropertyChanges { target: progressBar; value: uploader.progress; }
                }
            ]
            Image {
                id: addImage
                anchors.centerIn: parent
                source: privateStyle.toolBarIconPath("toolbar-add", tbsettings.whiteTheme)
            }
            Image {
                id: footerThumb
                anchors {
                    left: parent.paddingItem.left; top: parent.paddingItem.top; bottom: parent.paddingItem.bottom;
                }
                visible: false;
                width: height;
            }
            Column {
                id: footerCol
                visible: false;
                anchors {
                    left: footerThumb.right; leftMargin: platformStyle.paddingMedium;
                    right: parent.paddingItem.right; top: parent.paddingItem.top;
                }
                spacing: platformStyle.paddingSmall;
                ListItemText {
                    width: parent.width;
                    platformInverted: tbsettings.whiteTheme;
                    text: internal.selectedName;
                }
                ProgressBar {
                    id: progressBar
                    width: parent.width;
                    platformInverted: tbsettings.whiteTheme;
                }
            }
        }
    }
}
