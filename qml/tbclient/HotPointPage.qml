import QtQuick 1.1
import com.nokia.symbian 1.1
import CustomWebKit 1.0
import "Component"
import "js/main.js" as Script

MyPage {
    id: page
    title: "贴吧热点"
    tools: homeTools

    property bool firstStart: true
    onVisibleChanged: {
        if (visible && firstStart){
            firstStart = false
            Script.getRecommendPic()
            webView.url = "http://c.tieba.baidu.com/c/s/recommend/"
        }
    }

    Connections {
        target: signalCenter
        onGetRecommendPicFailed: app.showMessage(errorString)
        onGetRecommendPicSuccessed: headerView.model = list
    }

    Flickable {
        id: flicky
        anchors.fill: parent
        contentWidth: screen.width
        contentHeight: contentCol.height

        Column {
            id: contentCol
            width: screen.width
            ListView {
                id: headerView
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                width: screen.width; height: 140
                delegate: Item {
                    width: 360; height: 140
                    Image {
                        id: titleImg
                        anchors.fill: parent
                        sourceSize: Qt.size(width, height)
                        source: modelData.pic
                    }
                    Image {
                        anchors.centerIn: parent
                        source: titleImg.status == Image.Ready ?"":"qrc:/gfx/photos.svg"
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width; height: platformStyle.graphicSizeSmall
                        color: "#C0000000"
                        ListItemText {
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.title
                            role: "SubTitle"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: signalCenter.linkActivated("link:"+modelData.href)
                    }
                }
            }
            WebView {
                id: webView
                preferredWidth: screen.width
                preferredHeight: screen.height
                onLinkClicked: {
                    signalCenter.linkActivated("link:"+link)
                }
                settings {
                    defaultFontSize: tbsettings.fontSize
                    defaultFixedFontSize: tbsettings.fontSize
                    minimumFontSize: tbsettings.fontSize
                    minimumLogicalFontSize: tbsettings.fontSize
                }
                onLoadStarted: ind.visible = true
                onLoadFinished: ind.visible = false
                onLoadFailed: ind.visible = false
                BusyIndicator {
                    id: ind
                    anchors.centerIn: parent
                    platformInverted: true
                    width: platformStyle.graphicSizeLarge
                    height: platformStyle.graphicSizeLarge
                    running: visible
                    visible: false
                }
            }
        }
    }
}
