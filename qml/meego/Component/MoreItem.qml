import QtQuick 1.1
import com.nokia.meego 1.0

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
        spacing: constant.paddingMedium;

        Image {
            id: icon
            anchors.horizontalCenter: parent.horizontalCenter;
            width: 96;
            height: 96;
            sourceSize: "96x96";
            smooth: true;
        }

        Text {
            id: label;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: constant.fontSizeMedium;
            color: constant.colorLight;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent;
        onClicked: root.clicked();
    }
}
