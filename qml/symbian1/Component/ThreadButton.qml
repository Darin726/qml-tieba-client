import QtQuick 1.0
import com.nokia.symbian 1.0

Item {
    id: root;

    property Item tab;
    property bool checked: internal.tabGroup !== null && internal.tabGroup.currentTab === tab;

    signal clicked;

    QtObject {
        id: internal;

        property Item tabGroup: findParent(tab, "currentTab");
        function press(){
            privateStyle.play(Symbian.BasicButton);
        }
        function click(){
            root.clicked();
            privateStyle.play(Symbian.BasicButton);
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

    Label {
        anchors { fill: parent; margins: platformStyle.paddingSmall; }
        elide: Text.ElideRight;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        text: tab ? tab.title : "";
    }

    Loader {
        anchors.fill: parent;
        sourceComponent: tab&&tab.loading?busyIndicator:(sectionMouseArea.pressed ? pressingIndicator : undefined);
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
        onPressed: internal.press();
        onClicked: internal.click();
    }
}
