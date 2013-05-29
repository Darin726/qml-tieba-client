import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "../js/main.js" as Script
import "../js/Calculate.js" as Calc

Page {
    id: page;

    property bool loading: false;
    property variant user: null;
    property double lastUpdate: 0;

    property string uid;
    property bool isMySelf: uid == Script.uid;
    property bool hasFollowed: user != null && user.has_concerned == 1;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    function getlist(){
        var opt = { uid: uid, refreshCache: uid == Script.uid }
        Script.getUserProfile(page, opt)
    }

    function resetUser(){
        user = null;
        uid = Script.uid;
        if (uid) {
            if (page.visible){
                getlist();
            } else {
                resetUserConnections.target = page;
            }
        }
    }

    Connections {
        target: signalCenter;
        onGetUserProfileStarted: {
            if (caller == page.toString()){ loading = true; }
        }
        onGetUserProfileFinished: {
            if (caller == page.toString()){ loading = false; }
        }
        onLoadFailed: loading = false;
        onFollowFinished: {
            if (caller == page.toString()){ hasFollowed = isfollow; }
        }
    }

    Connections {
        id: resetUserConnections;
        target: null;
        onStatusChanged: {
            if (page.status == PageStatus.Active){
                resetUserConnections.target = null;
                getlist();
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        headerText: qsTr("User Detail");
        loading: page.loading;
    }

    Flickable {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: width;
        contentHeight: contentCol.height;
        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            PullToActivate { myView: view; lastUpdateTime: page.lastUpdate; onRefresh: getlist(); }
            Item {
                id: headerItem;
                anchors { left: parent.left; right: parent.right; }
                height: headerColumn.height + constant.paddingLarge*2;
                Image {
                    anchors.fill: parent;
                    source: "gfx/banner.jpg";
                }
                Column {
                    id: headerColumn;
                    anchors {
                        left: parent.left; right: parent.right; top: parent.top;
                        margins: constant.paddingLarge;
                    }
                    spacing: constant.paddingLarge*2;
                    Row {
                        spacing: constant.paddingLarge;
                        Image {
                            width: constant.graphicSizeLarge;
                            height: constant.graphicSizeLarge;
                            source: user ? Calc.getAvatar(user.portrait) : "";
                            cache: false;
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter;
                            text: user ? user.name_show : qsTr("(Loading...)");
                            font {
                                pixelSize: constant.fontSizeXLarge;
                                weight: Font.Bold;
                            }
                            color: "white";
                        }
                        Image {
                            anchors.verticalCenter: parent.verticalCenter;
                            source: user ? user.sex == "1" ? "gfx/male.png" : "gfx/female.png" : "";
                        }
                        ToolButton {
                            anchors.verticalCenter: parent.verticalCenter;
                            platformStyle: ToolButtonStyle { buttonWidth: buttonHeight; inverted: true; }
                            iconSource: "image://theme/icon-m-toolbar-edit-white";
                            visible: isMySelf;
                            enabled: user != null;
                            onClicked: pageStack.push(Qt.resolvedUrl("EditProfilePage.qml"),
                                                      { caller: page });
                        }
                    }
                    Text {
                        anchors { left: parent.left; right: parent.right; }
                        wrapMode: Text.Wrap;
                        text: user ? user.intro : qsTr("(Loading...)");
                        font.pixelSize: constant.fontSizeMedium;
                        color: "white";
                    }
                }
            }
            DetailItem {
                inverted: theme.inverted;
                enabled: user != null;
                title: qsTr("Like Forum Num");
                subTitle: user ? user.like_forum_num : qsTr("(Loading...)");
                onClicked: {
                    var prop = { uid: uid };
                    var p = pageStack.push(Qt.resolvedUrl("FavForumListPage.qml"), prop);
                    p.getlist();
                }
            }
            DetailItem {
                inverted: theme.inverted;
                enabled: user != null;
                title: qsTr("Concern Num");
                subTitle: user ? user.concern_num : qsTr("(Loading...)");
                onClicked: {
                    var prop = { totalCount: user?user.concern_num:0, uid: uid };
                    var p = pageStack.push(Qt.resolvedUrl("FriendListPage.qml"), prop);
                    p.getlist();
                }
            }
            DetailItem {
                inverted: theme.inverted;
                enabled: user != null;
                title: qsTr("Fans Num");
                subTitle: user ? user.fans_num : qsTr("(Loading...)");
                onClicked: {
                    var prop = { totalCount: user?user.fans_num:0, type:"fans", uid: uid };
                    var p = pageStack.push(Qt.resolvedUrl("FriendListPage.qml"), prop);
                    p.getlist();
                }
            }
            DetailItem {
                inverted: theme.inverted;
                title: qsTr("My Posts");
                subTitle: qsTr("Click To View");
                visible: isMySelf;
                enabled: true;
                onClicked: pageStack.push(Qt.resolvedUrl("TimelinePage.qml"));
            }
            DetailItem {
                inverted: theme.inverted;
                enabled: user != null;
                visible: !isMySelf;
                title: qsTr("Has Concerned");
                subTitle: user ? page.hasFollowed ? qsTr("True") : qsTr("False") : qsTr("(Loading...)");
                onClicked: {
                    var opt = { portrait: user.portrait, isfollow: !page.hasFollowed }
                    Script.followUser(page, opt);
                }
            }
        }
    }
}
