import QtQuick 1.0
import com.nokia.symbian 1.0
import HttpUp 1.0
import "Component"
import "../js/Calculate.js" as Calc
import "../js/const.js" as Const
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool loading: uploader.caller == page.toString() && uploader.uploadState == HttpUploader.Loading;
    property Item caller: null;

    title: viewHeader.headerText;

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Save");
            enabled: !loading;
            iconSource: "gfx/ok.svg";
            onClicked: internal.saveProfile();
        }
    }

    QtObject {
        id: internal;

        function uploadAvatar(){
            var imgurl = utility.selectImage();
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
    }

    onHeightChanged: {
        if (introField.activeFocus){
            view.contentY = view.contentHeight - view.height;
        }
    }

    ViewHeader {
        id: viewHeader;
        headerIcon: "gfx/edit.svg";
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
                ListItemText {
                    anchors {
                        right: avatar.paddingItem.right;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: loading && uploader.url == Const.C_IMG_PORTRAIT ? Math.floor(uploader.progress*100)+"%" : qsTr("Edit Avatar");
                    role: "SubTitle";
                }
                onClicked: internal.uploadAvatar();
            }
            ListItem {
                enabled: false;
                ListItemText {
                    anchors { left: parent.paddingItem.left; verticalCenter: parent.verticalCenter; }
                    text: qsTr("Gender");
                }
                ButtonRow {
                    id: genderButtonRow;
                    anchors { right: parent.paddingItem.right; verticalCenter: parent.verticalCenter; }
                    RadioButton {
                        id: male;
                        text: qsTr("Male");
                    }
                    RadioButton {
                        id: female;
                        text: qsTr("Female");
                    }
                }
            }
            ListItem {
                enabled: false;
                ListItemText {
                    anchors.left: parent.paddingItem.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Introduction:");
                }
            }
            TextArea {
                id: introField;
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingMedium; }
                text: caller ? caller.user.intro : "";
            }
        }
    }    
}
