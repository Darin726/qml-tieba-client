import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/EmotionData.js" as Emotion
import "../js/storage.js" as Database

CommonDialog {
    id: root

    titleText: "选择表情(最多可添加10个)"
    property variant customEmo: []
    property bool inSubfloor: false
    Component.onCompleted: {
        if (!inSubfloor){
            customEmo = Database.getCustomEmo()
        }
    }

    function getEmoSrc(index){
        if (index < 1){
            return "qrc:/emo/pics/image_emoticon.png"
        } else if (index < 50){
            return "qrc:/emo/pics/image_emoticon"+(index+1)+".png"
        } else if (index < 70){
            return "qrc:/emo/pics/ali_0"+Emotion.ali_file[index-50] + ".png"
        } else if (index < 90){
            return "qrc:/emo/pics/yz_"+paddingLeft(Emotion.yz_file[index-70], 3)+".png"
        } else if (index < 110){
            return "qrc:/emo/pics/b"+paddingLeft(index-89,2)+".png"
        } else {
            return customEmo[index-110].thumbnail
        }
    }

    function itemClicked(index){
        var n = ""
        if (index<50)
            n = Emotion.emotion_name[index]
        else if (index<70)
            n = Emotion.ali_name[index-50]
        else if (index<90)
            n = Emotion.yz_name[index-70]
        else if (index<110)
            n = Emotion.b_name[index-90]
        else
            n = customEmo[index-110].name
        signalCenter.emotionSelected(root.parent.toString(), "#("+n+")")
    }

    content: GridView {
        anchors.horizontalCenter: parent.horizontalCenter
        width: screen.width > screen.height ? 7*68 : 5*68
        height: 3*68
        cellHeight: 68
        cellWidth: 68
        model: 110+customEmo.length
        delegate: MouseArea {
            width: 68; height: 68
            onClicked: root.itemClicked(index)
            Image {
                anchors.centerIn: parent
                asynchronous: true;
                source: root.getEmoSrc(index)
            }
            Rectangle {
                anchors.fill: parent
                color: platformStyle.colorNormalMid
                opacity: parent.pressed ? 0.3 : 0
            }
        }
    }
    function paddingLeft(number, length){
        var n = ""
        for (var i=0;i<length;i++)
            n += "0"
        return String(Number(1+n)+number).slice(1)
    }
    onClickedOutside: close()
    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
