import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;
    onClicked: messagePage.openMenu(model);

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: constant.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: labelCol.height + constant.paddingMedium*3;
            BorderImage {
                anchors.fill: parent;
                border { left: 30; top: 10; right: 10; bottom: 30; }
                source: theme.inverted ? "../gfx/search_replay_back_1.9.png"
                                       : "../gfx/search_replay_back.9.png";
            }
            Image {
                id: avatar;
                anchors { left: parent.left; top: parent.top; margins: constant.paddingLarge; }
                width: constant.graphicSizeMedium;
                height: constant.graphicSizeMedium;
                sourceSize: Qt.size(width, height);
                opacity: status == Image.Ready ? 1 : 0;
                Behavior on opacity {
                    NumberAnimation { duration: 250; }
                }
            }
            Column {
                id: labelCol;
                anchors {
                    left: avatar.right; top: parent.top; right: parent.right;
                    margins: constant.paddingMedium;
                }
                spacing: constant.paddingSmall;
                Text {
                    text: model.replyer.name_show;
                    font {
                        pixelSize: constant.fontSizeSmall;
                        weight: Font.Light;
                    }
                    color: constant.colorMid;
                }
                Text {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    text: model.content;
                    font.pixelSize: constant.fontSizeLarge;
                    color: constant.colorLight;
                }
                Text {
                    anchors.right: parent.right;
                    text: Calc.formatDateTime(model.time*1000);
                    font {
                        pixelSize: constant.fontSizeSmall;
                        weight: Font.Light;
                    }
                    color: constant.colorMid;
                }
            }
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: forumShow.left; rightMargin: constant.paddingSmall; }
                text: model.type == 1 ? qsTr("Post:")+model.quote_content : qsTr("Thread:")+model.title;
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
                elide: Text.ElideRight;
            }
            Text {
                id: forumShow;
                anchors.right: parent.right;
                text: model.fname + qsTr("Bar");
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
            }
        }
    }
    function setSource(){
        if (tbsettings.showAvatar){
            avatar.source = Calc.getAvatar(model.replyer.portrait);
        } else {
            avatar.source = "../gfx/photo.png";
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
