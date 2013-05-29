import QtQuick 1.1
import com.nokia.meego 1.0
import CustomWebKit 1.0
import "Component"
import "../js/main.js" as Script

Sheet {
    id: page;

    property int currentIndex: 0;
    property alias listModel: view.model;
    property variant caller: null;

    property int __isPage;  //to make sheet happy
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            page.destroy(250);
        } else if (status == DialogStatus.Open){
            initialize();
        }
    }
    Component.onCompleted: open();

    function initialize(){
        view.positionViewAtIndex(currentIndex, ListView.Beginning);
        view.currentIndex = page.currentIndex;
        currentIndexBinding.when = true;
    }

    buttons: [
        SheetButton {
            id: rejectButton
            objectName: "rejectButton"
            anchors.left: parent.left
            anchors.leftMargin: page.platformStyle.rejectButtonLeftMargin
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Prev");
            onClicked: view.decrementCurrentIndex();
        },
        SheetButton {
            id: acceptButton
            objectName: "acceptButton"
            anchors.right: parent.right
            anchors.rightMargin: page.platformStyle.acceptButtonRightMargin
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Next");
            onClicked: view.incrementCurrentIndex();
        }
    ]

    title: SheetButton {
        text: qsTr("Back");
        platformStyle: SheetButtonStyle { buttonWidth: 100; }
        anchors.centerIn: parent;
        onClicked: {
            if (caller){ caller.listView.positionViewAtIndex(currentIndex, ListView.Beginning); }
            page.accept();
        }
    }

    content: ListView {
        id: view;
        anchors.fill: parent;
        clip: true;
        interactive: false;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        highlightMoveDuration: 400;
        snapMode: ListView.SnapOneItem;
        header: Item {
            width: view.width;
            height: constant.fontSizeXLarge;
            Text {
                anchors { left: parent.left; leftMargin: constant.paddingMedium; verticalCenter: parent.verticalCenter; }
                text: view.currentItem ? listModel.get(currentIndex).modelData.author.name_show : '';
                font.pixelSize: constant.fontSizeMedium;
                color: constant.colorMid;
            }
            Text {
                anchors { right: parent.right; rightMargin: constant.paddingMedium; verticalCenter: parent.verticalCenter; }
                text: view.currentItem ? listModel.get(currentIndex).modelData.floor + qsTr("#") : "";
                font.pixelSize: constant.fontSizeMedium;
                color: constant.colorMid;
            }
        }
        delegate: articleItemComp;
        Component {
            id: articleItemComp;
            Item {
                id: root;

                property bool loading: false;

                implicitWidth: ListView.view ? ListView.view.width : view.width;
                implicitHeight: ListView.view ? ListView.view.height : view.height;

                Flickable {
                    id: flickable;
                    anchors.fill: parent;
                    clip: true;
                    contentWidth: width;
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
                            page.accept();
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
