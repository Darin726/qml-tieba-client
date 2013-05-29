import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

MyPage {
    id: page;

    title: tabGroup.currentTab.title;

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Reload");
            iconSource: "toolbar-refresh";
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
