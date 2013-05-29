import QtQuick 1.1
import com.nokia.meego 1.0
import HttpUp 1.0
import "Component"
import "../js/Calculate.js" as Calc
import "../js/const.js" as Const
import "../js/main.js" as Script

Page {
    id: page;

    property bool loading: uploader.caller == page.toString() && uploader.uploadState == HttpUploader.Loading;
    property Item caller: null;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-done";
            enabled: !loading;
            onClicked: internal.saveProfile();
        }
    }

    QtObject {
        id: internal;

        function uploadAvatar(imgurl){
            if (imgurl.length == 0) return;

            avatar.iconSource = imgurl;
            if (uploader.uploadState == HttpUploader.Loading){
                uploader.abort();
            }
            uploader.caller = page.toString();
            uploader.open(Const.C_IMG_PORTRAIT);
            uploader.addField("BDUSS", Script.BDUSS);
            uploader.addField("_client_id", tbsettings.clientId||"wappc_1362027349698_178");
            uploader.addField("_client_type", tbsettings.clientType);
            uploader.addField("_client_version", tbsettings.clientVersion);
            uploader.addField("_phone_imei", tbsettings.imei);
            uploader.addField("from", "baidu_appstore");
            uploader.addField("net_type", 1);
            uploader.addFile("pic", imgurl);
            uploader.send();
        }

        function saveProfile(){
            if (uploader.uploadState == HttpUploader.Loading){
                uploader.abort();
            }
            uploader.caller = page.toString();
            uploader.open(Const.C_PROFILE_MODIFY);
            uploader.addField("BDUSS", Script.BDUSS);
            uploader.addField("_client_id", tbsettings.clientId||"wappc_1362027349698_178");
            uploader.addField("_client_type", tbsettings.clientType);
            uploader.addField("_client_version", tbsettings.clientVersion);
            uploader.addField("_phone_imei", tbsettings.imei);
            uploader.addField("from", "baidu_appstore");
            uploader.addField("intro", introField.text);
            uploader.addField("net_type", 1);
            uploader.addField("sex", male.checked?1:2);
            uploader.send();
        }
    }

    Connections {
        target: signalCenter;
        onUploadFinished: {
            if (caller == page.toString()){
                signalCenter.showMessage(qsTr("Success"));
                if (uploader.url == Const.C_IMG_PORTRAIT){
                    utility.clearNetworkCache();
                }
                page.caller.resetUser();
                if (uploader.url == Const.C_PROFILE_MODIFY){
                    pageStack.pop();
                }
            }
        }
        onImageSelected: {
            if (caller == page.toString() && url){
                internal.uploadAvatar(url.replace("file://", ""));
            }
        }
    }

    onHeightChanged: {
        if (introField.activeFocus){
            view.contentY = view.contentHeight - view.height;
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: qsTr("Edit Profile");
        loading: page.loading;
    }

    Flickable {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: parent.width;
        contentHeight: Math.max(view.height, contentCol.height);
        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            AboutPageItem {
                id: avatar;
                text: caller ? caller.user.name_show : "";
                iconSource: caller ? Calc.getAvatar(caller.user.portrait) : "";
                enabled: !loading;
                Text {
                    anchors {
                        right: avatar.paddingItem.right;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: loading && uploader.url == Const.C_IMG_PORTRAIT ? Math.floor(uploader.progress*100)+"%" : qsTr("Edit Avatar");
                    font { pixelSize: constant.fontSizeSmall; weight: Font.Light }
                    color: constant.colorMid;
                }
                onClicked: dialog.createImageSelectDialog(page);
            }
            Item {
                width: parent.width;
                height: constant.graphicSizeLarge;
                Text {
                    anchors { left: parent.left; leftMargin: constant.paddingLarge; verticalCenter: parent.verticalCenter; }
                    text: qsTr("Gender");
                    font.pixelSize: constant.fontSizeLarge;
                    color: constant.colorLight;
                }
                ButtonRow {
                    id: genderButtonRow;
                    width: male.width + female.width;
                    anchors { right: parent.right; rightMargin: constant.paddingLarge; verticalCenter: parent.verticalCenter; }
                    RadioButton {
                        id: male;
                        text: qsTr("Male");
                    }
                    RadioButton {
                        id: female;
                        text: qsTr("Female");
                    }
                }
                SplitLine { anchors.bottom: parent.bottom; }
            }
            Item {
                width: parent.width;
                height: constant.graphicSizeLarge;
                Text {
                    anchors { left: parent.left; leftMargin: constant.paddingLarge; verticalCenter: parent.verticalCenter; }
                    text: qsTr("Introduction:");
                    font.pixelSize: constant.fontSizeLarge;
                    color: constant.colorLight;
                }
                SplitLine { anchors.bottom: parent.bottom; }
            }
            TextArea {
                id: introField;
                anchors { left: parent.left; right: parent.right; margins: constant.paddingMedium; }
                text: caller ? caller.user.intro : "";
            }
        }
    }    
}
