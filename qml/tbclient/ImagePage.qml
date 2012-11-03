import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"

Page {
    id: root

    property string imgUrl
    property real picscale: slider.value/100

    function calcscale(){
        return pic.sourceSize.height/pic.sourceSize.width < root.height/root.width
                ? root.width/pic.sourceSize.width
                : root.height/pic.sourceSize.height
    }

    onStatusChanged: {
        if (status == PageStatus.Active)
            pic.source = imgUrl
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"; onClicked: pageStack.pop()
        }
        Slider {
            id: slider
            width: parent.width - 100
            anchors.centerIn: parent
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
    Flickable {
        id: flic
        anchors.fill: parent

        property int oldContentWidth
        property int oldContentHeight

        contentWidth: Math.max(width, pic.width * pic.scale)+1
        contentHeight: Math.max(height, pic.height * pic.scale)+1

        onContentWidthChanged: {
            if(( flic.oldContentWidth != 0) && ( flic.width != 0) ){
                flic.contentX += (flic.contentWidth - flic.oldContentWidth)/2;
            }
            flic.oldContentWidth = flic.contentWidth;
        }
        onContentHeightChanged: {
            if((flic.oldContentHeight != 0) && ( flic.height != 0)) {
                flic.contentY += (flic.contentHeight - flic.oldContentHeight)/2;
            }
            flic.oldContentHeight = flic.contentHeight;
        }
        Image{
            id: pic
            anchors.centerIn: parent
            scale: root.picscale
            smooth: true
            onStatusChanged: {
                if(Image.Ready == pic.status){
                    slider.value = Math.floor(root.calcscale() * 100);
                    flic.contentX = 0; flic.contentY = 0;
                }
            }
            Column {
                anchors.centerIn: parent
                spacing: platformStyle.paddingLarge
                visible: pic.status == Image.Loading
                BusyIndicator {
                    anchors.horizontalCenter: parent.horizontalCenter
                    running: true
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
        PinchArea {
            property real oldScale
            anchors.fill: parent
            onPinchStarted: oldScale = slider.value
            onPinchUpdated: {
                slider.value = oldScale * pinch.scale
            }
        }
        MouseArea{
            anchors.fill: parent
            onPressAndHold: {
                app.showToolBar = !app.showToolBar
                app.showStatusBar = !app.showStatusBar
            }
            onDoubleClicked: {
                if (slider.value < 90){
                    slider.value = 100
                } else {
                    slider.value = Math.floor(root.calcscale() * 100);
                }
            }
        }
    }
}
