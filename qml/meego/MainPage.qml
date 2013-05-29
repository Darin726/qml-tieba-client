import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../js/main.js" as Script

Page {
    id: mainPage;

    property variant messagePage: null;
    property variant userPage: null;
    property variant morePage: null;

    tools: ToolBarLayout {
        ButtonRow {
            TabButton {
                iconSource: "image://theme/icon-m-toolbar-home"+(theme.inverted?"-white":"");
                tab: homePage;
                onClicked: homePage.homeButtonClicked();
            }
            TabButton {
                iconSource: "image://theme/icon-m-toolbar-new-message"+(theme.inverted?"-white":"");
                onClicked: {
                    if (!messagePage){
                        messagePage = Qt.createComponent("MessagePage.qml").createObject(tabGroup,
                                                                                         {pageStack: mainPage.pageStack});
                        tab = messagePage;
                        tabGroup.currentTab = messagePage;
                    }
                }
                CountBubble {
                    anchors {
                        right: parent.right; top: parent.top; margins: constant.paddingMedium;
                    }
                    value: autoCheck.replyme + autoCheck.atme;
                    visible: value > 0
                }
            }
            TabButton {
                iconSource: "image://theme/icon-m-toolbar-contact"+(theme.inverted?"-white":"");
                onClicked: {
                    if (!userPage){
                        var prop = { tools: null, uid: Script.uid, pageStack: mainPage.pageStack }
                        userPage = Qt.createComponent("UserPage.qml").createObject(tabGroup, prop);
                        try {
                            Script.loadUserProfile(utility.getCache("Profile"), {caller: userPage})
                        } catch(e){
                            userPage.getlist();
                        }
                        signalCenter.userChanged.connect(userPage.resetUser);
                        tab = userPage;
                        tabGroup.currentTab = userPage;
                    }
                }
                CountBubble {
                    anchors {
                        right: parent.right; top: parent.top; margins: constant.paddingMedium;
                    }
                    value: autoCheck.fans;
                    visible: value > 0
                }
            }
            TabButton {
                iconSource: "image://theme/icon-m-toolbar-settings"+(theme.inverted?"-white":"");
                onClicked: {
                    if (!morePage){
                        morePage = Qt.createComponent("MorePage.qml").createObject(tabGroup, { pageStack: mainPage.pageStack });
                        tab = morePage;
                        tabGroup.currentTab = morePage;
                    }
                }
            }
        }
    }

    TabGroup {
        id: tabGroup;
        anchors.fill: parent;
        currentTab: homePage;
        HomePage { id: homePage; pageStack: mainPage.pageStack; }
    }
}
