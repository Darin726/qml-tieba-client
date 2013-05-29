import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/main.js" as Script
import "Delegate"
import "Component"

Page {
    id: page;

    property bool loading: false;
    property string title: qsTr("At Me");

    property int currentPage: 1;
    property bool hasMore: false;
    property bool firstStart: true;
    property double lastUpdate: 0;

    function positionAtTop(){
        view.positionViewAtBeginning();
    }

    function getlist(option){
        option = option||"renew";
        var opt = { page: page, model: listModel }
        if (option == "renew"){
            autoCheck.atme = 0;
            currentPage = 1;
            opt.pn = 1;
        } else if (option == "more"){
            opt.pn = currentPage+1;
        }
        Script.getAtMe(opt);
    }

    onVisibleChanged: {
        if (visible){
            if (autoCheck.atme > 0){
                getlist();
            } else if (firstStart){
                try {
                    Script.loadAtMe(utility.getCache("AtMe"), {page: page, model: listModel});
                } catch(e){
                    getlist();
                }
            }
            firstStart = false;
        }
    }

    Connections {
        target: signalCenter;
        onGetAtMeStarted: loading = true;
        onGetAtMeFinished: loading = false;
        onLoadFailed: loading = false;
        onUserChanged: {
            if (page.visible){
                getlist();
            } else {
                firstStart = true;
            }
        }
    }

    ListView {
        id: view;
        anchors.fill: parent;
        model: ListModel { id: listModel; }
        delegate: AtMeDelegate {}
        header: PullToActivate {
            myView: view;
            lastUpdateTime: page.lastUpdate;
            onRefresh: getlist();
        }
        footer: FooterItem {
            visible: hasMore;
            enabled: !loading;
            onClicked: getlist("more")
        }
    }

    ScrollDecorator { flickableItem: view; platformInverted: tbsettings.whiteTheme; }
}
