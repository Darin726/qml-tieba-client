import QtQuick 1.1
import com.nokia.symbian 1.1
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
            iconSource: platformInverted ? "gfx/edit_inverted.svg" : "gfx/edit.svg";
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
        platformInverted: tbsettings.whiteTheme;
        z: 10;
        ListItemText {
            anchors.fill: parent.paddingItem;
            role: "Heading";
            platformInverted: listHeading.platformInverted;
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
        BusyIndicator {
            anchors { left: listHeading.paddingItem.left; verticalCenter: parent.verticalCenter; }
            running: true;
            platformInverted: listHeading.platformInverted;
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
