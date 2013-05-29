import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "Component"

Page {
    id: messagePage;

    property QtObject messageMenu: null;

    function openMenu(modelData){
        if (!messageMenu) { messageMenu = Qt.createComponent("Dialog/EnterThreadMenu.qml").createObject(messagePage); }
        messageMenu.modelData = modelData;
        messageMenu.open();
    }

    TabHeader {
        id: viewHeader;
        ThreadButton {
            tab: replyMePage;
            CountBubble {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: constant.paddingMedium; }
                value: autoCheck.replyme;
                visible: value > 0;
            }
        }
        ThreadButton {
            tab: atMePage;
            CountBubble {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: constant.paddingMedium; }
                value: autoCheck.atme;
                visible: value > 0;
            }
        }
    }

    TabGroup {
        id: tabGroup;
        anchors { fill: parent; topMargin: viewHeader.height; }
        currentTab: replyMePage;
        ReplyMePage { id: replyMePage; }
        AtMePage { id: atMePage;  }
    }
}
