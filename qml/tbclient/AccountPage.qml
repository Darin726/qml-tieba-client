import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script
import "js/storage.js" as Database

MyPage {
    id: accountPage
    title: "账号管理"

    property bool isEdit: false
    property variant accountArray: []

    onStatusChanged: {
        if (status == PageStatus.Active){
            internal.renewArray()
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "toolbar-add"; onClicked: pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
        }
        ToolButton {
            iconSource: (isEdit? "qrc:/gfx/ok%1.svg" : "qrc:/gfx/edit%1.svg").arg(platformInverted?"_inverted":"")
            onClicked: isEdit = !isEdit
        }
    }
    QtObject {
        id: internal
        function logout(){
            Script.userId = ""; Script.userName = ""; Script.BDUSS = ""; tbsettings.defaultId = ""
            utility.clearCache()
            signalCenter.currentUserChanged()
            pageStack.clear()
            pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
        }
        function renewArray(){
            accountArray = Database.getUserInfo()
        }
        function deleteClicked(index, modelData){
            Database.deleteUserInfo(modelData.userId)
            renewArray()
            if ( Script.userId == modelData.userId ){
                if (accountArray.length > index){
                    changeAccount(accountArray[index].userId, accountArray[index].BDUSS, accountArray[index].userName)
                }
                else if ( accountArray.length > 0 ){
                    changeAccount(accountArray[0].userId, accountArray[0].BDUSS, accountArray[0].userName)
                } else {
                    logout()
                }
            }
        }
        function changeAccount(userId, BDUSS, userName){
            Script.userId = userId; Script.BDUSS = BDUSS; Script.userName = userName
            utility.clearCache()
            tbsettings.defaultId = userId
            signalCenter.currentUserChanged()
        }
    }
    ListView {
        id: view
        anchors.fill: parent
        model: accountArray
        delegate: ListItem {
            platformInverted: tbsettings.whiteTheme
            onClicked: {
                if ( modelData.userId != Script.userId)
                    internal.changeAccount(modelData.userId, modelData.BDUSS, modelData.useName)
            }
            ListItemText {
                anchors {
                    left: parent.paddingItem.left
                    verticalCenter: parent.verticalCenter
                }
                text: modelData.userName
                platformInverted: parent.platformInverted
            }
            Row {
                anchors {
                    right: parent.paddingItem.right; verticalCenter: parent.verticalCenter
                }
                spacing: platformStyle.paddingMedium
                Image {
                    id: img
                    Component.onCompleted: {
                        source = modelData.userId == Script.userId
                                ? "qrc:/gfx/ok%1.svg".arg(tbsettings.whiteTheme?"_inverted":""):""
                    }
                    Connections {
                        target: signalCenter
                        onCurrentUserChanged: {
                            img.source = modelData.userId == Script.userId
                                    ? "qrc:/gfx/ok%1.svg".arg(tbsettings.whiteTheme?"_inverted":""):""
                        }
                    }
                }
                Button {
                    id: removeButton
                    visible: accountPage.isEdit
                    platformInverted: tbsettings.whiteTheme
                    iconSource: privateStyle.toolBarIconPath("toolbar-delete", platformInverted)
                    onClicked: internal.deleteClicked(index, modelData)
                }
            }
        }
        footer: Item {
            width: screen.width; height: platformStyle.graphicSizeLarge
            Button {
                width: parent.width - platformStyle.paddingLarge*2
                anchors.centerIn: parent
                platformInverted: tbsettings.whiteTheme
                text: "退出登录"
                onClicked: internal.logout()
            }
        }
    }
}
