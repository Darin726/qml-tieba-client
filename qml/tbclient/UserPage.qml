import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "../js/main.js" as Script
import "../js/Calculate.js" as Calc

MyPage {
    id: page;

    property bool loading: false;
    property variant user: null;
    property double lastUpdate: 0;

    property string uid;
    property bool isMySelf: uid == Script.uid;
    property bool hasFollowed: user != null && user.has_concerned == 1;

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    title: qsTr("User Detail");

    function getlist(){
        var opt = { uid: uid, refreshCache: uid == Script.uid }
        Script.getUserProfile(page, opt)
    }

    function resetUser(){
        user = null;
        uid = Script.uid;
        if (uid) {
            if (page.status == PageStatus.Active){
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
        headerIcon: "gfx/contacts.svg"
        headerText: title;
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
                height: headerColumn.height + platformStyle.paddingLarge*2;
                Image {
                    anchors.fill: parent;
                    source: "gfx/banner.jpg";
                }
                Column {
                    id: headerColumn;
                    anchors {
                        left: parent.left; right: parent.right; top: parent.top;
                        margins: platformStyle.paddingLarge;
                    }
                    spacing: platformStyle.paddingLarge*2;
                    Row {
                        spacing: platformStyle.paddingLarge;
                        Image {
                            width: platformStyle.graphicSizeLarge;
                            height: platformStyle.graphicSizeLarge;
                            source: user ? Calc.getAvatar(user.portrait) : "";
                            cache: false;
                        }
                        ListItemText {
                            anchors.verticalCenter: parent.verticalCenter;
                            text: user ? user.name_show : qsTr("(Loading...)");
                        }
                        Image {
                            anchors.verticalCenter: parent.verticalCenter;
                            source: user ? user.sex == "1" ? "gfx/male.png" : "gfx/female.png" : "";
                        }
                        Button {
                            anchors.verticalCenter: parent.verticalCenter;
                            iconSource: "gfx/edit.svg";
                            visible: isMySelf;
                            enabled: user != null;
                            onClicked: pageStack.push(Qt.resolvedUrl("EditProfilePage.qml"),
                                                      { caller: page });
                        }
                    }
                    Label {
                        anchors { left: parent.left; right: parent.right; }
                        wrapMode: Text.Wrap;
                        text: user ? user.intro : qsTr("(Loading...)");
                    }
                }
            }
            DetailItem {
                enabled: user != null;
                platformInverted: tbsettings.whiteTheme;
                title: qsTr("Like Forum Num");
                subTitle: user ? user.like_forum_num : qsTr("(Loading...)");
                onClicked: {
                    var prop = { uid: uid };
                    var p = pageStack.push(Qt.resolvedUrl("FavForumListPage.qml"), prop);
                    p.getlist();
                }
            }
            DetailItem {
                enabled: user != null;
                platformInverted: tbsettings.whiteTheme;
                title: qsTr("Concern Num");
                subTitle: user ? user.concern_num : qsTr("(Loading...)");
                onClicked: {
                    var prop = { totalCount: user?user.concern_num:0, uid: uid };
                    var p = pageStack.push(Qt.resolvedUrl("FriendListPage.qml"), prop);
                    p.getlist();
                }
            }
            DetailItem {
                enabled: user != null;
                platformInverted: tbsettings.whiteTheme;
                title: qsTr("Fans Num");
                subTitle: user ? user.fans_num : qsTr("(Loading...)");
                onClicked: {
                    var prop = { totalCount: user?user.fans_num:0, type:"fans", uid: uid };
                    var p = pageStack.push(Qt.resolvedUrl("FriendListPage.qml"), prop);
                    p.getlist();
                }
            }
            DetailItem {
                platformInverted: tbsettings.whiteTheme;
                title: qsTr("My Posts");
                subTitle: qsTr("Click To View");
                visible: isMySelf;
                enabled: true;
                onClicked: pageStack.push(Qt.resolvedUrl("TimelinePage.qml"));
            }
            DetailItem {
                enabled: user != null;
                visible: !isMySelf;
                platformInverted: tbsettings.whiteTheme;
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
