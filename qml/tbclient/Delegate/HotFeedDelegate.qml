import QtQuick 1.1
import com.nokia.symbian 1.1
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;

    onClicked: {
        app.enterThread({threadId: modelData.tid, title: modelData.title});
    }

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right;
        }
        spacing: platformStyle.paddingSmall;
        Label {
            anchors { left: parent.left; right: parent.right; }
            text: modelData.title;
            platformInverted: root.platformInverted;
            font.pixelSize: tbsettings.fontSize;
            wrapMode: Text.Wrap;
            textFormat: Text.PlainText;
        }
        ListItemText {
            anchors { left: parent.left; right: parent.right; }
            platformInverted: root.platformInverted;
            role: "SubTitle";
            opacity: text ? 1 : 0;
            text: modelData.abstract;
            font.pixelSize: platformStyle.fontSizeMedium;
        }
        Loader {
            id: thumbnailLoader;
            anchors { left: parent.left; right: parent.right; }
            opacity: tbsettings.showImage && modelData.media.length > 0 ? 1 : 0;
            height: opacity ? 75 : 0;
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            ListItemText {
                role: "SubTitle";
                text: modelData.fname+qsTr("Bar");
                platformInverted: root.platformInverted;
            }
            ListItemText {
                id: timeShow;
                anchors.right: parent.right;
                role: "SubTitle";
                platformInverted: root.platformInverted;
                text: Calc.formatDateTime(modelData.last_time_int*1000);
            }
            ListItemText {
                anchors { right: timeShow.left; rightMargin: platformStyle.paddingMedium; }
                text: qsTr("Reply:")+modelData.reply_num;
                platformInverted: root.platformInverted;
                role: "SubTitle";
            }
        }
    }

    function setSource(){
        if (tbsettings.showImage && modelData.media.length > 0){
            thumbnailLoader.source = "AbstractImage.qml";
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

    Component.onCompleted: {
        if (!ListView.view || !ListView.view.moving){
            setSource();
        } else {
            setSourceConnections.target = ListView.view;
        }
    }
}
