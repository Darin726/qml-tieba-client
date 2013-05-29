import QtQuick 1.0
import com.nokia.symbian 1.0

ImplicitSizeItem {
    id: root

    property alias headerIcon: icon.source;
    property alias headerText: text.text;

    property bool loading: false;

    signal clicked;

    anchors { top: parent.top; left: parent.left; right: parent.right; }
    implicitHeight: screen.width < screen.height ? privateStyle.tabBarHeightPortrait : privateStyle.tabBarHeightLandscape
    z: 10;

    Image {
        id: background
        anchors.fill: parent
        source: "../gfx/header"+(mouseArea.pressed?"_pressed":"")+".png"
    }

    Image {
        anchors { top: parent.top; left: parent.left }
        source: "../gfx/meegoTLCorner.png"
    }

    Image {
        anchors { top: parent.top; right: parent.right }
        source: "../gfx/meegoTRCorner.png"
    }

    Image {
        id: icon
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; margins: platformStyle.paddingMedium }
        width: platformStyle.graphicSizeSmall;
        height: platformStyle.graphicSizeSmall;
        sourceSize: Qt.size(platformStyle.graphicSizeSmall,
                            platformStyle.graphicSizeSmall)
    }

    Text {
        id: text;
        anchors {
            left: icon.right;
            right: busyIndicatorLoader.status == Loader.Ready ? busyIndicatorLoader.left : parent.right;
            verticalCenter: parent.verticalCenter;
            margins: platformStyle.paddingMedium;
        }
        font {
           family: platformStyle.fontFamilyRegular;
           pixelSize: platformStyle.fontSizeLarge;
        }
        color: platformStyle.colorNormalLight;
        wrapMode: Text.WrapAnywhere;
        elide: Text.ElideRight;
    }

    Loader {
        id: busyIndicatorLoader
        anchors {
            right: parent.right;
            rightMargin: platformStyle.paddingMedium;
            verticalCenter: parent.verticalCenter;
        }
        sourceComponent: loading ? busyIndicatorComponent : undefined;
    }

    Component {
        id: busyIndicatorComponent
        BusyIndicator {
            anchors.centerIn: parent
            height: platformStyle.graphicSizeSmall;
            width: platformStyle.graphicSizeSmall;
            running: true;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
        onPressed: privateStyle.play(Symbian.BasicItem);
        onReleased: privateStyle.play(Symbian.BasicItem);
    }
}
