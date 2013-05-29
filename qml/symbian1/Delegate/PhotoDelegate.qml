import QtQuick 1.0
import com.nokia.symbian 1.0

Item {
    id: root;

    signal clicked;

    onClicked: {
        var prop = { forum: forum, tid: model.tid, title: model.title, picAmount: model.amount }
        var p = pageStack.push(Qt.resolvedUrl("../ThreadPicturePage.qml"), prop);
        p.getlist();
    }

    width: screen.width / 2;
    height: Math.floor(model.photo.height / model.photo.width * width);

    Image {
        id: image;
        anchors.fill: rect;
        opacity: 0;
        onStatusChanged: {
            if (status == Image.Ready){
                opacity = 1;
            }
        }
        Behavior on opacity { NumberAnimation { duration: 200; } }
    }

    Image {
        anchors.centerIn: parent;
        source: "../gfx/photos.svg";
        visible: image.status != Image.Ready;
    }

    Rectangle {
        id: rect;
        anchors { fill: parent; margins: platformStyle.paddingMedium; }
        color: "#00000000";
        border {
            width: 1;
            color: platformStyle.colorDisabledMid;
        }
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom; }
            height: Math.min(parent.height/2, platformStyle.graphicSizeSmall);
            color: "#C0000000";
            ListItemText {
                anchors { left: parent.left; right: parent.right; }
                anchors.verticalCenter: parent.verticalCenter;
                text: model.title;
                role: "SubTitle";
            }
        }
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: parent;
        onPressed: root.opacity = 0.7;
        onReleased: root.opacity = 1;
        onCanceled: root.opacity = 1;
        onClicked: root.clicked();
    }

    function setSource(){
        var tly = root.mapToItem(flickable, 0, 0).y;
        if (tly >= -root.height && tly <= flickable.height){
            setSourceConnections.target = null;
            if ( width >= model.photo.width ){
                image.source = "http://imgsrc.baidu.com/forum/pic/item/"+model.photo.id+".jpg";
            } else {
                image.source = "http://imgsrc.baidu.com/forum/abpic/item/"+model.photo.id+".jpg";
            }
        }
    }

    Connections {
        id: setSourceConnections;
        target: flickable;
        onMovementEnded: { setSource(); }
    }

    Connections {
        id: signalCenterConnections;
        target: signalCenter;
        onGetThreadListFinished: {
            signalCenterConnections.target = null;
            setSource();
        }
    }
}
