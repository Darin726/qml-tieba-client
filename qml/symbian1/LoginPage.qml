import QtQuick 1.0
import com.nokia.symbian 1.0
import "component"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool forceLogin;
    property bool loading;

    title: qsTr("Login");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: {
                if (forceLogin){
                    Qt.quit();
                } else {
                    pageStack.pop();
                }
            }
        }
        CheckBox {
            id: phoneNumberCheck;
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
                pageStack.replace(homePage);
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
        headerIcon: "gfx/sign_in.svg";
        headerText: page.title;
        loading: page.loading;
        enabled: false;
    }

    Flickable {
        id: flickable;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        contentWidth: parent.width;
        contentHeight: contentCol.height+platformStyle.paddingLarge;

        Column {
            id: contentCol;
            anchors {
                left: parent.left; top: parent.top; right: parent.right;
                margins: platformStyle.paddingLarge;
            }
            spacing: platformStyle.paddingLarge;
            ListItemText {
                text: phoneNumberCheck.checked ? qsTr("Phone Number") : qsTr("ID or e-mail");
                role: "SubTitle";
            }
            Flipable {
                id: loginFlip;
                width: parent.width;
                height: privateStyle.textFieldHeight;
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
            ListItemText {
                text: qsTr("Password");
                role: "SubTitle";
            }
            TextField {
                id: passwordField;
                width: parent.width;
                enabled: !loading;
                placeholderText: qsTr("Tap To Input");
                echoMode: TextInput.Password;
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;
            }
            Label {
                text: "<a href=\"link\">%1</a>".arg(qsTr("Forget Password?"))
                onLinkActivated: utility.openURLDefault("https://passport.baidu.com/?getpass_index");
            }
            Button {
                id: loginBtn;
                enabled: !loading;
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingLarge*3; }
                text: qsTr("Login");
                onClicked: login();
            }
            Item { width: 1; height: 1; }
            ListItemText {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: qsTr("Don't have a Baidu Account?");
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "<a href=\"link\">%1</a>".arg(qsTr("Click to register"))
                onLinkActivated: utility.openURLDefault("http://wappass.baidu.com/passport/reg");
            }
        }
    }
}
