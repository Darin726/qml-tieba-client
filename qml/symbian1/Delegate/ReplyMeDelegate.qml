import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;
    onClicked: messagePage.openMenu(model);

    Column {
        id: contentCol;
        anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: root.paddingItem.right; }
        spacing: platformStyle.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: labelCol.height + platformStyle.paddingMedium*3;
            Loader {
                id: borderImageLoader;
                anchors.fill: parent;
                Component {
                    id: borderImageComp;
                    BorderImage {
                        border { left: 30; top: 10; right: 10; bottom: 30; }
                        source:  "../gfx/search_replay_back_1.9.png";
                    }
                }
            }
            Image {
                id: avatar;
                anchors { left: parent.left; top: parent.top; margins: platformStyle.paddingLarge; }
                width: platformStyle.graphicSizeMedium;
                height: platformStyle.graphicSizeMedium;
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
                    margins: platformStyle.paddingMedium;
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
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    text: model.content;
                    font {
                        family: platformStyle.fontFamilyRegular;
                        pixelSize: platformStyle.fontSizeLarge;
                    }
                    color: symbianStyle.colorLight;
                }
                Text {
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
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                anchors { left: parent.left; right: forumShow.left; rightMargin: platformStyle.paddingSmall; }
                text: model.type == 1 ? qsTr("Post:")+model.quote_content : qsTr("Thread:")+model.title;
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
                elide: Text.ElideRight;
            }
            Text {
                id: forumShow;
                anchors.right: parent.right;
                text: model.fname + qsTr("Bar");
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
            }
        }
    }
    function setSource(){
        borderImageLoader.sourceComponent = borderImageComp;
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
