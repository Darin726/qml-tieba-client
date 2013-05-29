import QtQuick 1.1
import com.nokia.meego 1.0

Sheet {
    id: root;

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: open();

    acceptButtonText: qsTr("OK");

    QtObject {
        id: internal;
        function getValue(){
            switch (tbsettings.remindFrequency){
            case 0: return 0;
            case 1: return 1;
            case 2: return 2;
            case 5: return 3;
            default: return 4;
            }
        }
        function getValueText(){
            switch (slider.value){
            case 0: return qsTr("Disabled");
            case 1: return qsTr("1 Minute");
            case 2: return qsTr("2 Minutes");
            case 3: return qsTr("5 Minutes");
            default: return qsTr("30 Minutes");
            }
        }
        function setValue(){
            switch (slider.value){
            case 0: return 0;
            case 1: return 1;
            case 2: return 2;
            case 3: return 5;
            default: return 30;
            }
        }
    }

    title: Text {
        font.pixelSize: constant.fontSizeXXLarge;
        color: constant.colorLight;
        anchors { left: parent.left; leftMargin: constant.paddingXLarge; verticalCenter: parent.verticalCenter; }
        text: qsTr("Remind Settings");
    }

    content: Flickable {
        id: flickable;
        anchors.fill: parent;
        clip: true;
        contentWidth: parent.width;
        contentHeight: contentCol.height;
        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
            spacing: constant.paddingMedium;
            Item { width: 1; height: 1; }
            Text {
                text: qsTr("Remind Frequency");
                font.pixelSize: constant.fontSizeLarge;
                color: constant.colorLight;
            }
            Slider {
                id: slider;
                width: parent.width;
                minimumValue: 0;
                maximumValue: 4;
                stepSize: 1;
                value: internal.getValue();
                valueIndicatorVisible: true;
                valueIndicatorText: internal.getValueText();
                onPressedChanged: {
                    if (!pressed){
                        tbsettings.remindFrequency = internal.setValue();
                    }
                }
            }
            Text {
                text: qsTr("Remind Contents");
                font.pixelSize: constant.fontSizeLarge;
                color: constant.colorLight;
            }
            CheckBox {
                checked: tbsettings.remindBackground;
                text: qsTr("Remind at background");
                onClicked: tbsettings.remindBackground = checked;
            }
            CheckBox {
                checked: tbsettings.remindFans;
                text: qsTr("New fans");
                onClicked: tbsettings.remindFans = checked;
            }
            CheckBox {
                checked: tbsettings.remindReplyme;
                text: qsTr("Reply me");
                onClicked: tbsettings.remindReplyme = checked;
            }
            CheckBox {
                checked: tbsettings.remindAtme;
                text: qsTr("At me");
                onClicked: tbsettings.remindAtme = checked;
            }
        }
    }
}
