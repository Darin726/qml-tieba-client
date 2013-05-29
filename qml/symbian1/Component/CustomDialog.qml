import QtQuick 1.0
import com.nokia.symbian 1.0

CommonDialog {
    id: root;

    property variant buttonTexts: []
    signal buttonClicked(int index);

    onButtonTextsChanged: {
        for (var i = buttonRow.children.length; i > 0; --i) {
            buttonRow.children[i - 1].destroy()
        }
        for (var j = 0; j < buttonTexts.length; ++j) {
            var button = buttonComponent.createObject(buttonRow)
            button.text = buttonTexts[j]
            button.index = j
        }
    }

    Component {
        id: buttonComponent
        ToolButton {
            property int index

            width: internal.buttonWidth()
            height: privateStyle.toolBarHeightLandscape

            onClicked: {
                if (root.status == DialogStatus.Open) {
                    root.buttonClicked(index)
                    root.close()
                }
            }
        }
    }

    QtObject {
        id: internal;
        function buttonWidth() {
            switch (buttonTexts.length) {
                case 0: return 0
                case 1: return Math.round((privateStyle.dialogMaxSize - 3 * platformStyle.paddingMedium) / 2)
                default: return (buttonContainer.width - (buttonTexts.length + 1) *
                    platformStyle.paddingMedium) / buttonTexts.length
            }
        }
    }

    buttons: Item {
        id: buttonContainer

        width: parent.width
        height: buttonTexts.length ? privateStyle.toolBarHeightLandscape + 2 * platformStyle.paddingSmall : 0

        Row {
            id: buttonRow
            objectName: "buttonRow"
            anchors.centerIn: parent
            spacing: platformStyle.paddingMedium
        }
    }
}
