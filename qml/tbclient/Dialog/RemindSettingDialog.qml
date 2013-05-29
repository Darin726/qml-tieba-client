import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root;

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }
    Component.onCompleted: open();

    titleText: qsTr("Remind Settings");
    buttonTexts: [qsTr("OK")];

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

    content: Item {
        width: platformContentMaximumWidth;
        height: Math.min(platformContentMaximumHeight, contentCol.height);

        Flickable {
            id: flickable;
            anchors.fill: parent;
            clip: true;
            contentWidth: parent.width;
            contentHeight: contentCol.height;
            Column {
                id: contentCol;
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingLarge; }
                spacing: platformStyle.paddingMedium;
                Item { width: 1; height: 1; }
                ListItemText {
                    text: qsTr("Remind Frequency");
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
                ListItemText {
                    text: qsTr("Remind Contents");
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
}
