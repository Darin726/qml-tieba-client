import QtQuick 1.0
import com.nokia.symbian 1.0

Rectangle {
    id: root;

    property alias iconSource: icon.source;
    property alias text: label.text;

    signal clicked

    width: 100;
    height: 150;

    radius: 10;
    color: mouseArea.pressed ? "#66666666" : "#00000000"

    Column {
        anchors.centerIn: parent;
        spacing: platformStyle.paddingSmall;

        Image {
            id: icon
            anchors.horizontalCenter: parent.horizontalCenter;
            width: 80;
            height: 80;
            sourceSize: "80x80";
        }

        Label {
            id: label;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent;
        onClicked: root.clicked()
        onPressed: privateStyle.play(Symbian.BasicItem);
        onReleased: privateStyle.play(Symbian.BasicItem);
    }
}
