import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import IAP 1.0

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
        headerText: qsTr("Donate");
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
            spacing: platformStyle.paddingLarge;
            Label {
                anchors {
                    left: parent.left; right: parent.right; margins: platformStyle.paddingLarge;
                }
                platformInverted: tbsettings.whiteTheme;
                wrapMode: Text.Wrap;
                text: qsTr("You can support further development of TBClient by donating a small sum.");
            }
            Label {
                anchors {
                    left: parent.left; right: parent.right; margins: platformStyle.paddingLarge;
                }
                platformInverted: tbsettings.whiteTheme;
                wrapMode: Text.Wrap;
                text: qsTr("Payment will be done via your Nokia Store account.")
            }
            Button {
                width: parent.width / 2;
                text: qsTr("Donate ￥1");
                platformInverted: tbsettings.whiteTheme;
                anchors.horizontalCenter: parent.horizontalCenter;
                onClicked: iap.purchaseProductByID("1046056");
            }
            Button {
                width: parent.width / 2;
                text:qsTr("Donate ￥2");
                platformInverted: tbsettings.whiteTheme;
                anchors.horizontalCenter: parent.horizontalCenter;
                onClicked: iap.purchaseProductByID("1046058");
            }
            Button {
                width: parent.width / 2;
                text: qsTr("Donate ￥5");
                platformInverted: tbsettings.whiteTheme;
                anchors.horizontalCenter: parent.horizontalCenter;
                onClicked: iap.purchaseProductByID("1046060");
            }
        }
    }

    QIap {
        id: iap;
        onPurchaseCompleted: {
            if (status === "OK"||true){
                dialog.createQueryDialog(qsTr("Thanks"),
                                         qsTr("Thank you for donating for this app"),
                                         qsTr("Yes"),
                                         "",
                                         pageStack.pop);
            }
        }
    }
}
