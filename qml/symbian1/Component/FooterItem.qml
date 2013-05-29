import QtQuick 1.0
import com.nokia.symbian 1.0

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
        text: qsTr("Load More");
        onClicked: root.clicked();
    }
}
