import QtQuick 1.1
import com.nokia.symbian 1.1
import CustomWebKit 1.0
import "Component"
import "js/main.js" as Script

MyPage {
    id: root

    title: myView ? myView.parent.thread.title : "阅读"

    property int currentIndex
    property ListView myView
    onCurrentIndexChanged: flick.contentY = 0

    onStatusChanged:  {
        if (status == PageStatus.Active)
            root.forceActiveFocus()
    }
    Keys.onPressed: {
        switch(event.key){
        case Qt.Key_Left: if (currentIndex>0) currentIndex --; event.accepted = true; break;
        case Qt.Key_Right: if (myView && currentIndex < myView.model.count -1) currentIndex ++; event.accepted = true; break;
        case Qt.Key_Up: flick.contentY -= Math.min(flicky.height, flicky.contentY); event.accepted = true; break;
        case Qt.Key_Down: flick.contentY += Math.min(flick.contentHeight-flick.contentY-flick.height,
                                                             flick.height); event.accepted = true; break;
        case Qt.Key_Backspace: pageStack.pop(); event.accepted = true; break;
        }
    }
    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                try {
                    myView.positionViewAtIndex(currentIndex, ListView.Beginning)
                }catch(e){}
                pageStack.pop()
            }
        }
        ToolButton {
            text: "上一页"
            enabled: currentIndex > 0
            onClicked: currentIndex --
        }
        ToolButton {
            text: "下一页"
            enabled: myView ? currentIndex < myView.model.count - 1 : false
            onClicked: currentIndex ++
        }
        ToolButton {
            iconSource: "qrc:/gfx/add_bookmark%1.svg".arg(platformInverted?"_inverted":"")
            onClicked: {
                var page = myView.parent
                app.addBookmark(page.threadId, myView.model.get(currentIndex).data.id, page.thread.author.name_show, page.thread.title, page.isLz)
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "#EBDCBD"
    }
    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentCol.height
        Column {
            id: contentCol
            width: parent.width
            ListHeading {
                id: header
                platformInverted: tbsettings.whiteTheme
                Label {
                    anchors {
                        left: parent.paddingItem.left; top: parent.paddingItem.top
                    }
                    text: myView ? myView.model.get(currentIndex).data.author.name_show : ""
                    platformInverted: parent.platformInverted
                }
                Label {
                    anchors {
                        right: parent.paddingItem.right; top: parent.paddingItem.top
                    }
                    text: myView ? myView.model.get(currentIndex).data.floor+"楼" : ""
                    platformInverted: parent.platformInverted
                }
            }
            WebView {
                width: parent.width
                preferredWidth: width
                preferredHeight: flick.height - header.height
                html: myView
                      ? "<style type=\"text/css\">body{background-color:#EBDCBD}img{max-width: 300px}</style>"
                        +"<body>"
                        +Script.decodeThreadContent(myView.model.get(currentIndex).data.content)
                        +"</body>"
                      : ""
                settings {
                    defaultFontSize: tbsettings.fontSize
                    defaultFixedFontSize: tbsettings.fontSize
                    minimumFontSize: tbsettings.fontSize
                    minimumLogicalFontSize: tbsettings.fontSize
                }
                onLinkClicked: signalCenter.linkActivated(link)
            }
        }
    }
    ScrollBar {
        anchors.right: parent.right
        flickableItem: flick
    }
}
