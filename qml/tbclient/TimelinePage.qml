import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "Delegate"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool loading: false;
    property int currentPage: 1;
    property bool hasMore: false;

    title: qsTr("My Posts");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            iconSource: "toolbar-back";
            toolTipText: qsTr("Back");
            onClicked: pageStack.pop();
        }
    }

    function getlist(option){
        option = option||"renew";
        var opt = new Object();
        if (option == "renew"){
            currentPage = 1;
            hasMore = false;
            listModel.clear();
            opt.pn = 1;
        } else if (option == "more"){
            opt.pn = currentPage + 1;
        }
        Script.getTimeline(page, opt);
    }

    Connections {
        target: signalCenter;
        onGetTimelineStarted: {
            if (caller == page.toString()){
                loading = true;
            }
        }
        onGetTimelineFinished: {
            if (caller == page.toString()){
                loading = false;
                worker.sendMessage({ list: list, model: listModel, option: "timeline" });
            }
        }
        onLoadFailed: {
            loading = false;
        }
    }

    ViewHeader {
        id: viewHeader;
        headerIcon: "gfx/contacts.svg";
        headerText: title;
        loading: page.loading;
        onClicked: view.positionViewAtBeginning();
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel { id: listModel; }
        delegate: TimelineDelegate {}
        header: PullToActivate {
            myView: view;
            visible: listModel.count == 0;
            enabled: !loading && visible;
            onRefresh: getlist();
        }
        footer: FooterItem {
            visible: listModel.count > 0 && hasMore;
            enabled: !loading;
            onClicked: getlist("more");
        }
        section {
            property: "time_shaft";
            delegate: sectionDelegate;
        }

        Component {
            id: sectionDelegate;
            Column {
                width: ListView.view ? ListView.view.width : parent.width;
                Row {
                    anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                    Image {
                        source: tbsettings.whiteTheme ? "gfx/icon_time_node.png"
                                                      : "gfx/icon_time_node_1.png";
                    }
                    ListItemText {
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Month %1").arg(section);
                        role: "SubTitle";
                        platformInverted: tbsettings.whiteTheme;
                    }
                }
                Rectangle {
                    anchors { left: parent.left; right: parent.right; }
                    height: 1;
                    color: tbsettings.whiteTheme ? platformStyle.colorDisabledLightInverted
                                                 : platformStyle.colorDisabledMid;
                }

            }
        }
    }

    SectionScroller {
        visible: view.count > 0;
        listView: view;
        platformInverted: tbsettings.whiteTheme;
    }

    Component.onCompleted: getlist();
}
