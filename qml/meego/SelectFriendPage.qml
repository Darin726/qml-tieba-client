import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

Page {
    id: page;

    property Item caller: null;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    function getlist(){
        var opt = { model: friendModel, renew: true, type: "list" };
        Script.getFriendList(page, opt);
    }

    function suggest(){
        var opt = { friendModel: friendModel, model: sugModel, q: searchInput.text }
        Script.getFriendSuggest(page, opt);
    }

    Connections {
        target: signalCenter;
        onGetFriendListStarted: {
            if (caller == page.toString()){
                friendView.loading = true;
            }
        }
        onGetFriendListFinished: {
            if (caller == page.toString()){
                friendView.loading = false;
            }
        }
        onGetFriendSuggestStarted: {
            if (caller == page.toString()){
                sugView.loading = true;
            }
        }
        onGetFriendSuggestFinished: {
            if (caller == page.toString()){
                sugView.loading = false;
            }
        }
        onLoadFailed: {
            friendView.loading = false;
            sugView.loading = false;
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: qsTr("Select Friend");
        loading: tabGroup.currentTab.loading;
    }

    SearchInput {
        id: searchInput;
        property bool searching: false;
        anchors {
            left: parent.left; right: parent.right; top: viewHeader.bottom;
            margins: constant.paddingLarge;
        }
        placeholderText: qsTr("Tap To Search");
        onTypeStopped: {
            if (text.length > 0) suggest();
            else sugModel.clear();
        }
        onActiveFocusChanged: if (activeFocus) searching = true;
        onCleared: searching = false;
    }

    TabGroup {
        id: tabGroup;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            top: searchInput.bottom;
            topMargin: constant.paddingLarge;
        }
        currentTab: searchInput.searching ? sugView : friendView;
        ListView {
            id: friendView;
            property bool loading: false;
            anchors.fill: parent;
            clip: true;
            model: ListModel { id: friendModel; }
            header: PullToActivate {
                myView: friendView;
                enabled: friendModel.count == 0;
                visible: enabled;
                onRefresh: getlist();
            }
            delegate: FriendDelegate {
                onClicked: {
                    signalCenter.friendSelected(caller.toString(), model.name);
                    pageStack.pop();
                }
            }
            ScrollDecorator { flickableItem: friendView; }
        }
        ListView {
            id: sugView;
            property bool loading: false;
            anchors.fill: parent;
            clip: true;
            model: ListModel { id: sugModel; }
            delegate: FriendDelegate {
                onClicked: {
                    signalCenter.friendSelected(caller.toString(), model.name);
                    pageStack.pop();
                }
            }
        }
    }

    Component.onCompleted: { getlist(); }
}
