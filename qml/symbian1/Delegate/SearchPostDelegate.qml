import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Calc;

AbstractDelegate {
    id: root;

    implicitHeight: contentCol.height + platformStyle.paddingLarge*2;
    onClicked: {
        app.enterFloor({threadId: model.tid, postId: model.pid});
    }

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left;
            top: root.paddingItem.top;
            right: root.paddingItem.right;
        }
        spacing: platformStyle.paddingSmall;
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: titleLabel.paintedHeight + platformStyle.paddingLarge*3;
            visible: model.content != "";
            Loader {
                id: bgLoader;
                anchors.fill: parent;
                Component {
                    id: bgComp;
                    BorderImage {
                        border { left: 30; top: 10; right: 10; bottom: 20; }
                        source: "../gfx/search_replay_back_1.9.png";
                    }
                }
            }
            Text {
                id: titleLabel;
                anchors {
                    left: parent.left; top: parent.top; right: parent.right;
                    margins: platformStyle.paddingLarge;
                }
                text: model.content;
                wrapMode: Text.Wrap;
                font.pixelSize: platformStyle.fontSizeLarge;
                color: "white";
            }
        }
        Text {
            anchors { left: parent.left; right: parent.right; }
            text: model.title;
            font {
                family: platformStyle.fontFamilyRegular;
                pixelSize: platformStyle.fontSizeMedium;
                weight: Font.Light;
            }
            color: symbianStyle.colorMid;
            textFormat: Text.StyledText;
            wrapMode: Text.Wrap;
            elide: Text.ElideRight;
        }
        Item {
            anchors { left: parent.left; right: parent.right; }
            height: childrenRect.height;
            Text {
                text: model.name;
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
            }
            Text {
                text: model.fname + qsTr("Bar");
                anchors { right: timeShow.left; rightMargin: platformStyle.paddingMedium; }
                font {
                    family: platformStyle.fontFamilyRegular;
                    pixelSize: platformStyle.fontSizeSmall;
                    weight: Font.Light;
                }
                color: symbianStyle.colorMid;
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
        id: setBgConnections;
        target: null;
        onMovementEnded: {
            setBgConnections.target = null;
            bgLoader.sourceComponent = bgComp;
        }
    }

    Component.onCompleted: {
        if (ListView.view && !ListView.view.moving){
            bgLoader.sourceComponent = bgComp;
        } else {
            setBgConnections.target = ListView.view;
        }
    }
}
