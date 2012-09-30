import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: root

    title: "复制内容"

    property variant sourceObject
    onSourceObjectChanged: {
        for (var i in sourceObject){
            var o = sourceObject[i]
            if (o.type == 3){
                textArea.text += o.src + "\n"
            } else {
                textArea.text += o.text || ""
            }
        }
    }
    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        ToolButton {
            text: "全选"; onClicked: textArea.selectAll()
        }
        ToolButton {
            text: "复制";
            onClicked: {
                textArea.copy(); app.showMessage("已复制到剪贴板")
            }
        }
    }
    TextArea {
        id: textArea
        anchors {
            fill: parent; margins: platformStyle.paddingLarge
        }
    }
}
