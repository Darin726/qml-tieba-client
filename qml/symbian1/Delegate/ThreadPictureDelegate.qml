import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/main.js" as Script
import "../Component"

Item {
    id: root;

    property bool loading: false;

    property int commentAmount: 0;
    property int currentPage: 1;
    property int totalPage: 1;

    width: ListView.view ? ListView.view.width : screen.width;
    height: ListView.view ? ListView.view.height : screen.height;

    function getlist(option){
        option = option || "renew";
        var opt = { kw: forum.name, picid: model.img.original.id, tid: tid, model: commentModel }
        if (option == "renew"){
            currentPage = 1;
            opt.renew = true;
            opt.pn = 1;
        } else if (option == "more"){
            opt.pn = currentPage+1;
        }
        Script.getPicComment(root, opt);
    }

    function setSource(){
        previewImg.source = model.img.original.url;
        getlist();
    }

    Connections {
        target: signalCenter;
        onGetFloorListStarted: {
            if (caller == root.toString()){
                loading = true;
            }
        }
        onGetFloorListFinished: {
            if (caller == root.toString()){
                loading = false;
            }
        }
        onLoadFailed: {
            loading = false;
        }
        onPostFinished: {
            if (caller == root.toString()){
                if (totalPage == 1 && !loading){
                    getlist("renew");
                }
            }
        }
    }

    Connections {
        id: movementNotifier;
        target: null;
        onMovementEnded: {
            movementNotifier.target = null;
            setSource();
        }
    }

    Flickable {
        id: view;
        anchors.fill: parent;
        contentWidth: width;
        contentHeight: viewCol.height;
        flickableDirection: Flickable.VerticalFlick;
        Column {
            id: viewCol;
            anchors { left: parent.left; right: parent.right; }
            Rectangle {
                width: ListView.view ? ListView.view.width : screen.width;
                height: contentCol.height + platformStyle.paddingSmall*2;

                color: "#C0202020";
                radius: 5;

                Column {
                    id: contentCol;
                    anchors {
                        left: parent.left;
                        top: parent.top;
                        right: parent.right;
                        margins: platformStyle.paddingSmall;
                    }
                    spacing: platformStyle.paddingMedium;
                    Image {
                        id: previewImg;
                        anchors { left: parent.left; right: parent.right; }
                        height: width;
                        fillMode: Image.PreserveAspectFit;
                        smooth: false;
                        sourceSize.height: height;

                        BusyIndicator {
                            anchors.centerIn: parent;
                            width: platformStyle.graphicSizeLarge;
                            height: platformStyle.graphicSizeLarge;
                            running: true;
                            visible: previewImg.status == Image.Loading;
                        }
                        ListItemText {
                            anchors.centerIn: parent;
                            role: "SubTitle";
                            visible: previewImg.status != Image.Ready;
                            text: previewImg.status == Image.Loading || previewImg.status == Image.Null
                                  ? Math.floor(previewImg.progress*100)+"%"
                                  : qsTr("Load Error > <");
                        }
                        MouseArea {
                            anchors.fill: parent;
                            enabled: previewImg.status == Image.Ready;
                            onClicked: signalCenter.linkActivated("img:"+previewImg.source);
                        }
                    }
                    Label {
                        anchors { left: parent.left; right: parent.right; }
                        text: model.descr;
                        wrapMode: Text.Wrap;
                        font.pixelSize: tbsettings.fontSize;
                        visible: text != "";
                    }
                    Item {
                        anchors { left: parent.left; right: parent.right; }
                        height: childrenRect.height;
                        ListItemText {
                            text: model.user_name;
                            role: "SubTitle";
                        }
                        ListItemText {
                            anchors.right: parent.right;
                            role: "SubTitle";
                            text: qsTr("Comment:")+commentAmount;
                        }
                    }
                }
            }
            Repeater {
                model: ListModel { id: commentModel; }
                FloorDelegate { width: viewCol.width; }
            }
            Item {
                anchors { left: parent.left; right: parent.right; }
                height: platformStyle.graphicSizeMedium;
                visible: commentAmount == 0;
                ListItemText {
                    text: loading ? qsTr("Loading...") : qsTr("No comments by now");
                    role: "SubTitle";
                    anchors.centerIn: parent;
                }
            }
            FooterItem {
                visible: currentPage < totalPage;
                enabled: !loading;
                onClicked: getlist("more");
            }
        }
    }

    Component.onCompleted: {
        if (!root.ListView.view || !root.ListView.view.moving){
            setSource();
        } else {
            movementNotifier.target = root.ListView.view;
        }
    }
}
