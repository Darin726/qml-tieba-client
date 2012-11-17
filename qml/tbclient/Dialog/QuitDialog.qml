import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: root
    titleText: "退出程序"
    height: platformStyle.graphicSizeMedium
    message: "要走啦？"
    acceptButtonText: "是啊"
    rejectButtonText: "不嘛"
    onAccepted: {
        Qt.quit()
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
