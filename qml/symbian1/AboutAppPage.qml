import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"

MyPage {
    id: page;

    title: viewHeader.headerText;

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    ViewHeader {
        id: viewHeader;
        headerIcon: "gfx/information_userguide.svg";
        headerText: qsTr("About Application");
        enabled: false;
    }
    Flickable {
        id: flickable;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: parent.width;
        contentHeight: contentCol.height;
        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            SectionHeader { text: qsTr("About Application"); }
            Item {
                anchors { left: parent.left; right: parent.right; }
                height: aboutText.height + platformStyle.paddingMedium*2;
                Label {
                    id: aboutText;
                    anchors {
                        verticalCenter: parent.verticalCenter;
                        left: parent.left; right: parent.right;
                        margins: platformStyle.paddingMedium;
                    }
                    wrapMode: Text.Wrap;
                    text: qsTr("This is a feature-rich Baidu Tieba client for smartphones, powered by Qt and QML. \
It has a simple, native and easy-to-use UI that will surely make you enjoy the Tieba experience on your \
smartphone.")
                }
            }
            SectionHeader { text: qsTr("Version"); }
            Item {
                anchors { left: parent.left; right: parent.right; }
                height: versionText.height + platformStyle.paddingMedium*2;
                Label {
                    id: versionText;
                    anchors {
                        verticalCenter: parent.verticalCenter;
                        left: parent.left; right: parent.right;
                        margins: platformStyle.paddingMedium;
                    }
                    text: tbsettings.appVersion;
                }
            }
            SectionHeader { text: qsTr("Author"); }
            AboutPageItem {
                iconSource: "gfx/about_yeatse.png";
                text: qsTr("Yeatse");
                onClicked: signalCenter.linkActivated("at:135798151");
            }
            SectionHeader { text: qsTr("Special Thanks") }
            AboutPageItem {
                iconSource: "gfx/about_yxz.png";
                text: qsTr("yxz0539");
                onClicked: signalCenter.linkActivated("at:37805971");
            }
            AboutPageItem {
                iconSource: "gfx/about_dospy.png";
                text: qsTr("MengYingJueHuan");
                onClicked: signalCenter.linkActivated("at:447109148");
            }
            AboutPageItem {
                iconSource: "gfx/about_noki.png";
                text: qsTr("Noki Bar");
                onClicked: app.enterForum("诺记");
            }
            SectionHeader { text: qsTr("Contact me"); }
            AboutPageItem {
                iconSource: "gfx/about_tieba.png";
                text: qsTr("Tieba");
                onClicked: app.enterThread({"threadId":"1543868126"});
            }
            AboutPageItem {
                iconSource: "gfx/about_sina.png";
                text: qsTr("Weibo");
                onClicked: utility.openURLDefault("http://m.weibo.cn/u/1786664917");
            }
            AboutPageItem {
                iconSource: "gfx/about_tbclient.png";
                text: qsTr("Project Homepage");
                onClicked: utility.openURLDefault("http://code.google.com/p/qml-tieba-client/");
            }
            SectionHeader { text: qsTr("Agreements"); }
            AboutPageItem {
                iconSource: "gfx/about_tieba.png";
                text: qsTr("Tieba Agreements");
                onClicked: utility.openURLDefault("http://static.tieba.baidu.com/tb/eula.html");
            }
        }
    }
}
