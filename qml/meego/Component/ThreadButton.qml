import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root;

    property Item tab;
    property bool active: internal.tabGroup != null && root.tab == internal.tabGroup.currentTab;
    signal clicked;

    width: parent.width / parent.children.length;
    height: parent.height;

    QtObject {
        id: internal;

        property Item tabGroup: findParent(tab, "currentTab");
        function click(){
            root.clicked();
            if (internal.tabGroup){
                if (internal.tabGroup.currentTab == tab){
                    tab.positionAtTop();
                } else {
                    internal.tabGroup.currentTab = tab;
                }
            }            
        }
        function findParent(child, propertyName) {
            if (!child)
                return null
            var next = child.parent
            while (next && !next.hasOwnProperty(propertyName))
                next = next.parent
            return next
        }
    }

    Text {
        anchors { fill: parent; margins: constant.paddingSmall; }
        elide: Text.ElideRight;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        text: tab.title;
        font.pixelSize: constant.fontSizeLarge;
        color: "white";
    }

    Loader {
        anchors.fill: parent;
        sourceComponent: tab.loading?busyIndicator:(sectionMouseArea.pressed ? pressingIndicator : undefined);
        Component {
            id: busyIndicator;
            Rectangle {
                id: indBg;
                anchors.fill: parent;
                color: "black";
                opacity: 0;
                BusyIndicator {
                    opacity: 1;
                    anchors.centerIn: parent;
                    running: true;
                    platformStyle: BusyIndicatorStyle { inverted: true }
                }
                Component.onCompleted: PropertyAnimation {
                    target: indBg;
                    property: "opacity";
                    from: 0;
                    to: 0.75;
                    duration: 250;
                }
            }
        }
        Component {
            id: pressingIndicator;
            Rectangle {
                anchors.fill: parent;
                color: "black";
                opacity: 0.5;
            }
        }
    }
    MouseArea {
        id: sectionMouseArea;
        anchors.fill: parent;
        onClicked: internal.click();
    }
}
