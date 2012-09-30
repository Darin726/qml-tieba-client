import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    property alias paddingItem: paddingItem
    property alias headerText: headerTxt.text

    implicitWidth: screen.width
    implicitHeight: screen.width < screen.height ? privateStyle.tabBarHeightPortrait : privateStyle.tabBarHeightLandscape
    property bool platformInverted: tbsettings.whiteTheme

    Image {
        opacity: 0.9
        anchors.fill: parent
        source: privateStyle.imagePath("qtg_fr_tab_bar", platformInverted)
    }
    Item {
        id: paddingItem
        anchors { fill: parent; margins: platformStyle.paddingLarge }
    }
    Label {
        id: headerTxt
        anchors {
            left: paddingItem.left; verticalCenter: parent.verticalCenter
        }
        platformInverted: parent.platformInverted
        font.pixelSize: platformStyle.fontSizeLarge
    }
}
