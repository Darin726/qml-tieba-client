import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root;

    property alias text: button.text;
    signal clicked;

    width: screen.rotation === 0 || screen.rotation === 180 ? screen.displayWidth : screen.displayHeight
    height: visible ? constant.graphicSizeLarge : 0;

    Button {
        id: button;
        anchors {
            left: parent.left; right: parent.right; margins: constant.paddingLarge;
            verticalCenter: parent.verticalCenter;
        }
        text: qsTr("Load More");
        onClicked: root.clicked();
    }
}
