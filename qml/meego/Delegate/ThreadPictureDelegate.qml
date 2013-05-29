import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/main.js" as Script
import "../Component"

Item {
    id: root;

    property bool loading: false;

    property int commentAmount: 0;
    property int currentPage: 1;
    property int totalPage: 1;

    implicitWidth: ListView.view ? ListView.view.width : parent.width;
    implicitHeight: ListView.view ? ListView.view.height : parent.height;

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
                width: ListView.view ? ListView.view.width : parent.width;
                height: contentCol.height + constant.paddingSmall*2;

                color: theme.inverted ? "#C0202020" : "#C0E6E6E6";
                radius: 5;

                Column {
                    id: contentCol;
                    anchors {
                        left: parent.left;
                        top: parent.top;
                        right: parent.right;
                        margins: constant.paddingSmall;
                    }
                    spacing: constant.paddingMedium;
                    Image {
                        id: previewImg;
                        anchors { left: parent.left; right: parent.right; }
                        height: width;
                        fillMode: Image.PreserveAspectFit;
                        cache: false;
                        smooth: false;
                        sourceSize.height: height;

                        BusyIndicator {
                            anchors.centerIn: parent;
                            platformStyle: BusyIndicatorStyle { size: "medium" }
                            running: true;
                            visible: previewImg.status == Image.Loading;
                        }
                        Text {
                            anchors.centerIn: parent;
                            visible: previewImg.status != Image.Ready;
                            text: previewImg.status == Image.Loading || previewImg.status == Image.Null
                                  ? Math.floor(previewImg.progress*100)+"%"
                                  : qsTr("Load Error > <");
                            font.pixelSize: constant.fontSizeSmall;
                            font.weight: Font.Light;
                            color: constant.colorMid;
                        }
                        MouseArea {
                            anchors.fill: parent;
                            enabled: previewImg.status == Image.Ready;
                            onClicked: signalCenter.linkActivated("img:"+previewImg.source);
                        }
                    }
                    Text {
                        anchors { left: parent.left; right: parent.right; }
                        text: model.descr;
                        wrapMode: Text.Wrap;
                        font.pixelSize: tbsettings.fontSize;
                        visible: text != "";
                        color: constant.colorLight;
                    }
                    Item {
                        anchors { left: parent.left; right: parent.right; }
                        height: childrenRect.height;
                        Text {
                            text: model.user_name;
                            font.pixelSize: constant.fontSizeSmall;
                            font.weight: Font.Light;
                            color: constant.colorMid;
                        }
                        Text {
                            anchors.right: parent.right;
                            text: qsTr("Comment:")+commentAmount;
                            font.pixelSize: constant.fontSizeSmall;
                            font.weight: Font.Light;
                            color: constant.colorMid;
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
                height: constant.graphicSizeMedium;
                visible: commentAmount == 0;
                Text {
                    text: loading ? qsTr("Loading...") : qsTr("No comments by now");
                    anchors.centerIn: parent;
                    font.pixelSize: constant.fontSizeSmall;
                    font.weight: Font.Light;
                    color: constant.colorMid;
                }
            }
            FooterItem {
                visible: currentPage < totalPage;
                enabled: !loading;
                onClicked: getlist("more");
            }
        }
    }

    ScrollDecorator { flickableItem: view; }

    Component.onCompleted: {
        if (!root.ListView.view || !root.ListView.view.moving){
            setSource();
        } else {
            movementNotifier.target = root.ListView.view;
        }
    }
}
