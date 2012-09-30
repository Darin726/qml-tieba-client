import QtQuick 1.1
import com.nokia.symbian 1.1

SelectionDialog {
    id: root
    titleText: "精品区"
    buttonTexts: ["全部帖子"]
    delegate: MenuItem {
        text: class_name
        onClicked: {
            isGood = true
            internal.getList(class_id)
            root.accept()
        }
    }
    onButtonClicked: {
        isGood = false
        pageNumber = 1
        internal.getList()
    }
    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
