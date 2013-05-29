import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

Page {
    id: page;

    property bool loading: false;
    property string uid: Script.uid;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    function getlist(){
        var opt = { model: listModel };
        if (uid != Script.uid){
            opt.uid = uid;
        }
        Script.getLikeForum(page, opt);
    }

    Connections {
        target: signalCenter;
        onGetForumListStarted: {
            if (caller == page.toString()){ loading = true; }
        }
        onGetForumListFinished: {
            if (caller == page.toString()) { loading = false; }
        }
        onLoadFailed: loading = false;
    }

    ViewHeader {
        id: viewHeader;
        headerText: qsTr("Favourite Forums");
        loading: page.loading;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel { id: listModel; }
        delegate: delegateComp;
        header: PullToActivate {
            myView: view;
            onRefresh: getlist();
        }
        Component {
            id: delegateComp;
            AbstractDelegate {
                id: root;
                Column {
                    anchors.left: parent.paddingItem.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    Text {
                        text: model.name;
                        font.pixelSize: constant.fontSizeLarge;
                        color: constant.colorLight;
                    }
                    Text {
                        text: qsTr("Lv.")+model.level_id+"    "+model.level_name;
                        font {
                            pixelSize: constant.fontSizeSmall;
                            weight: Font.Light;
                        }
                        color: constant.colorMid;
                    }
                }
                onClicked: app.enterForum(model.name);
            }
        }
    }

    ScrollDecorator { flickableItem: view; }
}
