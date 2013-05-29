import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"
import "NearbyPageComp"
import "../js/main.js" as Script

MyPage {
    id: page

    property int currentPage: 1;

    title: qsTr("Nearby");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Refresh location");
            iconSource: "toolbar-refresh";
            onClicked: tabGroup.currentTab.refreshPosition();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Create A Weipost");
            iconSource: "gfx/edit.svg";
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
    ListHeading {
        id: listHeading;
        anchors.top: viewHeader.bottom;
        z: 10;
        ListItemText {
            anchors.fill: parent.paddingItem;
            role: "Heading";
            text: {
                if (positionSource.active){
                    return qsTr("Refreshing position data");
                } else if (!positionSource.valid){
                    return qsTr("Cannot get position data");
                } else {
                    return qsTr("lat:%1, lon: %2").arg(String(positionSource.latitude)).arg(String(positionSource.longitude));
                }
            }
        }
        BusyIndicator {
            anchors { left: listHeading.paddingItem.left; verticalCenter: parent.verticalCenter; }
            running: true;
            visible: positionSource.active;
        }
    }
    TabGroup {
        id: tabGroup;
        anchors { fill: parent; topMargin: viewHeader.height + listHeading.height; }
        NearbyThread { id: nearbyThread; pageStack: page.pageStack; }
        NearbyForum { id: nearbyForum; pageStack: page.pageStack; }
    }
}
