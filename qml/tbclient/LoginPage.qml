import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script
import "js/storage.js" as Database

MyPage {
    id: loginPage
    title: "登录"
    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
        }
        CheckBox {
            id: phoneNumberCheck
            text: "手机号登录"
        }
    }
    Connections {
        target: signalCenter
        onLoginStarted: {
            if (caller == loginPage.toString()){
                loginBtn.enabled = false; loginBtn.text = "登录中..."
            }
        }
        onLoginFailed: {
            if (caller == loginPage.toString()){
                loginBtn.enabled = true; loginBtn.text = "登录"
                app.showMessage(errorString)
            }
        }
        onLoginSuccessed: {
            if (caller == loginPage.toString()){
                app.showMessage("登录成功")
                utility.clearCache()
                signalCenter.currentUserChanged()
                Database.saveUserInfo(id, name, BDUSS)
                tbsettings.defaultId = id
                if (pageStack.depth <= 1)
                    pageStack.replace(myBarPage)
                else
                    pageStack.pop()
            }
        }
        onVcodeSent: {
            if (caller == loginPage.toString()){
                var u = phoneNumberCheck.checked?phoneNumber.text:userName.text
                var p = passwordField.text
                if ( u == "" || p == ""){
                    app.showMessage("请输入有效的用户名或密码")
                } else
                    Script.login(caller, phoneNumberCheck.checked, u, p, vcode, vcodeMd5)
            }
        }
    }
    Flickable {
        id: flicky
        anchors {
            fill: parent; margins: platformStyle.paddingLarge
        }
        contentWidth: width
        contentHeight: contentCol.height

        Column {
            id: contentCol
            width: parent.width
            Row {
                spacing: platformStyle.paddingLarge
                Image {
                    sourceSize: Qt.size(platformStyle.graphicSizeLarge,
                                        platformStyle.graphicSizeLarge)
                    source: "qrc:/gfx/icon.svg"
                }
                ListItemText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "百度贴吧"
                    role: "Title"
                    platformInverted: tbsettings.whiteTheme
                }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "登录您的百度账号"
                platformInverted: tbsettings.whiteTheme
            }
            ListItemText {
                text: phoneNumberCheck.checked ?"手机号":"用户名或电子邮件地址"
                role: "SubTitle"
                platformInverted: tbsettings.whiteTheme
            }
            Flipable {
                id: loginFlip
                width: parent.width; height: privateStyle.textFieldHeight
                front: TextField {
                    id: userName
                    width: contentCol.width
                    placeholderText: "点击输入"
                    platformInverted: tbsettings.whiteTheme
                }
                back: TextField {
                    id: phoneNumber
                    placeholderText: "点击输入"
                    width: contentCol.width
                    platformInverted: tbsettings.whiteTheme
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegExpValidator { regExp: /\d+/ }
                }
                transform: Rotation {
                    id: flipRot
                    origin.x: loginFlip.width /2; origin.y: loginFlip.height / 2
                    axis: Qt.vector3d(0, 1, 0)
                    angle: 0
                }
                states: [
                    State {
                        name: "back"
                        PropertyChanges { target: flipRot; angle: 180 }
                        when: phoneNumberCheck.checked
                    }
                ]
                transitions: Transition {
                    NumberAnimation { target: flipRot; property: "angle"; duration: 300 }
                }
            }
            Item { width: 1; height: platformStyle.paddingLarge }
            ListItemText {
                text: "密码"
                role: "SubTitle"
                platformInverted: tbsettings.whiteTheme
            }
            TextField {
                id: passwordField
                width: parent.width
                placeholderText: "点击输入"
                platformInverted: tbsettings.whiteTheme
                echoMode: TextInput.Password
            }
            Label {
                text: "<a href=\"link\">忘记密码？</a>"
                platformInverted: tbsettings.whiteTheme
                onLinkActivated: utility.openURLDefault("https://passport.baidu.com/?getpass_index")
            }
            Item {
                implicitWidth: parent.width; implicitHeight: platformStyle.graphicSizeSmall
            }
            Button {
                id: loginBtn
                anchors {
                    left: parent.left; right: parent.right; margins: platformStyle.paddingLarge
                }
                text: "登录"
                platformInverted: tbsettings.whiteTheme
                onClicked: {
                    var u = phoneNumberCheck.checked?phoneNumber.text:userName.text
                    var p = passwordField.text
                    if ( u == "" || p == ""){
                        app.showMessage("请输入有效的用户名或密码")
                    } else
                        Script.login(loginPage.toString(), phoneNumberCheck.checked, u, p)
                }
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "尚未创建百度账号？"
                platformInverted: tbsettings.whiteTheme
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "<a href=\"link\">点此创建</a>"
                font.pixelSize: platformStyle.fontSizeSmall
                platformInverted: tbsettings.whiteTheme
                onLinkActivated: utility.openURLDefault("http://wappass.baidu.com/passport/?reg")
            }
        }
    }
}
