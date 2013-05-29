import QtQuick 1.0
import com.nokia.symbian 1.0
import CustomWebKit 1.0
import "Component"
import "../js/main.js" as Script

MyPage {
    id: page;

    property int currentIndex: 0;
    property alias listModel: view.model;
    property variant caller: null;

    onStatusChanged: {
        if (status == PageStatus.Active){
            initialize();
        }
    }

    function initialize(){
        view.positionViewAtIndex(currentIndex, ListView.Beginning);
        view.currentIndex = page.currentIndex;
        currentIndexBinding.when = true;
    }

    title: caller ? caller.thread.title : "";

    tools: ToolBarLayout {
        ToolButtonWithTip {
            iconSource: "toolbar-back";
            toolTipText: qsTr("Back");
            onClicked: {
                if (caller){ caller.listView.positionViewAtIndex(currentIndex, ListView.Beginning); }
                pageStack.pop();
            }
        }
        ToolButtonWithTip {
            text: qsTr("Prev");
            toolTipText: qsTr("Previous Floor");
            onClicked: view.decrementCurrentIndex();
        }
        ToolButtonWithTip {
            text: qsTr("Next");
            toolTipText: qsTr("Next Floor");
            onClicked: view.incrementCurrentIndex();
        }
        ToolButtonWithTip {
            enabled: view.currentItem != null;
            toolTipText: qsTr("Add to bookmark");
            iconSource: "gfx/add_bookmark.svg";
            onClicked: {
                var t = caller.thread;
                app.addBookmark(t.id, listModel.get(currentIndex).modelData.id, t.author.name_show, t.title, caller.isLz);
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        headerIcon: "gfx/web_page.svg";
        headerText: view.currentItem ? listModel.get(currentIndex).modelData.floor + qsTr("#") : page.title;
        enabled: false;
        loading: view.currentItem ? view.currentItem.loading : false;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        interactive: false;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        highlightMoveDuration: 400;
        snapMode: ListView.SnapOneItem;
        delegate: articleItemComp;
        Component {
            id: articleItemComp;
            ImplicitSizeItem {
                id: root;

                property bool loading: false;

                implicitWidth: ListView.view ? ListView.view.width : screen.width;
                implicitHeight: ListView.view ? ListView.view.height : screen.height;

                Flickable {
                    id: flickable;
                    anchors.fill: parent;
                    clip: true;
                    contentWidth: webView.width;
                    contentHeight: webView.height;

                    WebView {
                        id: webView;
                        preferredWidth: root.width;
                        preferredHeight: root.height;
                        settings {
                            autoLoadImages: tbsettings.showImage;
                            defaultFixedFontSize: tbsettings.fontSize;
                            defaultFontSize: tbsettings.fontSize;
                        }
                        onLinkClicked: {
                            signalCenter.linkActivated(link);
                        }
                        onLoadStarted: root.loading = true;
                        onLoadFinished: root.loading = false;
                        onLoadFailed: root.loading = false;
                    }
                }
                ScrollDecorator { flickableItem: flickable; }
                function setSource(){
                    webView.html = Script.decodeFloorList(modelData.content);
                }
                Connections {
                    id: setSourceConnections;
                    target: null;
                    onMovementEnded: {
                        setSourceConnections.target = null;
                        root.setSource();
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
        }
    }

    Binding {
        id: currentIndexBinding;
        target: page;
        property: "currentIndex";
        value: view.currentIndex;
        when: false;
    }
}
