import QtQuick 1.0
import "../../js/Calculate.js" as Calc

Item {

    width: platformStyle.graphicSizeMedium;
    height: platformStyle.graphicSizeMedium;

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            signalCenter.linkActivated("img:"+modelData[1]);
            parent.opacity = 0.6;
        }
    }
    Image {
        id: placeHolder;
        anchors.centerIn: parent;
        sourceSize: Qt.size(platformStyle.graphicSizeMedium,
                            platformStyle.graphicSizeMedium);
    }
    Image {
        id: img;
        anchors.fill: parent;
        opacity: 0;
        fillMode: Image.PreserveAspectFit;
        Behavior on opacity {
            NumberAnimation { duration: 250; }
        }
        onStatusChanged: {
            if (status == Image.Error && source != modelData[1]){
                source = modelData[1];
            } else if (status == Image.Ready){
                placeHolder.opacity = 0;
                img.opacity = 1;
            }
        }
    }
    Connections {
        id: setSourceConnections;
        target: null;
        onMovementEnded: {
            setSourceConnections.target = null;
            setSource();
        }
    }

    function setSource(){
        placeHolder.source = "../gfx/photos.svg";
        if (tbsettings.showImage){
            img.source = Calc.getThumbnail(modelData[1]);
        }
    }

    Component.onCompleted: {
        if (tbsettings.showImage){
            if (modelData[2] > 200 || modelData[3] > 200){
                width = 200; height = 200;
            } else {
                width = modelData[2]; height = modelData[3];
            }
        }
        if (!root.ListView.view || !root.ListView.view.moving){
            setSource();
        } else {
            setSourceConnections.target = root.ListView.view;
        }
    }
}
