import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/emoticon.js" as Emotion
import "../../js/storage.js" as Database

Sheet {
    id: root;

    property Item caller: null;

    property bool isFloor: false;
    property bool __isClosing: false;

    property variant customEmoList: [];

    property int __isPage;  //to make sheet happy

    function defaultEmoClicked(index){
        var n = "";
        if (index < 50){
            n = Emotion.emotion_name[index];
        } else if (index < 70){
            n = Emotion.ali_name[index-50];
        } else if (index < 90){
            n = Emotion.yz_name[index-70];
        } else if (index < 110){
            n = Emotion.b_name[index-90];
        } else {
            n = Emotion.she_name[index-110];
        }
        signalCenter.emotionSelected(caller.toString(), "#("+n+")");
        root.accept();
    }
    function getDefaultEmo(index){
        if (index < 1){
            return Qt.resolvedUrl("../../emo/image_emoticon.png");
        } else if (index < 50){
            return Qt.resolvedUrl("../../emo/image_emoticon"+(index+1)+".png");
        } else if (index < 70){
            return Qt.resolvedUrl("../../emo/ali_0"+Emotion.ali_file[index-50]+".png");
        } else if (index < 90){
            return Qt.resolvedUrl("../../emo/yz_"+paddingLeft(Emotion.yz_file[index-70], 3)+".png");
        } else if (index < 110){
            return Qt.resolvedUrl("../../emo/b"+paddingLeft(index-89, 2)+".png");
        } else {
            return Qt.resolvedUrl("../../emo/she_"+paddingLeft(index-109,3)+".png");
        }
    }
    function paddingLeft(number, length){
        var n = ""
        for (var i=0;i<length;i++)
            n += "0"
        return String(Number(1+n)+number).substring(1);
    }

    acceptButtonText: qsTr("Finish");

    title: Text {
        anchors { left: parent.left; leftMargin: constant.paddingXLarge; verticalCenter: parent.verticalCenter; }
        font.pixelSize: constant.fontSizeXXLarge;
        color: constant.colorLight;
        text: qsTr("Select Emoticon");
    }

    content: Item {
        anchors.fill: parent;
        ButtonRow {
            id: buttonRow;
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: constant.paddingLarge; }
            Button { text: qsTr("Default"); onClicked: tabGroup.currentTab = defaultEmo; }
            Button { text: qsTr("Custom"); enabled: !isFloor; onClicked: tabGroup.currentTab = customEmo; }
            Button { text: qsTr("Emoticons"); onClicked: tabGroup.currentTab = textEmo; }
        }
        TabGroup {
            id: tabGroup;
            anchors {
                top: buttonRow.bottom;
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
                topMargin: constant.paddingMedium;
            }
            currentTab: defaultEmo;
            GridView {
                id: defaultEmo;
                anchors.fill: parent;
                cellWidth: app.inPortrait ? Math.floor(parent.width/5) : Math.floor(parent.width/7);
                cellHeight: cellWidth;
                clip: true;
                model: 124;
                delegate: emoDelegate;
                Component {
                    id: emoDelegate;
                    Item {
                        implicitWidth: GridView.view.cellWidth;
                        implicitHeight: GridView.view.cellHeight;
                        MouseArea {
                            id: mouseArea;
                            anchors.fill: parent;
                            onClicked: defaultEmoClicked(index);
                        }
                        Image {
                            anchors.centerIn: parent;
                            asynchronous: true;
                            source: getDefaultEmo(index);
                        }
                        Rectangle {
                            anchors.fill: parent;
                            color: constant.colorMid;
                            opacity: mouseArea.pressed ? 0.3 : 0;
                        }
                    }
                }
            }
            GridView {
                id: customEmo;
                anchors.fill: parent;
                cellWidth: app.inPortrait ? Math.floor(parent.width/5) : Math.floor(parent.width/7);
                cellHeight: cellWidth;
                clip: true;
                model: customEmoList;
                delegate: customDel;
                Component {
                    id: customDel;
                    Item {
                        implicitWidth: GridView.view.cellWidth;
                        implicitHeight: GridView.view.cellHeight;
                        MouseArea {
                            id: mouseArea;
                            anchors.fill: parent;
                            onClicked: {
                                signalCenter.emotionSelected(caller.toString(), "#("+modelData.name+")");
                                root.accept();
                            }
                        }
                        Image {
                            sourceSize: Qt.size(46, 46);
                            anchors.centerIn: parent;
                            asynchronous: true;
                            source: modelData.thumbnail;
                        }
                        Rectangle {
                            anchors.fill: parent;
                            color: constant.colorMid;
                            opacity: mouseArea.pressed ? 0.3 : 0;
                        }
                    }
                }
            }
            Flickable {
                id: textEmo;
                anchors.fill: parent;
                contentWidth: parent.width;
                contentHeight: flow.height;
                clip: true;
                Flow {
                    id: flow;
                    width: parent.width;
                    Repeater {
                        model: Emotion.emo_text;
                        Item {
                            width: label.width + constant.paddingLarge*2;
                            height: constant.graphicSizeMedium;
                            Text {
                                id: label;
                                anchors.centerIn: parent;
                                text: modelData;
                                font.pixelSize: constant.fontSizeMedium;
                                color: constant.colorLight;
                            }
                            MouseArea {
                                id: mouseArea;
                                anchors.fill: parent;
                                onClicked: {
                                    signalCenter.emotionSelected(caller.toString(), modelData);
                                    root.accept();
                                }
                            }
                            Rectangle {
                                anchors.fill: parent;
                                color: constant.colorMid;
                                opacity: mouseArea.pressed ? 0.3 : 0;
                            }
                        }
                    }
                }
            }
        }
    }

    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(500);
        } else if (status == DialogStatus.Open){
            if (!isFloor) {customEmoList = Database.getCustomEmo(); }
        }
    }
    Component.onCompleted: open();
}
