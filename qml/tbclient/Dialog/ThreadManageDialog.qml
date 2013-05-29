import QtQuick 1.1
import com.nokia.symbian 1.1
import "../../js/main.js" as Script

SelectionDialog {
    id: root;

    property variant page: null;
    titleText: qsTr("Thread Manage");

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
    Component.onCompleted: open();

    model: page != null && page.user.is_manager == 1
           ? [qsTr("Delete this thread"),qsTr("Commit to top"), qsTr("Commit from top"), qsTr("Commit to Boutique"), qsTr("Commit from Boutique")]
           : [qsTr("Delete this thread")];
    onAccepted: {
        var opt = { fid: page.forum.id, word: page.forum.name, z: page.thread.id }
        switch (root.selectedIndex){
        case 0:{
            Script.deleteThread(page, opt);
            break;
        }
        case 1: {
            opt.ntn = "set";
            Script.commitTop(opt);
            break;
        }
        case 2: {
            opt.ntn = "";
            Script.commitTop(opt);
            break;
        }
        case 3: {
            Script.getGoodList(opt);
            break;
        }
        case 4: {
            opt.ntn = "";
            Script.commitGood(opt);
            break;
        }
        }
    }
}
