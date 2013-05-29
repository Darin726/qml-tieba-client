import QtQuick 1.1
import com.nokia.symbian 1.1

SelectionDialog {
    id: root;
    titleText: qsTr("Boutique");
    buttonTexts: [qsTr("All Posts")];
    delegate: MenuItem {
        text: model.name;
        onClicked: {
            selectedIndex = index;
            root.accept();
        }
    }
    onButtonClicked: {
        selectedIndex = -1;
        root.accept();
    }
}
