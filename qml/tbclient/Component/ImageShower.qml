import QtQuick 1.1
import com.nokia.extras 1.1

Item {
    id: root

    Connections {
        target: manager
        onProgressChanged: {
            ind.text = "正在下载图片(点击取消):"+Math.round(manager.progress*100)+"%"
        }
        onDownloadStateChanged: {
            switch(manager.downloadState){
            case 1:
                ind.text = "正在下载图片(点击取消)..."
                break;
            case 3:
                if (manager.error == 0)
                    utility.openFileDefault("file:///"+manager.currentFile)
                break;
            case 4:
                root.destroy()
                break;
            }
        }
    }
    InfoBanner {
        id: ind
        iconSource: "qrc:/gfx/icon.svg"
        interactive: true
        platformInverted: tbsettings.whiteTheme
        timeout: 0
        Component.onCompleted: open()
        Component.onDestruction: close()
        onClicked: manager.abortDownload()
    }
}
