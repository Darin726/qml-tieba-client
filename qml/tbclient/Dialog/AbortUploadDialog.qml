import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: root
    titleText: "提示"
    height: 200
    acceptButtonText: "确定"
    rejectButtonText: "取消"
    message: "当前有上传任务正在进行，是否取消？"
    onAccepted: uploader.abort()
    onClickedOutside: close()

    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
