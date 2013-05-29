import QtQuick 1.0
import com.nokia.symbian 1.0
import "../Component"
import "../../js/main.js" as Script

CustomDialog {
    id: root;

    property string manager: "1";
    property variant param: null;

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
    titleText: qsTr("Confirm operation");
    buttonTexts: [qsTr("Ban ID"), qsTr("Cancel")];

    onButtonClicked: {
        if (index == 0) accept();
    }
    onAccepted: {
        var opt = {
            day: buttonCol.checkedButton.objectName.substring(3),
            fid: param.fid,
            ntn: "banid",
            un: param.un,
            word: param.word,
            z: param.z
        }
        Script.commitPrison(opt);
    }

    content: Item {
        width: platformContentMaximumWidth;
        height: Math.min(platformContentMaximumHeight, contentCol.height);

        Flickable {
            anchors.fill: parent;
            clip: true;
            contentWidth: parent.width;
            contentHeight: contentCol.height;
            Column {
                id: contentCol;
                width: parent.width;
                spacing: platformStyle.paddingMedium;
                Item { width: 1; height: 1; }
                Label {
                    anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                    text: param ? qsTr("User name:")+param.un : "";
                }
                Label {
                    anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                    text: qsTr("Ban period:");
                }
                ButtonColumn {
                    id: buttonCol;
                    anchors { left: parent.left; right: parent.right; margins: Math.floor(parent.width/4); }
                    spacing: platformStyle.paddingMedium;
                    Button {
                        objectName: "ban1";
                        width: parent.width;
                        text: qsTr("1 Days");
                    }
                    Button {
                        objectName: "ban3"
                        visible: manager == "1";
                        width: parent.width;
                        text: qsTr("3 Days");
                    }
                    Button {
                        objectName: "ban10";
                        visible: manager == "1";
                        width: parent.width;
                        text: qsTr("10 Days");
                    }
                }
            }
        }
    }
}
