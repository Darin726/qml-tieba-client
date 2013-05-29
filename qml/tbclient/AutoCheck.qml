import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import Vibra 1.0
import "../js/main.js" as Script

Item {
    id: root;

    property int fans: 0;
    property int replyme: 0;
    property int atme: 0;

    Connections {
        target: signalCenter;
        onMessageReceived: {
            if (tbsettings.remindFans) root.fans = fans;
            if (tbsettings.remindReplyme) root.replyme = replyme;
            if (tbsettings.remindAtme) root.atme = atme;
            internal.displyMessage();
        }
        onUserChanged: {
            if (Script.BDUSS.length > 0){
                autocheckTimer.restart();
            } else {
                autocheckTimer.stop();
            }
        }
    }

    Connections {
        target: Qt.application;
        onActiveChanged: {
            if (Qt.application.active){ internal.displyMessage(); }
        }
    }

    QtObject {
        id: internal;

        function displyMessage(){
            var displayList = [];
            if (fans > 0){
                infoBanner.infoType = "fans";
                displayList.push(qsTr("%1 new fans").arg(fans));
            }
            if (replyme > 0){
                infoBanner.infoType = "replyme";
                displayList.push(qsTr("%1 new replies").arg(replyme));
            }
            if (atme > 0){
                infoBanner.infoType = "atme";
                displayList.push(qsTr("%1 new reminds").arg(atme));
            }
            if (displayList.length > 0){
                if (Qt.application.active) {
                    infoBanner.text = displayList.join("\n");
                    infoBanner.open();
                } else if (tbsettings.remindBackground){
                    displayList.unshift(qsTr("TBClient:"));
                    utility.showGlobalNote(displayList.join("\n"));
                    vibra.start(800);
                }
            }
        }

        function infoBannerClicked(){
            if (infoBanner.infoType == "replyme"||infoBanner.infoType == "atme"){
                messageToolButton.clicked();
            } else if (infoBanner.infoType == "fans"){
                var p = pageStack.push(Qt.resolvedUrl("FriendListPage.qml"), { type:"fans" });
                p.getlist();
            }
        }
    }

    Timer {
        id: autocheckTimer;
        interval: tbsettings.remindBackground||Qt.application.active ? tbsettings.remindFrequency*60*1000 : 0;
        repeat: true;
        triggeredOnStart: true;
        onTriggered: Script.getMessage();
    }

    Vibra { id: vibra; }

    InfoBanner {
        id: infoBanner;
        property string infoType: "replyme";
        iconSource: "gfx/tb_mini.svg";
        interactive: true;
        platformInverted: tbsettings.whiteTheme;
        onClicked: internal.infoBannerClicked();
    }
}
