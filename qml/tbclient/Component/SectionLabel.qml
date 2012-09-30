import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root
    property alias label: label.text
    width: parent.width; height: platformStyle.graphicSizeMedium
    Rectangle {
        anchors {
            left: parent.left; right: label.left; rightMargin: platformStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        height: 1
        color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                   : platformStyle.colorDisabledMid
    }
    ListItemText {
        id: label
        anchors {
            right: parent.right; verticalCenter: parent.verticalCenter
        }
        platformInverted: tbsettings.whiteTheme
        role: "SubTitle"
    }
}
