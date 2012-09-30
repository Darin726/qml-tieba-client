import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

MyPage {
    id: settingPage
    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
    }
    title: "设置中心"

    Flickable {
        id: flick
        anchors {
            fill: parent; leftMargin: platformStyle.paddingMedium; rightMargin: platformStyle.paddingMedium
        }
        contentWidth: width
        contentHeight: contentCol.height
        Column {
            id: contentCol
            width: parent.width
            MenuItem {
                width: screen.width; anchors.horizontalCenter: parent.horizontalCenter
                platformInverted: tbsettings.whiteTheme
                ListItemText {
                    anchors.centerIn: parent
                    text: "关于此程序"
                    platformInverted: tbsettings.whiteTheme
                }
                onClicked: Qt.createComponent("Dialog/AboutAppDialog.qml").createObject(settingPage).open()
            }
            SectionLabel { label: "功能" }

            ButtonRow {
                exclusive: false; onVisibleChanged: checkedButton = null
                width: parent.width
                Button {
                    platformInverted: tbsettings.whiteTheme
                    iconSource: platformInverted ? "qrc:/gfx/switch_windows_inverted.svg"
                                                 : "qrc:/gfx/switch_windows.svg"
                    onClicked: pageStack.push(threadGroupPage)
                }
                Button {
                    platformInverted: tbsettings.whiteTheme
                    iconSource: platformInverted ? "qrc:/gfx/bookmark_inverted.svg"
                                                 : "qrc:/gfx/bookmark.svg"
                    onClicked: pageStack.push(Qt.resolvedUrl("BookMarkPage.qml"))
                }
                Button {
                    platformInverted: tbsettings.whiteTheme
                    iconSource: platformInverted ? "qrc:/gfx/sign_in_inverted.svg"
                                                 : "qrc:/gfx/sign_in.svg"
                    onClicked: pageStack.push(Qt.resolvedUrl("AccountPage.qml"))
                }
            }

            SectionLabel { label: "外观" }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "主题风格:"
                platformInverted: tbsettings.whiteTheme
            }
            ButtonRow {
                width: parent.width
                exclusive: false
                Button {
                    text: "亮"; platformInverted: tbsettings.whiteTheme; checked: tbsettings.whiteTheme; onClicked: tbsettings.whiteTheme = true
                }
                Button {
                    text: "暗"; platformInverted: tbsettings.whiteTheme; checked: !tbsettings.whiteTheme; onClicked: tbsettings.whiteTheme = false
                }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "背景图片<a href=\"j\">(恢复默认)</a>:"
                platformInverted: tbsettings.whiteTheme
                onLinkActivated: tbsettings.backgroundImage = ""
            }
            Button {
                width: parent.width; platformInverted: tbsettings.whiteTheme
                text: tbsettings.backgroundImage==""?"未定义":tbsettings.backgroundImage
                onClicked: tbsettings.backgroundImage = utility.choosePhoto()||tbsettings.backgroundImage
            }
            SectionLabel { label: "内容" }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "图片显示:"
                platformInverted: tbsettings.whiteTheme
            }
            ButtonRow {
                exclusive: false; width: parent.width
                Button {
                    platformInverted: tbsettings.whiteTheme; text: "正文"; checked: tbsettings.showImage
                    onClicked: tbsettings.showImage = !tbsettings.showImage
                }
                Button {
                    platformInverted: tbsettings.whiteTheme; text: "头像"; checked: tbsettings.showAvatar
                    onClicked: tbsettings.showAvatar = !tbsettings.showAvatar
                }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "正文字号:"
                platformInverted: tbsettings.whiteTheme
            }
            Slider {
                platformInverted: tbsettings.whiteTheme
                width: parent.width;
                minimumValue: platformStyle.fontSizeSmall; maximumValue: platformStyle.fontSizeSmall*2
                stepSize: 1; value: tbsettings.fontSize
                onPressedChanged: if (!pressed) tbsettings.fontSize = value
                valueIndicatorVisible: true
            }
            SectionLabel { label: "提醒" }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "提醒频率:"
                platformInverted: tbsettings.whiteTheme
            }
            Slider {
                platformInverted: tbsettings.whiteTheme
                width: parent.width;
                minimumValue: 0; maximumValue: 3; stepSize: 1;
                value: {
                    switch (tbsettings.remindFrequency){
                    case 30000: return 3
                    case 120000: return 2
                    case 300000: return 1
                    default: return 0
                    }
                }
                valueIndicatorVisible: true
                valueIndicatorText: {
                    switch (value){
                    case 0: return "关闭"
                    case 1: return "5分钟"
                    case 2: return "2分钟"
                    case 3: return "半分钟"
                    }
                }
                onPressedChanged: if (!pressed){
                                      switch (value){
                                      case 1: tbsettings.remindFrequency = 300000; break;
                                      case 2: tbsettings.remindFrequency = 120000; break;
                                      case 3: tbsettings.remindFrequency = 30000; break;
                                      default: tbsettings.remindFrequency = 0; break;
                                      }
                                  }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "提醒内容:"
                platformInverted: tbsettings.whiteTheme
            }
            ButtonRow {
                exclusive: false; width: parent.width
                Button {
                    text: "回复"; platformInverted: tbsettings.whiteTheme; checked: tbsettings.remindReplyToMe
                    onClicked: tbsettings.remindReplyToMe = !tbsettings.remindReplyToMe
                }
                Button {
                    text: "提及"; platformInverted: tbsettings.whiteTheme; checked: tbsettings.remindAtMe;
                    onClicked: tbsettings.remindAtMe = !tbsettings.remindAtMe
                }
                Button {
                    text: "粉丝"; platformInverted: tbsettings.whiteTheme; checked: tbsettings.remindNewFans
                    onClicked: tbsettings.remindNewFans = !tbsettings.remindNewFans
                }
            }
            SectionLabel { label: "高级" }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "图片打开方式:"
                platformInverted: tbsettings.whiteTheme
            }
            ButtonRow {
                exclusive: false; width: parent.width
                Button {
                    platformInverted: tbsettings.whiteTheme; text: "系统"; checked: tbsettings.openWithSystem
                    onClicked: tbsettings.openWithSystem = true
                }
                Button {
                    platformInverted: tbsettings.whiteTheme; text: "软件"; checked: !tbsettings.openWithSystem
                    onClicked: tbsettings.openWithSystem = false
                }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "图片保存地址<a href=\"h\">(恢复默认)</a>:"
                platformInverted: tbsettings.whiteTheme
                onLinkActivated: tbsettings.resetImagePath()
            }
            Button {
                width: parent.width; platformInverted: tbsettings.whiteTheme
                text: tbsettings.imagePath
                onClicked: {
                    Qt.createComponent("Dialog/FolderSelector.qml").createObject(settingPage).open()
                }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "最大标签数量:"
                platformInverted: tbsettings.whiteTheme
            }
            Slider {
                platformInverted: tbsettings.whiteTheme; width: parent.width
                minimumValue: 0; maximumValue: 10; stepSize: 1
                value: tbsettings.maxThreadCount
                onPressedChanged: if (!pressed) tbsettings.maxThreadCount = value
                valueIndicatorVisible: true
                valueIndicatorText: value || "不限制"
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "发帖后缀:"
                platformInverted: tbsettings.whiteTheme
            }
            ButtonRow {
                exclusive: false; width: parent.width
                Button {
                    text: "iPhone"; checked: tbsettings.clientType == 1; platformInverted: tbsettings.whiteTheme
                    onClicked: tbsettings.clientType = 1
                }
                Button {
                    text: "Android"; checked: tbsettings.clientType == 2; platformInverted: tbsettings.whiteTheme
                    onClicked: tbsettings.clientType = 2
                }
                Button {
                    text: screen.width > screen.height ? "WindowsPhone" : "WP"
                    checked: tbsettings.clientType == 3; platformInverted: tbsettings.whiteTheme
                    onClicked: tbsettings.clientType = 3
                }
            }
            Label {
                height: platformStyle.graphicSizeMedium
                verticalAlignment: Text.AlignVCenter
                text: "文字签名:"
                platformInverted: tbsettings.whiteTheme
            }
            Button {
                width: parent.width; platformInverted: tbsettings.whiteTheme
                text: tbsettings.signText || "未设定"
                onClicked: {
                    Qt.createComponent("Dialog/SetSignDialog.qml").createObject(settingPage).open()
                }
            }
            Item { width: 1; height: platformStyle.paddingLarge }
        }
    }
}
