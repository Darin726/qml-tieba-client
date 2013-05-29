import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"
import "../js/main.js" as Script
import "../js/storage.js" as Database

MyPage {
    id: page;

    property bool isEdit: false;
    property variant accountArray: [];

    onStatusChanged: {
        if (status == PageStatus.Active){
            internal.renewArray();
        }
    }

    title: qsTr("Account Manager");
    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Add Account");
            iconSource: "toolbar-add";
            onClicked: signalCenter.needAuthorization(false);
        }
        ToolButtonWithTip {
            toolTipText: isEdit ? qsTr("OK") : qsTr("Edit");
            iconSource: isEdit ? "gfx/ok.svg" : "gfx/edit.svg";
            onClicked: isEdit = !isEdit;
        }
    }

    QtObject {
        id: internal;
        function logout(){
            Script.uid = ""; Script.username = ""; Script.BDUSS = "";
            tbsettings.userId = "";
            utility.clearCache();
            signalCenter.userChanged();
            pageStack.clear();
            signalCenter.needAuthorization(true);
        }
        function renewArray(){
            accountArray = Database.getUserInfo();
        }
        function deleteClicked(index, modelData){
            Database.deleteUserInfo(modelData.userId);
            renewArray();
            if (Script.uid == modelData.userId){
                if (accountArray.length > index){
                    changeAccount(accountArray[index]);
                } else if (accountArray.length > 0){
                    changeAccount(accountArray[0]);
                } else {
                    logout();
                }
            }
        }
        function changeAccount(modelData){
            Script.uid = modelData.userId;
            Script.BDUSS = modelData.BDUSS;
            Script.username = modelData.userName;
            utility.clearCache();
            tbsettings.userId = Script.uid;
            signalCenter.userChanged();
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: title;
        headerIcon: "gfx/sign_in.svg";
        enabled: false;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: accountArray;
        delegate: accountDelegate;
        footer: FooterItem {
            text: qsTr("Logout");
            onClicked: internal.logout();
        }

        Component {
            id: accountDelegate;
            ListItem {
                id: root;
                onClicked: {
                    if (modelData.userId != Script.uid){
                        internal.changeAccount(modelData);
                    }
                }
                ListItemText {
                    anchors { left: root.paddingItem.left; verticalCenter: root.verticalCenter; }
                    text: modelData.userName;
                }
                Row {
                    anchors { right: root.paddingItem.right; verticalCenter: root.verticalCenter; }
                    spacing: platformStyle.paddingMedium;
                    Image {
                        id: icon;
                        function setSource(){
                            if (modelData.userId == Script.uid){
                                icon.source = "gfx/ok.svg";
                            } else {
                                icon.source = "";
                            }
                        }
                        Component.onCompleted: {
                            setSource();
                            signalCenter.userChanged.connect(setSource);
                        }
                        Component.onDestruction: {
                            signalCenter.userChanged.disconnect(setSource);
                        }
                    }
                    Button {
                        id: removeButton;
                        visible: page.isEdit;
                        iconSource: privateStyle.toolBarIconPath("toolbar-delete");
                        onClicked: internal.deleteClicked(index, modelData);
                    }
                }
            }
        }
    }
}
