import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

MyPage {
    id: page;

    property alias text: textArea.text;

    title: qsTr("Copy Content");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Select all");
            text: qsTr("Select all");
            onClicked: {
                textArea.selectAll();
            }
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Copy to clipboard");
            text: qsTr("Copy");
            onClicked: {
                textArea.copy();
                signalCenter.showMessage(qsTr("Content is copied"));
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        enabled: false;
        headerText: page.title;
        headerIcon: privateStyle.imagePath("qtg_toolbar_copy");
    }

    TextArea {
        id: textArea;
        anchors {
            left: parent.left;
            right: parent.right;
            top: viewHeader.bottom;
            bottom: parent.bottom;
            margins: platformStyle.paddingLarge;
        }
    }
}
