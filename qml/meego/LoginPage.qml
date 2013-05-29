import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "../js/main.js" as Script

Page {
    id: page;

    property bool forceLogin;
    property bool loading;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: forceLogin ? Qt.quit() : pageStack.pop();
        }
        CheckBox {
            id: phoneNumberCheck;
            anchors.centerIn: parent;
            enabled: !loading;
            text: qsTr("Use Phone Number")
        }
    }

    function login(vcode, vcodeMd5){
        if ((phoneNumberCheck.checked?phoneNumber.text.length == 0:userName.text.length == 0)||passwordField.text.length==0){
            signalCenter.showMessage(qsTr("Please input correct data"));
            return;
        }
        var opt = {
            isPhone: phoneNumberCheck.checked,
            password: passwordField.text,
            username: phoneNumberCheck.checked ? phoneNumber.text : userName.text
        }
        if (vcode){
            opt.vcode = vcode;
            opt.vcodeMd5 = vcodeMd5;
        }
        Script.login(opt);
    }

    Connections {
        target: signalCenter;
        onLoginStarted: loading = true;
        onLoginFailed: loading = false;
        onLoginFinished: {
            loading = false;
            signalCenter.showMessage(qsTr("Login Success!"));
            if (pageStack.depth > 1){
                pageStack.pop();
            } else {
                pageStack.replace(mainPage);
            }
        }
        onLoadFailed: loading = false;
        onVcodeSent: {
            if (caller == "LoginPage"){
                login(vcode, vcodeMd5);
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: qsTr("Login");
        loading: page.loading;
        enabled: false;
    }

    Flickable {
        id: flickable;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        contentWidth: parent.width;
        contentHeight: contentCol.height+constant.paddingLarge;

        Column {
            id: contentCol;
            anchors {
                left: parent.left; top: parent.top; right: parent.right;
                margins: constant.paddingXLarge;
            }
            spacing: constant.paddingLarge;
            Text {
                text: phoneNumberCheck.checked ? qsTr("Phone Number") : qsTr("ID or e-mail");
                font.pixelSize: constant.fontSizeMedium;
                color: constant.colorMid;
            }
            Flipable {
                id: loginFlip;
                width: parent.width;
                height: constant.textFieldHeight;
                front: TextField {
                    id: userName;
                    enabled: !loading;
                    width: contentCol.width;
                    placeholderText: qsTr("Tap To Input");
                }
                back: TextField {
                    id: phoneNumber;
                    enabled: !loading;
                    placeholderText: qsTr("Tap To Input");
                    width: contentCol.width;
                    inputMethodHints: Qt.ImhDialableCharactersOnly | Qt.ImhNoPredictiveText;
                }
                transform: Rotation {
                    id: flipRot;
                    origin.x: loginFlip.width / 2;
                    origin.y: loginFlip.height / 2;
                    axis: Qt.vector3d(0, 1, 0);
                    angle: 0;
                }
                states: [
                    State {
                        name: "back";
                        PropertyChanges { target: flipRot; angle: 180; }
                        when: phoneNumberCheck.checked;
                    }
                ]
                transitions: Transition {
                    NumberAnimation { target: flipRot; property: "angle"; duration: 300; }
                }
            }
            Text {
                text: qsTr("Password");
                font.pixelSize: constant.fontSizeMedium;
                color: constant.colorMid;
            }
            TextField {
                id: passwordField;
                width: parent.width;
                enabled: !loading;
                placeholderText: qsTr("Tap To Input");
                echoMode: TextInput.Password;
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;
            }
            Text {
                text: "<a href=\"link\">%1</a>".arg(qsTr("Forget Password?"))
                font.pixelSize: constant.fontSizeMedium;
                onLinkActivated: utility.openURLDefault("https://passport.baidu.com/?getpass_index");
            }
            Button {
                id: loginBtn;
                enabled: !loading;
                anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                text: qsTr("Login");
                onClicked: login();
            }
            Item { width: 1; height: 1; }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: qsTr("Don't have a Baidu Account?");
                font.pixelSize: constant.fontSizeMedium;
                color: constant.colorMid;
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "<a href=\"link\">%1</a>".arg(qsTr("Click to register"))
                onLinkActivated: utility.openURLDefault("http://wappass.baidu.com/passport/reg");
                font.pixelSize: constant.fontSizeMedium;
            }
        }
    }
}
