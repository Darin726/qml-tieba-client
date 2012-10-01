import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "js/main.js" as Script

Item {
    id: root

    Connections {
        target: signalCenter
        onGetMessageFailed: app.showMessage(errorString)
        onGetMessageSuccessed: {
            if (type != ""){
                banner.text = msg
                banner.infoType = type
                banner.open()
            }
        }
        onCurrentUserChanged: {
            if (Script.BDUSS == "")
                autoRenewTimer.stop()
            else
                autoRenewTimer.restart()
        }
    }
    Connections {
        target: tbsettings
        onRemindFrequencyChanged: {
            if (tbsettings.remindFrequency == 0)
                autoRenewTimer.stop()
            else if (Script.BDUSS!="")
                autoRenewTimer.restart()
        }
    }

    Timer {
        id: autoRenewTimer
        interval: tbsettings.remindFrequency
        repeat: true
        triggeredOnStart: true
        onTriggered: Script.getMessage()
    }
    InfoBanner {
        id: banner
        property string infoType
        iconSource: "qrc:/gfx/icon.svg"
        interactive: true
        platformInverted: tbsettings.whiteTheme
        timeout: 0
        onClicked: {
            if (Script.BDUSS != ""){
                switch(infoType){
                case "fans": {
                    app.pageStack.push(Qt.resolvedUrl("FriendListPage.qml"),
                                       { userId: Script.userId, type: "fans" }).getlist(true)
                    break;
                }
                case "replyme": {
                    messagePage.replyToMePage.firstStart = false
                    messagePage.replyToMePage.getlist(true)
                    app.enterMessagePage(messagePage.replyToMePage)
                    break;
                }
                case "atme": {
                    messagePage.atMePage.firstStart = false
                    messagePage.atMePage.getlist(true)
                    app.enterMessagePage(messagePage.atMePage)
                    break;
                }
                }
            }
        }
        Button {
            platformInverted: parent.platformInverted
            iconSource: privateStyle.imagePath(pressed?"qtg_graf_popup_close_pressed":"qtg_graf_popup_close_normal",
                                                        platformInverted)
            anchors {
                right: parent.right; rightMargin: platformStyle.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            onClicked: banner.close()
        }
    }
}
