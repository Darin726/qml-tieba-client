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
            PathView {
                id: headerView
                width: screen.width; height: screen.width/36*14
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                delegate: Item {
                    width: headerView.width; height: headerView.height
                    Image {
                        id: titleImg
                        anchors.fill: parent
                        source: modelData.pic
                        smooth: true
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
                path: Path {
                    startX: -headerView.width*headerView.count/2 + headerView.width/2
                    startY: headerView.height/2
                    PathLine {
                        x: headerView.width*headerView.count/2+headerView.width/2
                        y: headerView.height/2
                    }
                }
                Timer {
                    running: headerView.visible && headerView.count > 0 && !headerView.moving;
                    interval: 3000;
                    repeat: true
                    onTriggered: headerView.incrementCurrentIndex()
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
