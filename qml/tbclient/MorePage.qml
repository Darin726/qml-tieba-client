import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

MyPage {
    id: morePage;

    title: qsTr("More");

    tools: mainTools;

    ViewHeader {
        id: viewHeader;
        headerIcon: "gfx/applications.svg";
        headerText: morePage.title;
        enabled: false;
    }

    Flickable {
        id: flickable;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: width;
        contentHeight: contentGrid.height + platformStyle.paddingLarge*2;

        Grid {
            id: contentGrid;
            anchors {
                top: parent.top; topMargin: platformStyle.paddingLarge;
                horizontalCenter: parent.horizontalCenter;
            }
            columns: screen.width > screen.height ? 5 : 3;
            spacing: Math.floor((screen.width - 100*columns)/(columns+1));
            MoreItem {
                iconSource: "gfx/more_1.png";
                text: qsTr("Tab Pg");
                onClicked: app.enterThread();
            }
            MoreItem {
                iconSource: "gfx/more_7.png";
                text: qsTr("Recom.");
                onClicked: {
                    if (!app.recomPage){ app.recomPage = Qt.createComponent("RecommendPage.qml").createObject(app); }
                    pageStack.push(app.recomPage);
                }
            }
            MoreItem {
                iconSource: "gfx/more_2.png";
                text: qsTr("Nearby");
                onClicked: pageStack.push(Qt.resolvedUrl("NearbyPage.qml"));
            }
            MoreItem {
                iconSource: "gfx/more_8.png";
                text: qsTr("Accou.");
                onClicked: pageStack.push(Qt.resolvedUrl("AccountPage.qml"));
            }
            MoreItem {
                iconSource: "gfx/more_5.png";
                text: qsTr("Sign Mgr.");
                onClicked: {
                    if (!app.signPage){ app.signPage = Qt.createComponent("BatchSignPage.qml").createObject(app); }
                    pageStack.push(app.signPage);
                }
            }
            MoreItem {
                iconSource: "gfx/more_6.png";
                text: qsTr("Bookm.");
                onClicked: pageStack.push(Qt.resolvedUrl("BookmarkPage.qml"));
            }
            MoreItem {
                iconSource: "gfx/more_3.png";
                text: qsTr("Setti.");
                onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"));
            }
            MoreItem {
                iconSource: "gfx/more_4.png";
                text: qsTr("About");
                onClicked: pageStack.push(Qt.resolvedUrl("AboutAppPage.qml"));
            }
        }
    }
}
