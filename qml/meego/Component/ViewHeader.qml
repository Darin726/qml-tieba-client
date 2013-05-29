import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root

    property alias headerText: text.text;

    property bool loading: false;

    signal clicked;

    anchors { top: parent.top; left: parent.left; right: parent.right; }
    implicitHeight: constant.headerHeight;
    z: 10;

    Rectangle {
        anchors.fill: parent;
        color: theme.inverted ? "#2e2e2e" : "#1080dd";
    }

    SplitLine { anchors.bottom: parent.bottom; }

    Text {
        id: text;
        anchors {
            left: parent.left; leftMargin: constant.paddingXLarge;
            right: busyIndicatorLoader.status == Loader.Ready ? busyIndicatorLoader.left : parent.right;
            verticalCenter: parent.verticalCenter;
            margins: constant.paddingMedium;
        }
        font.pixelSize: constant.fontSizeXXLarge;
        color: "white";
        wrapMode: Text.WrapAnywhere;
        maximumLineCount: 2;
        elide: Text.ElideRight;
    }

    Loader {
        id: busyIndicatorLoader
        anchors {
            right: parent.right;
            rightMargin: constant.paddingMedium;
            verticalCenter: parent.verticalCenter;
        }
        sourceComponent: loading ? busyIndicatorComponent : undefined;
    }

    Component {
        id: busyIndicatorComponent
        BusyIndicator {
            anchors.centerIn: parent
            running: true;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
