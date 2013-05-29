import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge;

    Column {
        id: contentCol;
        anchors { left: parent.left; right: parent.right; }
        spacing: platformStyle.paddingMedium;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: platformStyle.graphicSizeMedium;
            Image {
                id: avatar;
                width: platformStyle.graphicSizeMedium;
                height: platformStyle.graphicSizeMedium;
                sourceSize: Qt.size(width, height);
                opacity: status == Image.Ready ? 1 : 0;
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        if (modelData.author.type != 0){
                            signalCenter.linkActivated("at:"+modelData.author.id);
                        }
                    }
                }
            }
            Text {
                anchors { left: avatar.right; leftMargin: platformStyle.paddingMedium; verticalCenter: parent.verticalCenter; }
                text: {
                    var a = modelData.author;
                    return a.name_show + (a.is_like == 1?"\nLv."+a.level_id:"");
                }
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
            }
            Text {
                anchors.right: parent.right;
                text: modelData.floor + "#";
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
            }
        }
        Repeater {
            model: modelData.contentData;
            Loader {
                anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                source: modelData[0] ? "../Component/PostLabel.qml" : "../Component/PostImage.qml";
            }
        }
        Text {
            anchors { right: parent.right; rightMargin: platformStyle.paddingSmall }
            text: Qt.formatDateTime(new Date(modelData.time*1000),"yyyy-MM-dd hh:mm:ss");
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeSmall;
                weight: Font.Light;
            }
            color: symbianStyle.colorMid;
        }
    }
    Row {
        anchors { left: root.paddingItem.left; bottom: root.paddingItem.bottom; }
        visible: modelData.floor !== "1";
        Image { id: replyIcon; y: 1; }
        Text {
            text: modelData.sub_post_number;
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeSmall;
                weight: Font.Light;
            }
            color: symbianStyle.colorMid;
        }
    }
    function setSource(){
        if (tbsettings.showAvatar){
            avatar.source = Calc.getAvatar(modelData.author.portrait);
        } else {
            avatar.source = "../gfx/photo.png";
        }
        replyIcon.source = "../gfx/pb_reply.png";
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
        if (!root.ListView.view || !root.ListView.view.moving){
            setSource();
        } else {
            setSourceConnections.target = root.ListView.view;
        }
    }
}
