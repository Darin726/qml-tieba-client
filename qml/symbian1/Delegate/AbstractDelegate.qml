import QtQuick 1.0
import com.nokia.symbian 1.0

ImplicitSizeItem {
    id: root;

    property alias paddingItem: paddingItem;

    signal clicked;
    signal pressAndHold;

    implicitWidth: ListView.view ? ListView.view.width : 0;
    implicitHeight: platformStyle.graphicSizeLarge;

    Item {
        id: paddingItem;
        anchors {
            left: parent.left; leftMargin: platformStyle.paddingLarge;
            right: parent.right; rightMargin: platformStyle.paddingLarge;
            top: parent.top; topMargin: platformStyle.paddingLarge;
            bottom: parent.bottom; bottomMargin: platformStyle.paddingLarge;
        }
    }

    Rectangle {
        id: bottomLine;
        anchors {
            left: root.left; right: root.right; bottom: parent.bottom;
        }
        height: 1;
        color: symbianStyle.colorDisabled;
    }

    MouseArea {
        anchors.fill: parent;
        enabled: root.enabled;
        onClicked: root.clicked();
        onPressed: {
            privateStyle.play(Symbian.BasicItem)
            root.opacity = 0.7;
        }
        onReleased: {
            privateStyle.play(Symbian.BasicItem)
            root.opacity = 1;
        }
        onCanceled: {
            root.opacity = 1;
        }
        onPressAndHold: root.pressAndHold();
    }
}
