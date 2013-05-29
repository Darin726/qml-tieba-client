import QtQuick 1.0
import com.nokia.symbian 1.0
import "../Component"

CustomDialog {
    id: root

    property string caller;
    property string vcodePicUrl;
    property string vcodeMd5;

    property bool __isClosing: false;

    titleText: qsTr("Please Enter Verify Code:");
    buttonTexts: [qsTr("OK"), qsTr("Cancel")];

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
                anchors.horizontalCenter: parent.horizontalCenter;
                spacing: platformStyle.paddingLarge;
                Item { width: 1; height: 1; }
                ListItemText {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    text: qsTr("Please Input These Characters");
                }
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    width: 120; height: 48;
                    Image {
                        id: pic;
                        anchors.fill: parent;
                        smooth: true;
                        source: root.vcodePicUrl;
                    }
                    BusyIndicator {
                        anchors.centerIn: parent;
                        running: true;
                        visible: pic.status == Image.Loading;
                    }
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            pic.source = "";
                            pic.source = root.vcodePicUrl;
                        }
                    }
                }
                TextField {
                    id: vcodeInput;
                    width: 150;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    placeholderText: qsTr("Input Verify Code");
                }
            }
        }
    }

    onButtonClicked: { if (index == 0){ root.accept(); }}
    onAccepted: {
        signalCenter.vcodeSent(caller, vcodeInput.text, root.vcodeMd5);
    }
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
}
