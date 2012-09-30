import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

Page {
    id: page

    property Item forumPage

    property variant imageinfo
    property string imageurl

    property bool loading

    function post(vcode, vcodeMd5){
        if (titleArea.text == "")
            return app.showMessage("请输入贴子标题")
        if (page.imageurl != "" && !page.imageinfo)
            return signalCenter.postImage(page.toString(), page.imageurl)

        var cont = contentArea.text
        if (page.imageinfo)
            cont += "\n#(pic,"+imageinfo.pic_id+","+imageinfo.width+","+imageinfo.height+")"

        Script.postArticle(page, titleArea.text, cont, forumPage.forum, vcode, vcodeMd5)
    }

    Connections {
        target: signalCenter
        onEmotionSelected: {
            if (caller == page.toString()){
                var pos = contentArea.cursorPosition
                var str1 = contentArea.text.slice(0, pos)
                var str2 = contentArea.text.slice(pos)
                contentArea.text = str1 + name + str2
                contentArea.cursorPosition = pos + name.length
            }
        }
        onImageSelected: {
            if (caller == page.toString()){
                page.imageurl = url
            }
        }
        onFriendSelected: {
            if (caller == page.toString()){
                var pos = contentArea.cursorPosition
                var str1 = contentArea.text.slice(0, pos)
                var str2 = contentArea.text.slice(pos)
                contentArea.text = str1 + name + str2
                contentArea.cursorPosition = pos + name.length
            }
        }
        onUploadFinished: {
            if (caller == page.toString()){
                page.imageinfo = info
                post()
            }
        }
        onVcodeSent: {
            if (caller == page.toString()){
                post(vcode, vcodeMd5)
            }
        }
        onPostArticleStarted: {
            if (caller == page.toString()){
                loading = true
            }
        }
        onPostArticleFailed: {
            if (caller == page.toString()){
                loading = false
                app.showMessage(errorString)
            }
        }
        onPostArticleSuccessed: {
            if (caller == page.toString()){
                loading = false
                app.showMessage("发送成功·")
                forumPage.pageNumber = 1
                forumPage.internal.getList()
                pageStack.pop()
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        ButtonRow {
            exclusive: false
            property bool platformInverted
            ToolButton {
                platformInverted: parent.platformInverted
                iconSource: "qrc:/gfx/write_face_%1.png".arg(pressed?"s":"n")
                onClicked: {
                    var diag = Qt.createComponent("Dialog/EmotionSelector.qml").createObject(page)
                    diag.open()
                }
            }
            ToolButton {
                platformInverted: parent.platformInverted
                iconSource: "qrc:/gfx/write_at_%1.png".arg(pressed?"s":"n")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Component/FriendSelector.qml"), { caller: page })
                }
            }
            ToolButton {
                platformInverted: parent.platformInverted
                iconSource: "qrc:/gfx/write_image_%1.png".arg(pressed?"s":"n")
                onClicked: {
                    var diag = Qt.createComponent("Dialog/ImageSelectorDialog.qml").createObject(page)
                    diag.open()
                }
            }
        }
        ToolButton {
            iconSource: "qrc:/gfx/ok%1.svg".arg(platformInverted?"_inverted":"")
            enabled: !loading
            onClicked: post()
        }
    }

    ViewHeader {
        id: viewHeader
        headerText: "发新贴"
        visible: height > 0
        height: screen.width < screen.height ? privateStyle.tabBarHeightPortrait : 0
    }
    TextField {
        id: titleArea
        anchors {
            left: parent.left; right: parent.right; top: viewHeader.bottom
            margins: platformStyle.paddingMedium
        }
        placeholderText: "标题（必填）"
        maximumLength: 31
        platformInverted: tbsettings.whiteTheme
    }
    TextArea {
        id: contentArea
        anchors {
            left: parent.left; right: parent.right; top: titleArea.bottom; bottom: previewLoader.top
            margins: platformStyle.paddingMedium
        }
        placeholderText: "内容"
        platformInverted: tbsettings.whiteTheme
    }
    Loader {
        id: previewLoader
        width: parent.width
        height: sourceComponent == undefined ? 0 : platformStyle.graphicSizeMedium
        anchors.bottom: parent.bottom
        sourceComponent: page.imageurl == "" ? undefined : imagePreviewComp
        Behavior on height {
            NumberAnimation { duration: 150 }
        }
    }
    Component {
        id: imagePreviewComp
        Item {
            Image {
                sourceSize: Qt.size(platformStyle.graphicSizeMedium,
                                    platformStyle.graphicSizeMedium)
                source: page.imageurl
            }
            Button {
                text: "清除"
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                platformInverted: tbsettings.whiteTheme
                enabled: uploader.currentCaller != page.toString() || uploader.uploadState != 2
                onClicked: {
                    page.imageinfo = undefined
                    page.imageurl = ""
                }
            }
            ProgressBar {
                platformInverted: tbsettings.whiteTheme
                anchors.centerIn: parent
                value: {
                    if (page.imageinfo)
                        return 1
                    if (uploader.currentCaller == page.toString())
                        return uploader.progress
                    return 0
                }
            }
        }
    }
}
