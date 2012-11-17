import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/main.js" as Script

CommonDialog {
    id: root

    property string userName
    property Item caller

    titleText: "封禁操作"
    buttonTexts: ["封ID","取消"]

    content: Column {
        id: column
        anchors {
            left: parent.left; right: parent.right;
            margins: platformStyle.paddingLarge
        }
        spacing: platformStyle.paddingMedium
        Item { width: 1; height: 1 }
        Label {
            text: "用户名："+userName
        }
        Label {
            text: "封禁时长："
        }
        ButtonColumn {
            id: buttonColumn
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: day1
                width: Math.floor(column.width / 2)
                text: "1天"
            }
            Button {
                id: day3
                visible: manageGroup == 1
                width: Math.floor(column.width / 2)
                text: "3天"
            }
            Button {
                visible: manageGroup == 1
                width: Math.floor(column.width / 2)
                text: "10天"
            }
        }
    }

    onButtonClicked: {
        if (index == 0){
            var days = buttonColumn.checkedButton == day1
                    ? 1
                    : buttonColumn.checkedButton == day3
                      ? 3
                      : 10
            Script.commitprison(caller, userName, days)
        }
    }

    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
