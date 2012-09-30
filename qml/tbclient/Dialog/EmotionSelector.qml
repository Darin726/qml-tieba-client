import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/EmotionData.js" as Emotion

CommonDialog {
    id: root

    titleText: "选择表情(最多可添加10个)"

    content: GridView {
        anchors.horizontalCenter: parent.horizontalCenter
        width: screen.width > screen.height ? 7*68 : 5*68
        height: 3*68
        cellHeight: 68
        cellWidth: 68
        model: 110
        delegate: MouseArea {
            width: 68; height: 68
            onClicked: {
                var n = ""
                if (index<50)
                    n = Emotion.emotion_name[index]
                else if (index<70)
                    n = Emotion.ali_name[index-50]
                else if (index<90)
                    n = Emotion.yz_name[index-70]
                else
                    n = Emotion.b_name[index-90]
                signalCenter.emotionSelected(root.parent.toString(), "#("+n+")")
            }
            Image {
                anchors.centerIn: parent
                source: "qrc:/pics/"+(
                            index<1?"image_emoticon":
                            index<50?"image_emoticon"+(index+1):
                            index<70?"e_ali_0"+Emotion.ali_file[index-50]:
                            index<90?"e_yz_"+paddingLeft(Emotion.yz_file[index-70],3):
                                      "e_b"+paddingLeft(index-89,2)
                            )+".png"
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
