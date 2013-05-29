import QtQuick 1.0
import com.nokia.symbian 1.0
import "../Component"
import "../../js/emoticon.js" as Emotion
import "../../js/storage.js" as Database

CustomDialog {
    id: root;

    property Item caller: null;
    property bool isFloor: false;
    property bool __isClosing: false;

    property variant customEmoList: [];

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
        root.close();
        signalCenter.emotionSelected(caller.toString(), "#("+n+")");
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

    titleText: qsTr("Select Emoticon");
    content: Item {
        width: platformContentMaximumWidth;
        height: platformContentMaximumHeight;
        ButtonRow {
            id: buttonRow;
            anchors {
                top: parent.top; left: parent.left; right: parent.right; margins: platformStyle.paddingMedium;
            }
            ToolButton { text: qsTr("Default"); onClicked: tabGroup.currentTab = defaultEmo; }
            ToolButton { text: qsTr("Custom"); enabled: !isFloor; onClicked: tabGroup.currentTab = customEmo; }
            ToolButton { text: qsTr("Emoticons"); onClicked: tabGroup.currentTab = textEmo; }
        }
        TabGroup {
            id: tabGroup;
            anchors {
                top: buttonRow.bottom;
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
                topMargin: platformStyle.paddingMedium;
            }
            currentTab: defaultEmo;
            GridView {
                id: defaultEmo;
                anchors.fill: parent;
                cellWidth: screen.width > screen.height ? Math.floor(parent.width/7) : Math.floor(parent.width/5);
                cellHeight: cellWidth;
                clip: true;
                model: 124;
                delegate: emoDelegate;
                Component {
                    id: emoDelegate;
                    Item {
                        width: 68; height: 68;
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
                            color: platformStyle.colorNormalMid;
                            opacity: mouseArea.pressed ? 0.3 : 0;
                        }
                    }
                }
            }
            GridView {
                id: customEmo;
                anchors.fill: parent;
                cellWidth: screen.width > screen.height ? Math.floor(parent.width/7) : Math.floor(parent.width/5);
                cellHeight: cellWidth;
                clip: true;
                model: customEmoList;
                delegate: customDel;
                Component {
                    id: customDel;
                    Item {
                        width: 68; height: 68;
                        MouseArea {
                            id: mouseArea;
                            anchors.fill: parent;
                            onClicked: {
                                root.close();
                                signalCenter.emotionSelected(caller.toString(), "#("+modelData.name+")");
                            }
                        }
                        Image {
                            sourceSize: Qt.size(46, 46);
                            anchors.centerIn: parent;
                            asynchronous: true;
                            source: "file:///"+modelData.thumbnail;
                        }
                        Rectangle {
                            anchors.fill: parent;
                            color: platformStyle.colorNormalMid;
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
                            width: label.width + platformStyle.paddingLarge*2;
                            height: platformStyle.graphicSizeMedium;
                            Label {
                                id: label;
                                anchors.centerIn: parent;
                                text: modelData;
                            }
                            MouseArea {
                                id: mouseArea;
                                anchors.fill: parent;
                                onClicked: {
                                    root.close();
                                    signalCenter.emotionSelected(caller.toString(), modelData);
                                }
                            }
                            Rectangle {
                                anchors.fill: parent;
                                color: platformStyle.colorNormalMid;
                                opacity: mouseArea.pressed ? 0.3 : 0;
                            }
                        }
                    }
                }
            }
        }
    }

    onClickedOutside: close();
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        } else if (status == DialogStatus.Open){
            if (!isFloor) {customEmoList = Database.getCustomEmo(); }
        }
    }
}
