import QtQuick 1.0
import com.nokia.symbian 1.0
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
        Slider {
            id: slider;
            enabled: imagePreview.status == Image.Ready;
            minimumValue: 1.0;
            maximumValue: 3.0;
            value: imagePreview.scale;
            Binding {
                id: sliderBinding;
                target: imagePreview;
                property: "scale";
                value: slider.value;
                when: false;
            }
            Component.onCompleted: sliderBinding.when = true;
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
                            emoDialog = Qt.createComponent("Dialog/AddEmoticonDialog.qml").createObject(imagePage);
                            imagePage.imgurl = imageUrl;
                            imagePage.picsize = Qt.size(imagePreview.paintedWidth, imagePreview.paintedHeight);
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
                    slider.minimumValue = scale;
                    prevScale = scale
                }

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
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

        NumberAnimation {
            id: bounceBackAnimation
            target: imagePreview
            duration: 250
            property: "scale"
            from: imagePreview.scale
        }
        MouseArea {
            id: mouseArea;
            anchors.fill: parent;
            enabled: imagePreview.status === Image.Ready;
            onDoubleClicked: {
                if (imagePreview.scale > slider.minimumValue){
                    bounceBackAnimation.to = slider.minimumValue;
                    bounceBackAnimation.start()
                } else {
                    bounceBackAnimation.to = slider.maximumValue;
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
                }

                Label {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: imageLoadingIndicator.bottom; topMargin: platformStyle.paddingLarge
                    }
                    font.pixelSize: platformStyle.fontSizeLarge
                    text: qsTr("Loading image...%1").arg(Math.round(imagePreview.progress*100) + "%")
                }
            }
        }

        Component {
            id: failedLoading
            Label {
                font.pixelSize: platformStyle.fontSizeLarge
                text: qsTr("Error loading image")
            }
        }
    }

    ScrollDecorator { flickableItem: imageFlickable }
}
