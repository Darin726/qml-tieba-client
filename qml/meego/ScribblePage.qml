import QtQuick 1.1
import com.nokia.meego 1.0
import Scribble 1.0
import "Component"

Sheet {
    id: page;

    property Item caller: null;

    property int __isPage;  //to make sheet happy
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            page.destroy(250);
        }
    }
    Component.onCompleted: open();

    acceptButtonText: qsTr("OK");
    rejectButtonText: qsTr("Cancel");

    title: SheetButton {
        anchors.centerIn: parent;
        platformStyle: SheetButtonStyle { buttonWidth: 100; }
        text: qsTr("Tools");
        onClicked: toolsMenu.open();
    }

    content: ScribbleArea {
        id: scribbleArea;
        anchors.fill: parent;
    }

    onAccepted: {
        var file = "scribble_"+Qt.formatDateTime(new Date(), "yyyyMMddhhmmss")+".jpg";
        var url = tbsettings.savePath + "/" + file;
        if (scribbleArea.save(url)){
            signalCenter.imageSelected(caller.toString(), url);
        } else {
            signalCenter.showMessage(qsTr("Cannot Save Image"));
        }
    }

    Connections {
        target: signalCenter;
        onImageSelected: {
            if (caller == page.toString() && url){
                scribbleArea.open(url.replace("file://",""));
            }
        }
    }

    Sheet {
        id: toolsMenu;
        property int __isPage;  //to make sheet happy

        acceptButtonText: qsTr("OK");

        title: Text {
            anchors { left: parent.left; leftMargin: constant.paddingXLarge; verticalCenter: parent.verticalCenter; }
            font.pixelSize: constant.fontSizeXXLarge;
            color: constant.colorLight;
            text: qsTr("Tools");
        }

        content: Flickable {
            anchors.fill: parent;
            contentWidth: width;
            contentHeight: contentCol.height;
            clip: true;

            Column {
                id: contentCol;
                width: parent.width;

                AboutPageItem {
                    iconSource: "image://theme/icon-m-toolbar-delete"+(theme.inverted?"-white":"");
                    text: qsTr("Clear");
                    onClicked: { scribbleArea.clear(); toolsMenu.accept(); }
                }
                AboutPageItem {
                    iconSource: "image://theme/icon-m-toolbar-add"+(theme.inverted?"-white":"");
                    text: qsTr("Import Pictures");
                    onClicked: { dialog.launchGallery(page); toolsMenu.accept(); }
                }

                SectionHeader { text: qsTr("Select pen width(Selected: %1)").arg(slider.value); }

                Slider {
                    id: slider
                    anchors {
                        left: parent.left;
                        right: parent.right;
                        margins: constant.paddingLarge;
                    }
                    minimumValue: 1
                    maximumValue: 40
                    stepSize: 1
                    value: scribbleArea.penWidth
                    onPressedChanged: {
                        if (!pressed){
                            scribbleArea.penWidth = slider.value;
                        }
                    }
                }

                SectionHeader { text: qsTr("Pen Color"); }

                Rectangle {
                    id: indicator;
                    anchors {
                        left: parent.left;
                        right: parent.right;
                        margins: constant.paddingLarge;
                    }
                    height: constant.graphicSizeSmall;
                    color: scribbleArea.color;
                }

                Repeater {
                    model: 4;
                    Slider {
                        objectName: "colorS";
                        anchors {
                            left: parent.left;
                            right: parent.right;
                            margins: constant.paddingLarge;
                        }
                        minimumValue: 0;
                        maximumValue: 255;
                        stepSize: 1;
                        valueIndicatorVisible: true;
                        onPressedChanged: {
                            if (!pressed){
                                scribbleArea.color = toolsMenu.getColorValue();
                            }
                        }
                        value: index == 3 ? 255 : 0;
                    }
                }
            }
        }
        function getColorValue(){
            var v = [];
            for (var i=0; i<contentCol.children.length; i++){
                var c = contentCol.children[i];
                if (c.objectName == "colorS"){
                    v.push(c.value/255);
                }
            }
            return Qt.rgba(v[0], v[1], v[2], v[3]);
        }
    }
}
