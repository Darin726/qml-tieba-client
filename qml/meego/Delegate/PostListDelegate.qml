import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: constant.paddingMedium;

        Item {
            anchors { left: parent.left; right: parent.right; }
            height: constant.graphicSizeMedium;

            Image {
                id: avatar;
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom; }
                width: height;
                opacity: status == Image.Ready ? 1 : 0;
                Behavior on opacity { NumberAnimation { duration: 250; } }
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
                anchors.left: avatar.right;
                anchors.leftMargin: constant.paddingMedium;
                text: {
                    var a = modelData.author;
                    return a.name_show + (a.is_like == 1?"\nLv."+a.level_id:"");
                }
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
            Text {
                anchors.right: parent.right;
                text: modelData.floor + "#";
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }

        Repeater {
            model: modelData.contentData;
            Loader {
                anchors.left: parent.left;
                source: modelData[0] ? "../Component/PostLabel.qml" : "../Component/PostImage.qml";
            }
        }
        Text {
            anchors.right: parent.right;
            text: Qt.formatDateTime(new Date(modelData.time*1000),"yyyy-MM-dd hh:mm:ss");
            font {
                pixelSize: constant.fontSizeSmall;
                weight: Font.Light;
            }
            color: constant.colorMid;
        }
    }
    Row {
        anchors { left: root.paddingItem.left; bottom: root.paddingItem.bottom; }
        visible: modelData.floor !== "1";
        Image { id: replyIcon; y: 1; }
        Text {
            text: modelData.sub_post_number;
            font {
                pixelSize: constant.fontSizeSmall;
                weight: Font.Light;
            }
            color: constant.colorMid;
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
