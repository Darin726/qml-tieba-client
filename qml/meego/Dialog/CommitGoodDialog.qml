import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/main.js" as Script

SelectionDialog {
    id: root;

    property variant param: null;
    property variant catelist: [];

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: {
        catelist.forEach(function(value){ listModel.append(value) });
        open();
    }

    titleText: qsTr("Classify this thread to");
    model: ListModel { id: listModel; }

    onAccepted: {
        var opt = {
            cid: listModel.get(selectedIndex).id,
            fid: root.param.fid,
            ntn: "set",
            word: root.param.word,
            z: root.param.z
        }
        Script.commitGood(opt);
    }
}
