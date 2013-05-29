import QtQuick 1.1
import com.nokia.meego 1.0

SelectionDialog {
    id: root;
    titleText: qsTr("Boutique");
    buttons: Button {
        anchors.horizontalCenter: parent.horizontalCenter;
        text: qsTr("All Posts");
        platformStyle: ButtonStyle { inverted: true; }
        onClicked: {
            selectedIndex = -1;
            root.accept();
        }
    }
}
