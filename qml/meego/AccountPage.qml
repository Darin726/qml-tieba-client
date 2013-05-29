import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script
import "../js/storage.js" as Database

Page {
    id: page;

    property bool isEdit: false;
    property variant accountArray: [];

    onStatusChanged: {
        if (status == PageStatus.Active){
            internal.renewArray();
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-add";
            onClicked: signalCenter.needAuthorization(false);
        }
        ToolIcon {
            platformIconId: isEdit ? "toolbar-done" : "toolbar-edit";
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
        headerText: qsTr("Account Manager");
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

            AbstractDelegate {
                id: root;
                onClicked: {
                    if (modelData.userId != Script.uid){
                        internal.changeAccount(modelData);
                    }
                }
                Text {
                    anchors { left: root.paddingItem.left; verticalCenter: root.verticalCenter; }
                    text: modelData.userName;
                    font.pixelSize: constant.fontSizeLarge;
                    color: constant.colorLight;
                }
                Row {
                    anchors { right: root.paddingItem.right; verticalCenter: root.verticalCenter; }
                    spacing: constant.paddingMedium;
                    Image {
                        id: icon;
                        function setSource(){
                            if (modelData.userId == Script.uid){
                                icon.source = "image://theme/icon-m-toolbar-done"+(theme.inverted?"-white":"");
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
                    ToolButton {
                        id: removeButton;
                        visible: page.isEdit;
                        platformStyle: ToolButtonStyle { buttonWidth: buttonHeight; }
                        iconSource: "image://theme/icon-m-toolbar-delete"+(theme.inverted?"-white":"");
                        onClicked: internal.deleteClicked(index, modelData);
                    }
                }
            }
        }
    }
}
