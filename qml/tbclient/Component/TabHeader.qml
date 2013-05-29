import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    default property alias content: tabBarLayout.data;
    property alias layout: tabBarLayout;

    anchors { top: parent.top; left: parent.left; right: parent.right; }
    height: screen.width < screen.height ? privateStyle.tabBarHeightPortrait : privateStyle.tabBarHeightLandscape
    z: 10;

    Image { anchors.fill: parent; source: tbsettings.whiteTheme?"../gfx/header_inverted.png":"../gfx/header.png"; }
    Image {
        anchors { top: parent.top; left: parent.left; }
        source: "../gfx/meegoTLCorner.png";
    }
    Image {
        anchors { top: parent.top; right: parent.right; }
        source: "../gfx/meegoTRCorner.png";
    }

    TabBarLayout { id: tabBarLayout;  anchors.fill: parent; }

    Rectangle {
        id: currentSectionIndicator;
        anchors.bottom: parent.bottom;
        color: "white";
        height: platformStyle.paddingSmall;
        width: parent.width;
        Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.InOutExpo; }
        }
    }

    QtObject {
        id: internal;

        function resizeIndicatorLength(){
            currentSectionIndicator.width = root.width / Math.max(1, tabBarLayout.children.length);
        }

        function setIndicatorPosition(){
            for (var i=0, l=tabBarLayout.children.length; i<l; i++){
                var btn = tabBarLayout.children[i];
                if (btn.hasOwnProperty("checked") && btn.checked){
                    currentSectionIndicator.x = currentSectionIndicator.width*i;
                    break;
                }
            }
        }
        function setButtonConnections(){
            for (var i=0, l=tabBarLayout.children.length; i<l; i++){
                var btn = tabBarLayout.children[i];
                if (btn.hasOwnProperty("checked")){
                    btn.checkedChanged.disconnect(setIndicatorPosition);
                    btn.checkedChanged.connect(setIndicatorPosition);
                }
            }
        }
    }

    Connections {
        target: tabBarLayout;
        onWidthChanged: {
            internal.resizeIndicatorLength();
            internal.setIndicatorPosition();
        }
        onChildrenChanged: {
            internal.resizeIndicatorLength();
            internal.setIndicatorPosition();
            internal.setButtonConnections();
        }

        Component.onCompleted: {
            internal.resizeIndicatorLength();
            internal.setIndicatorPosition();
            internal.setButtonConnections();
        }
    }
}
