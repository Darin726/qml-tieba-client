import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "NearbyPageComp"
import "../js/main.js" as Script

Page {
    id: page

    property int currentPage: 1;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: tabGroup.currentTab.refreshPosition();
        }
        ToolIcon {
            platformIconId: "toolbar-edit";
            enabled: positionSource.valid;
            onClicked: {
                var param = { caller: nearbyThread };
                pageStack.push(Qt.resolvedUrl("PostPage.qml"), { param: param, state: "weipost" });
            }
        }
    }
    TabHeader {
        id: viewHeader;
        ThreadButton { tab: nearbyThread; }
        ThreadButton { tab: nearbyForum; }
    }
    SectionHeader {
        id: listHeading;
        anchors.top: viewHeader.bottom;
        z: 10;
        text: {
            if (positionSource.active){
                return qsTr("Refreshing position data");
            } else if (!positionSource.valid){
                return qsTr("Cannot get position data");
            } else {
                var coor = positionSource.position.coordinate;
                return qsTr("lat:%1, lon: %2").arg(String(coor.latitude)).arg(String(coor.longitude));
            }
        }
    }
    TabGroup {
        id: tabGroup;
        anchors { fill: parent; topMargin: viewHeader.height + listHeading.height; }
        currentTab: nearbyThread;
        clip: true;
        NearbyThread { id: nearbyThread; pageStack: page.pageStack; }
        NearbyForum { id: nearbyForum; pageStack: page.pageStack; }
    }
}
