import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    property alias text: button.text;
    signal clicked;

    width: screen.width; height: visible ? platformStyle.graphicSizeLarge : 0;
    Button {
        id: button;
        anchors {
            left: parent.left; right: parent.right; margins: platformStyle.paddingLarge;
            verticalCenter: parent.verticalCenter;
        }
        platformInverted: tbsettings.whiteTheme;
        text: qsTr("Load More");
        onClicked: root.clicked();
    }
}
