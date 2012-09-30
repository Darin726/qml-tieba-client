import QtQuick 1.1
import com.nokia.symbian 1.1
import Qt.labs.folderlistmodel 1.0

SelectionDialog {
    id: root

    titleText: folderListModel.folder.toString().replace("file:///","")

    model: FolderListModel {
        id: folderListModel
        nameFilters: [""]
        showOnlyReadable: true
    }
    delegate: MenuItem {
        onClicked: folderListModel.folder = filePath
        text: fileName
    }
    buttons: Item {
        id: buttonContainer
        width: parent.width
        height: privateStyle.toolBarHeightLandscape + 2 * platformStyle.paddingSmall
        function buttonWidth(){
            return (buttonContainer.width - 4 * platformStyle.paddingMedium) / 3
        }
        Row {
            id: buttonRow
            anchors.centerIn: parent
            spacing: platformStyle.paddingMedium
            ToolButton {
                width: buttonContainer.buttonWidth()
                height: privateStyle.toolBarHeightLandscape
                enabled: folderListModel.parentFolder != ""
                text: "向上"
                onClicked: folderListModel.folder = folderListModel.parentFolder
            }
            ToolButton {
                width: buttonContainer.buttonWidth()
                height: privateStyle.toolBarHeightLandscape
                text: "选择"
                enabled: folderListModel.folder != "" && folderListModel.folder != "file:"
                onClicked: {
                    tbsettings.imagePath = folderListModel.folder.toString().replace("file:///","")
                    accept()
                }
            }
            ToolButton {
                width: buttonContainer.buttonWidth()
                height: privateStyle.toolBarHeightLandscape
                text: "取消"
                onClicked: reject()
            }
        }
    }
    Component.onCompleted: {
        folderListModel.folder = "file:///"+tbsettings.imagePath
    }
    property bool opened
    onStatusChanged: {
        if (status == DialogStatus.Opening)
            opened = true
        else if (status == DialogStatus.Closed && opened)
            root.destroy()
    }
}
