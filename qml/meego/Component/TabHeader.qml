import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root;

    default property alias content: tabBarLayout.data;
    property alias layout: tabBarLayout;

    anchors { top: parent.top; left: parent.left; right: parent.right; }
    height: constant.headerHeight;
    z: 10;

    Rectangle {
        anchors.fill: parent;
        color: theme.inverted ? "#2e2e2e" : "#1080dd";
    }

    ButtonRow { id: tabBarLayout;  anchors.fill: parent; exclusive: false; }

    Rectangle {
        id: currentSectionIndicator;
        anchors.bottom: parent.bottom;
        color: "white";
        height: constant.paddingSmall;
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
                if (btn.hasOwnProperty("active") && btn.active){
                    currentSectionIndicator.x = currentSectionIndicator.width*i;
                    break;
                }
            }
        }
        function setButtonConnections(){
            for (var i=0, l=tabBarLayout.children.length; i<l; i++){
                var btn = tabBarLayout.children[i];
                if (btn.hasOwnProperty("active")){
                    btn.activeChanged.disconnect(setIndicatorPosition);
                    btn.activeChanged.connect(setIndicatorPosition);
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
