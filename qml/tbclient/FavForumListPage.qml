import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "Delegate"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool loading: false;
    property string uid: Script.uid;

    title: qsTr("Favourite Forums");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    function getlist(){
        var opt = { model: listModel };
        if (uid != Script.uid){
            opt.uid = uid;
        }
        Script.getLikeForum(page, opt);
    }

    Connections {
        target: signalCenter;
        onGetForumListStarted: {
            if (caller == page.toString()){ loading = true; }
        }
        onGetForumListFinished: {
            if (caller == page.toString()) { loading = false; }
        }
        onLoadFailed: loading = false;
    }

    ViewHeader {
        id: viewHeader;
        headerText: page.title;
        headerIcon: "gfx/contacts.svg";
        loading: page.loading;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel { id: listModel; }
        delegate: delegateComp;
        header: PullToActivate {
            myView: view;
            onRefresh: getlist();
        }
        Component {
            id: delegateComp;
            AbstractDelegate {
                id: root;
                Column {
                    anchors.fill: parent.paddingItem;
                    ListItemText {
                        platformInverted: root.platformInverted;
                        text: model.name;
                    }
                    ListItemText {
                        platformInverted: root.platformInverted;
                        role: "SubTitle";
                        text: qsTr("Lv.")+model.level_id+"    "+model.level_name;
                    }
                }
                onClicked: app.enterForum(model.name);
            }
        }
    }

    ScrollDecorator { flickableItem: view; platformInverted: tbsettings.whiteTheme; }
}
