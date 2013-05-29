import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"

MyPage {
    id: messagePage;

    property QtObject messageMenu: null;

    function openMenu(modelData){
        if (!messageMenu) { messageMenu = Qt.createComponent("Dialog/EnterThreadMenu.qml").createObject(messagePage); }
        messageMenu.modelData = modelData;
        messageMenu.open();
    }

    tools: mainTools;
    title: tabGroup.currentTab.title;

    TabHeader {
        id: viewHeader;
        ThreadButton {
            tab: replyMePage;
            Bubble {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: platformStyle.paddingMedium; }
                text: autoCheck.replyme > 20 ? "20+" : autoCheck.replyme;
                visible: autoCheck.replyme > 0;
            }
        }
        ThreadButton {
            tab: atMePage;
            Bubble {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: platformStyle.paddingMedium; }
                text: autoCheck.atme > 20 ? "20+" : autoCheck.atme;
                visible: autoCheck.atme > 0;
            }
        }
    }

    TabGroup {
        id: tabGroup;
        anchors { fill: parent; topMargin: viewHeader.height; }
        ReplyMePage { id: replyMePage; }
        AtMePage { id: atMePage;  }
    }
}
