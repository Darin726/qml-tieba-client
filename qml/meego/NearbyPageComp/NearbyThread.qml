import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/main.js" as Script
import "../Component"

Page {
    id: page;

    property bool loading: false;
    property bool firstStart: true;
    property string title: qsTr("Nearby Thread");
    function positionAtTop(){
        view.positionViewAtBeginning();
    }

    property bool hasMore: false;
    property int currentPage: 1;

    function getlist(option){
        option = option||"renew";
        var coor = positionSource.position.coordinate;
        var opt = {
            lng: coor.longitude,
            lat: coor.latitude,
            model: listModel
        }
        if (option == "renew"){
            currentPage = 1;
            opt.pn = 1;
            opt.renew = true;
        } else if (option == "more"){
            opt.pn = currentPage + 1;
        }
        Script.getLbsThread(page, opt);
    }

    function refreshPosition(){
        positionListener.target = positionSource;
        positionSource.update();
    }

    onVisibleChanged: {
        if (visible && firstStart){
            firstStart = false;
            if (positionSource.valid){
                getlist();
            } else {
                refreshPosition();
            }
        }
    }

    Connections {
        id: positionListener;
        target: null;
        onPositionChanged: {
            if (positionSource.valid){
                positionListener.target = null;
                getlist("renew");
            }
        }
    }

    Connections {
        target: signalCenter;
        onGetThreadListStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetThreadListFinished: {
            if (caller == page.toString()){
                loading = false;
            }
        }
        onLoadFailed: loading = false;
    }

    ListView {
        id: view;
        anchors.fill: parent;
        model: ListModel { id: listModel; }
        delegate: NearbyThreadDelegate {}
        header: PullToActivate {
            myView: view;
            enabled: positionSource.valid;
            onRefresh: getlist();

        }
        footer: FooterItem {
            visible: listModel.count > 0 && hasMore;
            enabled: !loading;
            onClicked: getlist("more");
        }
        section {
            property: "distance";
            delegate: sectionDelegate;
        }
        Component {
            id: sectionDelegate;
            SectionHeader {
                text: section;
            }
        }
    }
}
