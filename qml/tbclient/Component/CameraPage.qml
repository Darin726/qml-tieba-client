import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMultimediaKit 1.1

MyPage {
    id: cameraPage

    property Item caller

    property string preview
    property string path

    onStatusChanged: {
        if (status == PageStatus.Active){
            state = "capture"
        } else if (status == PageStatus.Deactivating){
            state = ""
        }
    }

    states: [
        State {
            name: "capture"
            PropertyChanges { target: cameraArea; visible: true }
            PropertyChanges { target: flic; visible: false }
            PropertyChanges { target: pic; source: "" }
            PropertyChanges { target: cameraPage; title: "拍照" }
        },
        State {
            name: "preview"
            PropertyChanges { target: cameraArea; visible: false }
            PropertyChanges { target: flic; visible: true }
            PropertyChanges { target: pic; source: cameraPage.preview }
            PropertyChanges { target: cameraPage; title: "预览" }
        }
    ]

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        ToolButton {
            text: "重拍";
            visible: cameraPage.state == "preview"
            onClicked: {
                utility.removeFile(cameraPage.path)
                cameraPage.state = "capture"
            }
        }
        ToolButton {
            iconSource: "qrc:/gfx/ok%1.svg".arg(platformInverted?"_inverted":"")
            onClicked: {
                if (cameraPage.state == "preview"){
                    signalCenter.imageSelected(caller.toString(), cameraPage.path)
                    pageStack.pop()
                } else if (cameraPage.state == "capture") {
                    camera.captureImage()
                }
            }
        }
    }

    Rectangle {
        id: cameraArea
        anchors.fill: parent; color: "#000000"
        visible: false;

        Camera {
            id: camera
            onVisibleChanged: {
                if (visible) camera.start()
                else camera.stop()
            }
            focus: visible
            flashMode: Camera.FlashAuto;
            width: 360; height: 270; anchors.centerIn: parent
            captureResolution: Qt.size(1600, 1200)
            onLockStatusChanged: {
                if ( lockStatus == Camera.Locked ){
                    captureImage()
                }
            }
            onImageCaptured: {
                cameraPage.preview = preview
            }
            onImageSaved: {
                cameraPage.path = path
                cameraPage.state = "preview"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: camera.searchAndLock()
            }
        }
        Slider {
            anchors {
                bottom: parent.bottom; horizontalCenter: parent.horizontalCenter;
                bottomMargin: platformStyle.paddingLarge
            }
            width: parent.width * 0.7

            value: camera.digitalZoom
            maximumValue: camera.maximumDigitalZoom
            minimumValue: 1.0
            stepSize: 0.1

            valueIndicatorVisible: true
            valueIndicatorText: Math.round(value*10)/10 + "x"

            onPressedChanged: {
                if (!pressed)
                    camera.digitalZoom = value
            }
        }
    }
    Flickable {
        id: flic;
        anchors.fill: parent;
        visible: false
        clip: true
        contentWidth: Math.max(pic.width*pic.scale, width);
        contentHeight: Math.max(pic.height*pic.scale, height);
        function calcScale(){
            return pic.sourceSize.height/pic.sourceSize.width < flic.height/flic.width
                    ? flic.width/pic.sourceSize.width
                    : flic.height/pic.sourceSize.height
        }

        Image {
            id: pic
            anchors.centerIn: parent
            source: ""
            smooth: true;
            cache: false
            onStatusChanged: {
                if (status == Image.Ready){
                    scale = flic.calcScale()
                }
            }
        }

        PinchArea {
            property real oldScale
            anchors.fill: parent
            onPinchStarted: oldScale = pic.scale
            onPinchUpdated: {
                pic.scale = oldScale * pinch.scale
            }
        }

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                pic.scale = flic.calcScale()
            }
        }
    }
}
