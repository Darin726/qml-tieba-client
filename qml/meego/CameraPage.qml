import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1

Page {
    id: page;

    property Item caller: null;
    property alias camera: cameraLoader.item;

    orientationLock: PageOrientation.LockLandscape;
    onStatusChanged: {
        if (status == PageStatus.Active){
            cameraLoader.sourceComponent = cameraComp;
        }
    }

    Loader {
        id: cameraLoader;
        anchors.fill: parent;
        Component {
            id: cameraComp;
            Camera {
                captureResolution: Qt.size(1600, 1200);
                onImageSaved: page.state = "preview";
            }
        }
    }

    Connections {
        id: lockStatusListener;
        target: null;
        onLockStatusChanged: {
            if (camera.lockStatus == Camera.Locked){
                lockStatusListener.target = null;
                camera.captureImage();
            }
        }
    }

    Timer {
        id: lockTimer;
        interval: 200;
        onTriggered: if (camera) camera.searchAndLock();
    }

    Item {
        id: controls;

        z: 10;
        anchors.fill: parent;

        MouseArea {
            anchors.fill: parent;
            onPressed: {
                camera.unlock();
                lockTimer.restart();
            }
        }

        ToolIcon {
            anchors { left: parent.left; bottom: parent.bottom; margins: constant.paddingMedium; }
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }

        Button {
            anchors { left: parent.left; top: parent.top; margins: constant.paddingMedium; }
            platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
            iconSource: "image://theme/icon-m-toolbar-settings"+(theme.inverted?"-white":"");
            onClicked: flashModeSelector.open();
        }

        Button {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; margins: constant.paddingMedium; }
            platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
            iconSource: "image://theme/icon-m-toolbar-mediacontrol-play"+(theme.inverted?"-white":"");
            onClicked: {
                if (camera.lockStatus === Camera.Locked){
                    camera.captureImage();
                } else {
                    lockStatusListener.target = camera;
                    camera.unlock();
                    lockTimer.restart();
                }
            }
        }
    }

    Item {
        id: imagePreview;
        anchors.fill: parent;
        visible: false;
        Image {
            id: preview;
            anchors.fill: parent;
            fillMode: Image.PreserveAspectFit;
            source: "";
            cache: false;
            smooth: true;
        }
        Button {
            anchors { left: parent.left; bottom: parent.bottom; margins: constant.paddingMedium; }
            platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
            iconSource: "image://theme/icon-m-toolbar-cancle"+(theme.inverted?"-white":"");
            onClicked: {
                page.state = "";
                utility.removeFile(camera.capturedImagePath);
            }
        }
        Button {
            anchors { right: parent.right; bottom: parent.bottom; margins: constant.paddingMedium; }
            platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
            iconSource: "image://theme/icon-m-toolbar-done"+(theme.inverted?"-white":"");
            onClicked: {
                signalCenter.imageSelected(caller.toString(), camera.capturedImagePath);
                pageStack.pop();
            }
        }
    }

    SelectionDialog {
        id: flashModeSelector;
        titleText: qsTr("Flash Mode");
        selectedIndex: {
            if (!camera) return -1;
            switch (camera.flashMode){
            case Camera.FlashOff: return 0;
            case Camera.FlashOn: return 1;
            case Camera.FlashAuto: return 2;
            case Camera.FlashRedEyeReduction: return 3;
            default: return -1;
            }
        }
        model: [qsTr("Off"), qsTr("On"), qsTr("Auto"), qsTr("Red Eye Reduction")];
        onAccepted: {
            switch (selectedIndex){
            case 0: camera.flashMode = Camera.FlashOff; break;
            case 1: camera.flashMode = Camera.FlashOn; break;
            case 3: camera.flashMode = Camera.FlashRedEyeReduction; break;
            default: camera.flashMode = Camera.FlashAuto; break;
            }
        }
    }

    states: [
        State {
            name: "preview"
            PropertyChanges { target: cameraLoader; visible: false; }
            PropertyChanges { target: controls; visible: false; }
            PropertyChanges { target: imagePreview; visible: true; }
            PropertyChanges { target: preview; source: camera ? camera.capturedImagePath : ""; }
        }
    ]
}
