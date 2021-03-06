import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/main.js" as Script
import "../Component"

Page {
    id: page;

    property bool loading: false;
    property bool firstStart: true;
    property string title: qsTr("Nearby Forum");
    function positionAtTop(){
        view.positionViewAtBeginning();
    }

    function getlist(){
        var opt = {
            lng: positionSource.longitude,
            lat: positionSource.latitude,
            model: listModel
        }
        Script.getLbsForum(page, opt);
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
                getlist();
            }
        }
    }

    Connections {
        target: signalCenter;
        onGetForumListStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetForumListFinished: {
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
        delegate: NearbyForumDelegate {}
        header: PullToActivate {
            enabled: positionSource.valid;
            myView: view;
            onRefresh: getlist();
        }
        section {
            property: "distance";
            delegate: sectionDelegate;
        }
        Component {
            id: sectionDelegate;
            ListHeading {
                ListItemText {
                    anchors.fill: parent.paddingItem;
                    role: "Heading";
                    text: section;
                }
            }
        }
    }
}
