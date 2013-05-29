import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "Delegate"
import "../js/main.js" as Script

MyPage {
    id: page;

    property Item caller: null;

    title: qsTr("Select Friend");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
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
        headerText: page.title;
        headerIcon: "gfx/contacts.svg";
        loading: tabGroup.currentTab.loading;
    }

    SearchInput {
        id: searchInput;
        anchors {
            left: parent.left; right: parent.right; top: viewHeader.bottom;
            margins: platformStyle.paddingLarge;
        }
        platformInverted: tbsettings.whiteTheme;
        placeholderText: qsTr("Tap To Search");
        onTypeStopped: {
            if (text.length > 0) suggest();
            else sugModel.clear();
        }
    }

    TabGroup {
        id: tabGroup;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            top: searchInput.bottom;
            topMargin: platformStyle.paddingLarge;
        }
        currentTab: searchInput.activeFocus ? sugView : friendView;
        ListView {
            id: friendView;
            property bool loading: false;
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
            ScrollDecorator { platformInverted: tbsettings.whiteTheme; flickableItem: friendView; }
        }
        ListView {
            id: sugView;
            property bool loading: false;
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
