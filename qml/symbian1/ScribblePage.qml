import QtQuick 1.0
import com.nokia.symbian 1.0
import Scribble 1.0
import "Component"

MyPage {
    id: page;

    property Item caller: null;

    title: qsTr("Scribble");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            iconSource: "toolbar-back";
            toolTipText: qsTr("Back");
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Tools");
            iconSource: "gfx/toolbox.svg";
            onClicked: toolsMenu.open();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Clear");
            iconSource: "toolbar-delete";
            onClicked: scribbleArea.clear();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("OK");
            iconSource: "gfx/ok.svg";
            onClicked: save();
        }
    }

    function save(){
        var file = "scribble_"+Qt.formatDateTime(new Date(), "yyyyMMddhhmmss")+".jpg";
        var url = tbsettings.savePath + "/" + file;
        if (scribbleArea.save(url)){
            signalCenter.imageSelected(caller.toString(), url);
            pageStack.pop();
        } else {
            signalCenter.showMessage(qsTr("Cannot Save Image"));
        }
    }

    ScribbleArea { id: scribbleArea; anchors.fill: parent; }

    Menu {
        id: toolsMenu;
        MenuLayout {
            MenuItem {
                text: qsTr("Pen Color");
                Rectangle {
                    anchors {
                        right: parent.right; top: parent.top; bottom: parent.bottom;
                        margins: platformStyle.paddingLarge;
                    }
                    width: height;
                    color: scribbleArea.color;
                }
                onClicked: {
                    scribbleArea.color = utility.selectColor(scribbleArea.color);
                }
            }
            MenuItem {
                text: qsTr("Pen Width");
                Label {
                    anchors { right: parent.right; rightMargin: platformStyle.paddingLarge; verticalCenter: parent.verticalCenter; }
                    text: scribbleArea.penWidth;
                }
                onClicked: widthSelector.open();
            }
            MenuItem {
                text: qsTr("Import Pictures");
                onClicked: {
                    var url = utility.selectImage();
                    if (url != "") scribbleArea.open(url);
                }
            }
        }
    }

    CustomDialog {
        id: widthSelector
        titleText: qsTr("Select pen width(Selected: %1)").arg(slider.value);
        buttonTexts: [ qsTr("OK"), qsTr("Cancel")];
        onButtonClicked: {
            if (index==0)
                scribbleArea.penWidth = slider.value;
        }
        content: Slider {
            id: slider
            anchors {
                left: parent.left;
                right: parent.right;
                margins: platformStyle.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            minimumValue: 1
            maximumValue: 40
            stepSize: 1
            value: scribbleArea.penWidth
        }
    }
}
