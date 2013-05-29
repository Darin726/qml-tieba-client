import QtQuick 1.0
import com.nokia.symbian 1.0

SelectionDialog {
    id: root;
    titleText: qsTr("Boutique");
    delegate: MenuItem {
        text: model.name;
        onClicked: {
            selectedIndex = index;
            root.accept();
        }
    }
    buttons: Item {
        id: buttonContainer

        width: parent.width
        height: privateStyle.toolBarHeightLandscape + 2 * platformStyle.paddingSmall

        ToolButton {
            anchors.centerIn: parent;
            width: Math.round((privateStyle.dialogMaxSize - 3 * platformStyle.paddingMedium) / 2)
            height: privateStyle.toolBarHeightLandscape
            text: qsTr("All Posts");
            onClicked: {
                if (root.status == DialogStatus.Open) {
                    selectedIndex = -1;
                    root.accept();
                    root.close()
                }
            }
        }
    }
}
