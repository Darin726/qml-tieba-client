import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root

    privateCloseIcon: true
    titleText: "关于"

    height: 350

    content: Flickable {
        anchors {
            fill: parent; margins: platformStyle.paddingLarge
        }
        clip: true
        contentWidth: width
        contentHeight: contentCol.height

        Column {
            id: contentCol
            width: parent.width
            spacing: platformStyle.paddingMedium

            Row {
                spacing: platformStyle.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    source: "qrc:/gfx/icon.svg"
                    sourceSize: Qt.size(platformStyle.graphicSizeLarge,
                                        platformStyle.graphicSizeLarge)
                }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: "百度贴吧Qt版"
                    }
                    ListItemText {
                        role: "SubTitle"
                        text: "版本号"+tbsettings.appVersion
                    }
                }
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: "由个人编写的贴吧非官方客户端。<br/><br/>"
                      +"功能建议及bug提交：<a href='link:http://tieba.baidu.com/p/1543868126'>请到此回贴</a><br/>"
                      +"项目主页：<a href='link:http://code.google.com/p/qml-tieba-client/'>Google Code</a>"
                onLinkActivated: {
                    close()
                    signalCenter.linkActivated(link)
                }
            }
            ListItemText {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                role: "SubTitle"
                text: "\n让志同道合的人相聚在贴吧！\nby Yeatse CC 2012"
            }
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
