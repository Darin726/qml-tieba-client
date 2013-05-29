import QtQuick 1.1

Item {
    id: root;

    implicitWidth: screen.rotation === 0 || screen.rotation === 180 ? screen.displayWidth : screen.displayHeight;
    implicitHeight: 2;

    Rectangle {
        anchors { left: parent.left; right: parent.right; }
        height: 1;
        color: "#66666666";
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; }
        height: 1;
        color: theme.inverted ? "grey" :"#ffffff";
    }
}
