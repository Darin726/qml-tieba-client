import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;
    onClicked: messagePage.openMenu(model);

    Image {
        id: avatar;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; }
        width: constant.graphicSizeMedium;
        height: constant.graphicSizeMedium;
        opacity: status == Image.Ready ? 1 : 0;
        Behavior on opacity { NumberAnimation { duration: 250; } }
    }
    Column {
        id: contentCol;
        anchors {
            left: avatar.right;
            top: parent.top;
            right: parent.right;
            margins: constant.paddingLarge;
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
            anchors { left: parent.left; right: parent.right; }
            text: model.content;
            wrapMode: Text.Wrap;
            font.pixelSize: constant.fontSizeLarge;
            color: constant.colorLight;
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: timeShow.left; rightMargin: constant.paddingSmall; }
                text: model.fname+qsTr("Bar");
                font {
                    pixelSize: constant.fontSizeSmall;
                    weight: Font.Light;
                }
                color: constant.colorMid;
                elide: Text.ElideRight;
            }
            Text {
                id: timeShow;
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

    Connections {
        id: setSourceConnections;
        target: null;
        onMovementEnded: {
            setSourceConnections.target = null;
            avatar.source = tbsettings.showAvatar ? Calc.getAvatar(model.replyer.portrait) : "../gfx/photo.png";
        }
    }

    Component.onCompleted: {
        if (!ListView.view || !ListView.view.moving ){
            avatar.source = tbsettings.showAvatar ? Calc.getAvatar(model.replyer.portrait) : "../gfx/photo.png";
        } else {
            setSourceConnections.target = ListView.view;
        }
    }
}
