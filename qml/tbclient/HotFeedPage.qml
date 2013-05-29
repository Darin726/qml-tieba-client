import QtQuick 1.1
import com.nokia.symbian 1.1
import "Delegate"
import "../js/main.js" as Script
import "Component"

Page {
    id: page;

    property string title: qsTr("Hot Feed");
    property bool loading: false;
    property bool hasMore: false;
    property int currentPage: 1;
    property bool firstStart: true;

    onVisibleChanged: {
        if (visible && firstStart){
            firstStart = false;
            getlist();
        }
    }

    function positionAtTop(){
        if (view.atYBeginning){
            getlist();
        } else {
            view.positionViewAtBeginning();
        }
    }

    function getlist(option){
        option = option||"renew";
        var opt = { caller: page, model: listModel };
        if (option == "renew"){
            opt.renew = true;
            currentPage = 1;
            opt.pn = 1;
        } else if (option = "more"){
            opt.pn = currentPage + 1;
        }
        Script.getHotFeed(opt);
    }

    Connections {
        target: signalCenter
        onGetHotFeedStarted: page.loading = true;
        onGetHotFeedFinished: page.loading = false;
        onLoadFailed: page.loading = false;
        onUserChanged: page.firstStart = true;
    }

    ListView {
        id: view;
        anchors.fill: parent;
        model: ListModel { id: listModel; }
        delegate: HotFeedDelegate {}
        footer: FooterItem {
            enabled: !loading;
            visible: page.hasMore;
            onClicked: getlist("more");
        }
    }

    ScrollDecorator { flickableItem: view; platformInverted: tbsettings.whiteTheme; }
}
