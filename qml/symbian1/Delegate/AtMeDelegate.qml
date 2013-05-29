import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;
    onClicked: messagePage.openMenu(model);

    Image {
        id: avatar;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; }
        width: platformStyle.graphicSizeMedium;
        height: platformStyle.graphicSizeMedium;
        opacity: status == Image.Ready ? 1 : 0;
        Behavior on opacity { NumberAnimation { duration: 250; } }
    }
    Column {
        id: contentCol;
        anchors {
            left: avatar.right;
            top: parent.top;
            right: parent.right;
            margins: platformStyle.paddingLarge;
        }
        spacing: platformStyle.paddingSmall;
        Text {
            text: model.replyer.name_show;
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeSmall;
                weight: Font.Light;
            }
            color: symbianStyle.colorMid;
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            text: model.content;
            wrapMode: Text.Wrap;
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeLarge;
            }
            color: symbianStyle.colorLight;
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: timeShow.left; rightMargin: platformStyle.paddingSmall; }
                text: model.fname+qsTr("Bar");
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
                elide: Text.ElideRight;
            }
            Text {
                id: timeShow;
                anchors.right: parent.right;
                text: Calc.formatDateTime(model.time*1000);
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
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
