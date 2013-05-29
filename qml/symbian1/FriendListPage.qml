import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool loading: false;
    property int totalCount: 0;
    property bool hasMore: false;
    property int currentPage: 1;
    property string type: "follow";
    property string uid: Script.uid;

    title: type=="follow"?qsTr("Friends"):qsTr("Fans");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    function getlist(option){
        option = option||"renew";
        var opt = { type: type, model: listModel }

        if (uid != Script.uid)
            opt.uid = uid;

        if (option == "renew"){
            if (type == "fans" && uid == Script.uid)
                autoCheck.fans = 0;
            currentPage = 1;
            opt.renew = true;
        } else if (option == "more"){
            opt.pn = currentPage + 1;
        }
        Script.getFriendList(page, opt);
    }

    Connections {
        target: signalCenter;
        onGetFriendListStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetFriendListFinished: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onLoadFailed: {
            loading = false;
        }
    }

    ViewHeader {
        id: viewHeader;
        headerIcon: "gfx/contacts.svg";
        headerText: title+"("+totalCount+")";
        loading: page.loading;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel { id: listModel; }
        header: PullToActivate {
            myView: view;
            onRefresh: getlist();
        }
        delegate: FriendDelegate {
            onClicked: signalCenter.linkActivated("at:"+model.id);
        }
        footer: FooterItem {
            visible: page.hasMore;
            enabled: !loading;
            onClicked: getlist("more");
        }
    }

    ScrollDecorator { flickableItem: view; }
}
