import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/main.js" as Script

Item {
    id: root

    property Item threadPage: parent ? parent.parent : null
    property string floorNum
    property string quoteId

    property variant imageinfo
    property string imageurl

    function postReply(vcode, vcodeMd5){
        if (textArea.text == "" && root.imageurl == "")
            return app.showMessage("请输入回复内容")
        if (root.imageurl != "" && !root.imageinfo)
            return signalCenter.postImage(root.toString(), root.imageurl)
        var cont = textArea.text
        if (root.imageinfo)
            cont += "\n#(pic,"+imageinfo.pic_id+","+imageinfo.width+","+imageinfo.height+")"
        Script.postReply(root, cont, threadPage.forum, threadPage.threadId, floorNum, quoteId, vcode, vcodeMd5)
    }
    Connections {
        target: signalCenter
        onEmotionSelected: {
            if (caller == root.toString()){
                var pos = textArea.cursorPosition
                var str1 = textArea.text.slice(0, pos)
                var str2 = textArea.text.slice(pos)
                textArea.text = str1 + name + str2
                textArea.cursorPosition = pos + name.length
            }
        }
        onImageSelected: {
            if (caller == root.toString()){
                root.imageurl = url
            }
        }
        onFriendSelected: {
            if (caller == root.toString()){
                var pos = textArea.cursorPosition
                var str1 = textArea.text.slice(0, pos)
                var str2 = textArea.text.slice(pos)
                textArea.text = str1 + name + str2
                textArea.cursorPosition = pos + name.length
            }
        }
        onUploadFinished: {
            if (caller == root.toString()){
                root.imageinfo = info
                postReply()
            }
        }
        onVcodeSent: {
            if (caller == root.toString()){
                postReply(vcode, vcodeMd5)
            }
        }
        onPostReplyStarted: {
            if (caller == root.toString()){
                threadPage.loading = true
            }
        }
        onPostReplyFailed: {
            if (caller == root.toString()){
                threadPage.loading = false
                app.showMessage(errorString)
            }
        }
        onPostReplySuccessed: {
            if (caller == root.toString()){
                threadPage.loading = false
                app.showMessage("回复成功")
                app.multiThread(function(){
                                    if (threadPage.isReverse && !threadPage.hasPrev) threadPage.loadPrev()
                                    else if (!threadPage.isReverse && !threadPage.hasMore) threadPage.loadMore()
                                    threadPage.state = ""
                                })
            }
        }
        onLoadFailed: threadPage.loading = false;
    }
    Loader {
        sourceComponent: root.imageurl == "" ? undefined : imagePreviewComp
    }
    Component {
        id: imagePreviewComp
        Row {
            Image {
                sourceSize: Qt.size(buttonRow.height, buttonRow.height)
                source: root.imageurl
            }
            Button {
                platformInverted: tbsettings.whiteTheme
                enabled: uploader.currentCaller != root.toString() || uploader.uploadState != 2
                text: enabled ? "清除" : Math.floor(uploader.progress*100)+"%"
                onClicked: {
                    root.imageinfo = undefined
                    root.imageurl = ""
                }
            }
        }
    }

    Row {
        id: buttonRow
        anchors.right: parent.right
        spacing: platformStyle.paddingMedium
        Button {
            platformInverted: tbsettings.whiteTheme
            iconSource: "qrc:/gfx/write_face_%1.png".arg(pressed?"s":"n")
            onClicked: {
                var diag = Qt.createComponent("../Dialog/EmotionSelector.qml").createObject(root)
                diag.open()
            }
        }
        Button {
            platformInverted: tbsettings.whiteTheme
            iconSource: "qrc:/gfx/write_at_%1.png".arg(pressed?"s":"n")
            onClicked: {
                app.pageStack.push(Qt.resolvedUrl("FriendSelector.qml"), { caller: root })
            }
        }
        Button {
            platformInverted: tbsettings.whiteTheme
            iconSource: "qrc:/gfx/write_image_%1.png".arg(pressed?"s":"n")
            onClicked: {
                var diag = Qt.createComponent("../Dialog/ImageSelectorDialog.qml")
                .createObject(root, { caller: root })
                diag.open()
            }
        }
    }

    TextArea {
        id: textArea
        platformInverted: tbsettings.whiteTheme
        anchors {
            fill: parent; topMargin: buttonRow.height
        }
    }
}
