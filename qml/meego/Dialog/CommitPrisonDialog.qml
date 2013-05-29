import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/main.js" as Script

SelectionDialog {
    id: root;

    property string manager: "1";
    property variant param: null;

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        } else if (status == DialogStatus.Opening){
            loadModel();
        }
    }
    Component.onCompleted: open();

    titleText: param ? qsTr("User name:")+param.un : qsTr("Confirm operation");

    model: ListModel { id: listModel; }

    function loadModel(){
        listModel.append({"name": qsTr("1 Days"), "days": 1});
        if (manager == "1"){
            listModel.append({"name": qsTr("3 Days"), "days": 3});
            listModel.append({"name": qsTr("10 Days"), "days": 10});
        }
    }

    onAccepted: {
        var opt = {
            day: model.get(selectedIndex).days,
            fid: param.fid,
            ntn: "banid",
            un: param.un,
            word: param.word,
            z: param.z
        }
        Script.commitPrison(opt);
    }
}
