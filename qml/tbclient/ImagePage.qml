import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

Page {
    id: root

    property string imgUrl
    property real picscale: slider.value / 100

    function calcscale(){
        return pic.sourceSize.height/pic.sourceSize.width < root.height/root.width
                ? root.width/pic.sourceSize.width
                : root.height/pic.sourceSize.height
    }
    onStatusChanged: {
        if (status == PageStatus.Active && imgUrl!="" && pic.status == Image.Null)
            pic.source = imgUrl
    }

    Flickable{
        id: flic

        property int oldContentHeight
        property int oldContentWidth

        width: Math.min(root.width, pic.sourceSize.width * root.picscale) - 1
        height: Math.min(root.height, pic.sourceSize.height * root.picscale) - 1

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: parent.height/2

        contentWidth: pic.sourceSize.width * root.picscale
        contentHeight: pic.sourceSize.height * root.picscale

        Image{
            id: pic
            anchors.centerIn: parent
            scale: root.picscale
            onStatusChanged: {
                if(Image.Ready == pic.status){
                    slider.value = Math.floor(root.calcscale() * 100);
                }
            }            
            Column {
                anchors.centerIn: parent
                spacing: platformStyle.paddingLarge
                visible: pic.status == Image.Loading
                BusyIndicator {
                    anchors.horizontalCenter: parent.horizontalCenter
                    running: visible
                    width: platformStyle.graphicSizeLarge
                    height: platformStyle.graphicSizeLarge
                    platformInverted: tbsettings.whiteTheme
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.floor(pic.progress * 100) + "%"
                    color: tbsettings.whiteTheme ? platformStyle.colorDisabledMidInverted
                                                 : platformStyle.colorDisabledMid
                    font.pixelSize: platformStyle.fontSizeLarge
                }
            }
        }

        onContentWidthChanged: {
            if((flic.contentWidth > root.width)
                    && (0 !== flic.oldContentWidth)
                    && (0 !== root.width) ){
                flic.contentX += (flic.contentWidth - flic.oldContentWidth)/2;
            }

            flic.oldContentWidth = flic.contentWidth;
        }
        onContentHeightChanged: {
            if((flic.contentHeight > root.height)
                    && (0 !== flic.oldContentHeight)
                    && (0 !== root.height)) {
                flic.contentY += (flic.contentHeight - flic.oldContentHeight)/2;
            }
            flic.oldContentHeight = flic.contentHeight;
        }
        PinchArea {
            property real oldScale
            anchors.centerIn: parent
            width: Math.max(flic.contentWidth, root.width)
            height: Math.max(flic.contentHeight, root.height)
            onPinchStarted: oldScale = slider.value
            onPinchUpdated: {
                slider.value = oldScale * pinch.scale
            }
        }
        MouseArea{
            anchors.centerIn: parent
            width: Math.max(flic.contentWidth, root.width)
            height: Math.max(flic.contentHeight, root.height)
            onPressAndHold: {
                app.showToolBar = !app.showToolBar
                app.showStatusBar = !app.showStatusBar
            }
            onDoubleClicked: {
                slider.value = Math.floor(root.calcscale() * 100);
            }
        }
    }

    tools: ToolBarLayout {
        id: toolbar
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        Slider {
            id: slider
            width: parent.width * 0.72
            anchors.horizontalCenter: parent.horizontalCenter
            minimumValue: 1;
            maximumValue: 200; stepSize: 2
            valueIndicatorVisible: true
            valueIndicatorText: slider.value  + "%"
            visible: Image.Ready == pic.status
            value: 100.0
        }
        ToolButton {
            iconSource: "qrc:/gfx/download%1.svg".arg(platformInverted?"_inverted":"")
            enabled: pic.status == Image.Ready
            onClicked: {
                var res = utility.savePixmap(imgUrl, tbsettings.imagePath)
                if (res.length>0){
                    app.showMessage("图片已保存至"+res)
                } else {
                    app.showMessage("保存失败> <")
                }
            }
        }
    }
}
