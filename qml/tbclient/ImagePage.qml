import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

MyPage {
    id: imagePage

    property url imageUrl: ""

    property QtObject menu: null;
    property QtObject emoDialog: null;

    title: qsTr("Image Viewer");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            iconSource: "toolbar-back"
            toolTipText: qsTr("Back")
            onClicked: pageStack.pop()
        }
        ToolButtonWithTip {
            iconSource: "toolbar-menu";
            toolTipText: qsTr("Menu");
            enabled: imagePreview.status === Image.Ready;
            onClicked: {
                if (!menu){ menu = menuComp.createObject(imagePage); }
                menu.open();
            }
        }
    }

    Component {
        id: menuComp;
        Menu {
            MenuLayout {
                MenuItem {
                    text: qsTr("Save image");
                    onClicked: {
                        var path = tbsettings.savePath + "/" + imageUrl.toString().split("/").pop();
                        if (utility.saveCache(imageUrl, path)){
                            signalCenter.showMessage(qsTr("Image saved to ")+path);
                        } else {
                            downloader.appendDownload(imageUrl, path);
                        }
                    }
                }
                MenuItem {
                    text: qsTr("Add to custom emoticon");
                    enabled: /imgsrc.baidu.com\/forum\/pic\/item\/.*\.jpg/.test(imageUrl);
                    onClicked: {
                        if (!emoDialog){
                            var prop = { imgurl: imageUrl, picsize: Qt.size(imagePreview.paintedWidth, imagePreview.paintedHeight) };
                            emoDialog = Qt.createComponent("Dialog/AddEmoticonDialog.qml").createObject(imagePage, prop);
                        }
                        emoDialog.open();
                    }
                }
            }
        }
    }

    Flickable {
        id: imageFlickable
        anchors.fill: parent
        contentWidth: imageContainer.width; contentHeight: imageContainer.height
        clip: true
        onHeightChanged: if (imagePreview.status === Image.Ready) imagePreview.fitToScreen()

        Item {
            id: imageContainer
            width: Math.max(imagePreview.width * imagePreview.scale, imageFlickable.width)
            height: Math.max(imagePreview.height * imagePreview.scale, imageFlickable.height)

            Image {
                id: imagePreview

                property real prevScale

                function fitToScreen() {
                    scale = Math.min(imageFlickable.width / width, imageFlickable.height / height, 1)
                    pinchArea.minScale = scale
                    prevScale = scale
                }

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                cache: false
                asynchronous: true
                source: imageUrl
                sourceSize.height: 1000;
                smooth: !imageFlickable.moving

                onStatusChanged: {
                    if (status == Image.Ready) {
                        fitToScreen()
                        loadedAnimation.start()
                    }
                }

                NumberAnimation {
                    id: loadedAnimation
                    target: imagePreview
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }

                onScaleChanged: {
                    if ((width * scale) > imageFlickable.width) {
                        var xoff = (imageFlickable.width / 2 + imageFlickable.contentX) * scale / prevScale;
                        imageFlickable.contentX = xoff - imageFlickable.width / 2
                    }
                    if ((height * scale) > imageFlickable.height) {
                        var yoff = (imageFlickable.height / 2 + imageFlickable.contentY) * scale / prevScale;
                        imageFlickable.contentY = yoff - imageFlickable.height / 2
                    }
                    prevScale = scale
                }
            }
        }

        PinchArea {
            id: pinchArea

            property real minScale: 1.0
            property real maxScale: 3.0

            anchors.fill: parent
            enabled: imagePreview.status === Image.Ready
            pinch.target: imagePreview
            pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
            pinch.maximumScale: maxScale * 1.5 // when over zoomed

            onPinchFinished: {
                imageFlickable.returnToBounds()
                if (imagePreview.scale < pinchArea.minScale) {
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                }
                else if (imagePreview.scale > pinchArea.maxScale) {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }

            NumberAnimation {
                id: bounceBackAnimation
                target: imagePreview
                duration: 250
                property: "scale"
                from: imagePreview.scale
            }
        }
        MouseArea {
            id: mouseArea;
            anchors.fill: parent;
            enabled: imagePreview.status === Image.Ready;
            onDoubleClicked: {
                if (imagePreview.scale > pinchArea.minScale){
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                } else {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }
        }
    }

    Loader {
        anchors.centerIn: parent
        sourceComponent: {
            switch (imagePreview.status) {
            case Image.Loading:
                return loadingIndicator
            case Image.Error:
                return failedLoading
            default:
                return undefined
            }
        }

        Component {
            id: loadingIndicator

            Item {
                height: childrenRect.height
                width: imagePage.width

                BusyIndicator {
                    id: imageLoadingIndicator
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: platformStyle.graphicSizeLarge; width: platformStyle.graphicSizeLarge
                    running: true
                    platformInverted: tbsettings.whiteTheme;
                }

                Label {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: imageLoadingIndicator.bottom; topMargin: platformStyle.paddingLarge
                    }
                    font.pixelSize: platformStyle.fontSizeLarge
                    text: qsTr("Loading image...%1").arg(Math.round(imagePreview.progress*100) + "%")
                    platformInverted: tbsettings.whiteTheme;
                }
            }
        }

        Component {
            id: failedLoading
            Label {
                font.pixelSize: platformStyle.fontSizeLarge
                text: qsTr("Error loading image")
                platformInverted: tbsettings.whiteTheme;
            }
        }
    }

    ScrollDecorator { platformInverted: tbsettings.whiteTheme; flickableItem: imageFlickable }
}
