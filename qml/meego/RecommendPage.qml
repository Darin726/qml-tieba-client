import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"

Page {
    id: page;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: tabGroup.currentTab.getlist();
        }
    }

    TabHeader {
        id: viewHeader;
        ThreadButton { tab: recClsPage; }
        ThreadButton { tab: hotFeedPage; }
    }

    TabGroup {
        id: tabGroup;
        anchors { fill: parent; topMargin: viewHeader.height; }
        currentTab: recClsPage;
        RecomClassicPage { id: recClsPage; }
        HotFeedPage { id: hotFeedPage; }
    }
}
