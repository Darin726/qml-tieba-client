import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"

MyPage {
    id: page;

    title: qsTr("Settings");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    ViewHeader {
        id: viewHeader;
        enabled: false;
        headerIcon: privateStyle.toolBarIconPath("toolbar-settings");
        headerText: qsTr("Settings Center");
    }

    Flickable {
        id: flickable;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: parent.width;
        contentHeight: contentCol.height + platformStyle.paddingLarge*2;

        Column {
            id: contentCol;
            anchors {
                left: parent.left; top: parent.top; right: parent.right;
                topMargin: platformStyle.paddingLarge;
            }
            Column {
                anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                spacing: platformStyle.paddingLarge;
                CheckBox {
                    text: qsTr("Show Avatar");
                    checked: tbsettings.showAvatar;
                    onClicked: tbsettings.showAvatar = checked;
                }
                CheckBox {
                    text: qsTr("Show Image");
                    checked: tbsettings.showImage;
                    onClicked: tbsettings.showImage = checked;
                }
                CheckBox {
                    text: qsTr("Show Abstract");
                    checked: tbsettings.showAbstract;
                    onClicked: tbsettings.showAbstract = checked;
                }
                CheckBox {
                    text: qsTr("Share Location");
                    checked: tbsettings.shareLocation;
                    onClicked: tbsettings.shareLocation = checked;
                }
            }
            Label {
                anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                height: platformStyle.graphicSizeSmall;
                text: qsTr("Font Size");
                verticalAlignment: Text.AlignBottom;
            }
            Slider {
                minimumValue: platformStyle.fontSizeSmall;
                maximumValue: platformStyle.fontSizeSmall*2;
                value: tbsettings.fontSize;
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingLarge; }
                stepSize: 1;
                valueIndicatorVisible: true;
                onPressedChanged: {
                    if (!pressed){
                        tbsettings.fontSize = value;
                    }
                }
            }
            Label {
                anchors { left: parent.left; leftMargin: platformStyle.paddingLarge; }
                height: platformStyle.graphicSizeSmall;
                text: qsTr("Max Thread Count");
                verticalAlignment: Text.AlignBottom;
            }
            Slider {
                minimumValue: 1;
                maximumValue: 10;
                value: tbsettings.maxThreadCount;
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingLarge; }
                stepSize: 1;
                valueIndicatorVisible: true;
                onPressedChanged: {
                    if (!pressed){
                        tbsettings.maxThreadCount = value;
                    }
                }
            }
            Rectangle {
                width: parent.width; height: 1;
                color: platformStyle.colorDisabledMid;
            }
            SelectionListItem {
                title: qsTr("Background Image(Long Press To Clear)");
                subTitle: tbsettings.backgroundImage||qsTr("Default");
                onClicked: {
                    tbsettings.backgroundImage = utility.selectImage() || tbsettings.backgroundImage;
                }
                onPressAndHold: {
                    tbsettings.backgroundImage = "";
                }
            }
            SelectionListItem {
                title: qsTr("Remind Settings");
                subTitle: tbsettings.remindFrequency + qsTr("Minutes");
                property Component dialog: null;
                onClicked: {
                    if (!dialog) { dialog = Qt.createComponent("Dialog/RemindSettingDialog.qml"); }
                    dialog.createObject(page);
                }
            }
            SelectionListItem {
                title: qsTr("Image Save Path");
                subTitle: tbsettings.savePath;
                onClicked: {
                    tbsettings.savePath = utility.selectFolder()||tbsettings.savePath;
                }
            }
            SelectionListItem {
                title: qsTr("Post Tail");
                subTitle: tbsettings.clientType == 3 ? "WindowsPhone" : tbsettings.clientType == 2 ? "Android" : "iPhone";
                property Component dialog: null;
                onClicked: {
                    if (!dialog){ dialog = Qt.createComponent("Dialog/SetClientTypeDialog.qml"); }
                    dialog.createObject(page);
                }
            }
            SelectionListItem {
                title: qsTr("Sign Text");
                subTitle: tbsettings.signText.replace(/(^\s*)|(\s*$)/g,"").replace(/\s/g," ")||qsTr("Click To Set");
                property Component dialog: null;
                onClicked: {
                    if (!dialog){ dialog = Qt.createComponent("Dialog/SetSignDialog.qml"); }
                    dialog.createObject(page);
                }
            }
            SelectionListItem {
                title: qsTr("Custom Emoticon");
                subTitle: qsTr("Click To Set");
                onClicked: pageStack.push(Qt.resolvedUrl("CustomEmoPage.qml"));
            }
            SelectionListItem {
                title: qsTr("Clear Network Cache");
                Component.onCompleted: setSubTitle();
                onClicked: {
                    utility.clearNetworkCache();
                    signalCenter.showMessage(qsTr("Cache is cleared"));
                    setSubTitle();
                }
                function setSubTitle(){
                    subTitle = qsTr("Current:")+Math.round(utility.cacheSize()/1024)+"kb";
                }
            }
        }
    }

}
