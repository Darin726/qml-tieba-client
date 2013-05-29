import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../js/main.js" as Script

Item {
    id: root;

    property int fans: 0;
    property int replyme: 0;
    property int atme: 0;
    onFansChanged: coldDownTimer.restart();
    onReplymeChanged: coldDownTimer.restart();
    onAtmeChanged: coldDownTimer.restart();

    Connections {
        target: signalCenter;
        onMessageReceived: {
            if (tbsettings.remindFans) root.fans = fans;
            if (tbsettings.remindReplyme) root.replyme = replyme;
            if (tbsettings.remindAtme) root.atme = atme;
        }
        onUserChanged: {
            if (Script.BDUSS.length > 0){
                autocheckTimer.restart();
            } else {
                autocheckTimer.stop();
            }
        }
    }

    QtObject {
        id: internal;

        function displyMessage(){
            var displayList = [];
            if (fans > 0){
                displayList.push(qsTr("%1 new fans").arg(fans));
            }
            if (replyme > 0){
                displayList.push(qsTr("%1 new replies").arg(replyme));
            }
            if (atme > 0){
                displayList.push(qsTr("%1 new reminds").arg(atme));
            }
            if (displayList.length > 0){
                utility.showGlobalNote(displayList.join("\n"));
            } else {
                utility.clearGlobalNotes()
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

    Timer {
        id: coldDownTimer;
        interval: 200;
        onTriggered: internal.displyMessage();
    }
}
