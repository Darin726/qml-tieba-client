import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/main.js" as Script

SelectionDialog {
    id: root;

    property variant param: null;
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
    titleText: qsTr("Classify this thread to");
    delegate: MenuItem {
        text: modelData.name;
        onClicked: {
            selectedIndex = index;
            root.accept();
        }
    }
    onAccepted: {
        var opt = {
            cid: model[selectedIndex].id,
            fid: root.param.fid,
            ntn: "set",
            word: root.param.word,
            z: root.param.z
        }
        Script.commitGood(opt);
    }
}
