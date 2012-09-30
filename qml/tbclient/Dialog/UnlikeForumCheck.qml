import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: root
    titleText: "提醒"
    message: "取消喜欢后，本吧经验值不再增长，权限也将收回，确认要取消吗？"
    height: 200
    acceptButtonText: "确定"
    rejectButtonText: "取消"

    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
