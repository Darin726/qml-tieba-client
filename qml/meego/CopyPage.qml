import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"

Page {
    id: page;

    property alias text: textArea.text;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButton {
            text: qsTr("Select all");
            onClicked: {
                textArea.selectAll();
            }
        }
        ToolButton {
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
        headerText: qsTr("Copy Content");
    }

    Flickable {
        id: contentFlickable;
        anchors {
            left: parent.left;
            right: parent.right;
            top: viewHeader.bottom;
            bottom: parent.bottom;
            margins: constant.paddingLarge;
        }
        contentWidth: width;
        contentHeight: textArea.height;
        TextArea {
            id: textArea;
            anchors { left: parent.left; right: parent.right; }
            property int minHeight: contentFlickable.height;
            function setHeight() { textArea.height = Math.max(implicitHeight, minHeight) }
            onMinHeightChanged: setHeight();
            onImplicitHeightChanged: setHeight();
        }
    }
}
