import QtQuick 1.1
import com.nokia.symbian 1.1

TabButton {
    id: root
    text: tab ? tab.thread.title||"新标签" : ""
    platformInverted: tbsettings.whiteTheme
    onClicked: if (currentTab == tab) removeMenu.open()
}
