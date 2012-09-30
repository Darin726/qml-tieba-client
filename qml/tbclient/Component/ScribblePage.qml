import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import Qt.labs.components 1.1
import Scribble 1.0

MyPage {
    id: scribblePage
    title: "涂鸦"
    property Item caller

    tools: ToolBarLayout {
        ToolButton { iconSource: "toolbar-back"; onClicked: pageStack.pop() }
        ToolButton { iconSource: "qrc:/gfx/toolbox%1.svg".arg(platformInverted?"_inverted":""); onClicked: toolMenu.open() }
        ToolButton { iconSource: "toolbar-delete"; onClicked: scribbleArea.clear() }
        ToolButton { iconSource: "qrc:/gfx/ok%1.svg".arg(platformInverted?"_inverted":""); onClicked: selected() }
    }
    function selected(){
        var file = "scribble_"+Qt.formatDateTime(new Date(), "yyyyMMddhhmmss")+".jpg"
        var url = tbsettings.imagePath + "/" + file
        if (scribbleArea.save(url)){
            signalCenter.imageSelected(caller.toString(), url)
            pageStack.pop()
        } else {
            app.showMessage("保存出错")
        }
    }
    ScribbleArea {
        id: scribbleArea
        anchors.fill: parent
    }
    Menu {
        id: toolMenu
        content: MenuLayout {
            MenuItem {
                text: "画笔颜色"
                Rectangle {
                    anchors { right: parent.right; rightMargin: platformStyle.paddingLarge; verticalCenter: parent.verticalCenter }
                    height: parent.height/2; width: height
                    color: scribbleArea.color
                }
                onClicked: colorSelector.open()
            }
            MenuItem {
                text: "画笔粗细"
                Label {
                    anchors { right: parent.right; rightMargin: platformStyle.paddingLarge; verticalCenter: parent.verticalCenter }
                    text: scribbleArea.penWidth
                }
                onClicked: widthSelector.open()
            }
            MenuItem {
                text: "导入图片"
                onClicked: {
                    var url = utility.choosePhoto()
                    if (url != "") scribbleArea.open(url)
                }
            }
        }
    }
    CommonDialog {
        id: widthSelector
        titleText: "选择粗细(已选："+slider.value+")"
        buttonTexts: [ "确定", "取消" ]
        onButtonClicked: {
            if (index==0)
                scribbleArea.penWidth = slider.value
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
    CommonDialog {
        id: colorSelector
        property color selectedColor: scribbleArea.color
        titleText: "选取颜色"
        buttonTexts: ["确定", "取消"]
        onButtonClicked: {
            if (index==0)
                scribbleArea.color = selectedColor
        }
        CheckableGroup { id: colorSelectorGroup }
        content: Flickable {
            clip: true
            width: parent.width
            height: Math.min(selectCol.height, colorSelector.platformContentMaximumHeight)
            contentWidth: width
            contentHeight: selectCol.height
            Column {
                id: selectCol
                anchors.horizontalCenter: parent.horizontalCenter
                Row {
                    height: privateStyle.menuItemHeight
                    spacing: platformStyle.paddingMedium
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "    已选："
                    }
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height/2; height: width
                        color: colorSelector.selectedColor
                    }
                }
                Row {
                    RadioButton {
                        id: radioBtn1
                        platformExclusiveGroup: colorSelectorGroup
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: colorSelector.selectedColor = scribbleArea.color
                    }
                    Repeater {
                        model: ["white","red","orange","yellow","green","skyblue","blue","purple","black"]
                        delegate: Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: privateStyle.menuItemHeight/2; height: width
                            color: modelData
                            opacity: colorMouseArea.pressed ? 0.7 : 1
                            MouseArea {
                                id: colorMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if (radioBtn1.checked)
                                        colorSelector.selectedColor = modelData
                                }
                            }
                        }
                    }
                }
                Row {
                    RadioButton {
                        id: radioBtn2
                        platformExclusiveGroup: colorSelectorGroup
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: colorSelectColumn.select2()
                    }
                    Column {
                        id: colorSelectColumn
                        function select2(){
                            var r = "#"
                            for (var i=0; i<children.length; i++){
                                if (children[i].hasOwnProperty("currentValue"))
                                    r += function(){
                                                var _r = children[i].currentValue.toString(16)
                                                return _r.length == 2 ? _r : "0"+_r
                                            }()
                            }
                            colorSelector.selectedColor = r
                        }
                        Repeater {
                            model: 3
                            delegate: Row {
                                property real currentValue: parseInt(String(scribbleArea.color).replace(/#/,"").slice(index*2, index*2+2), 16)
                                onCurrentValueChanged: if (radioBtn2.checked) colorSelectColumn.select2()
                                Slider {
                                    width: 220
                                    value: parent.currentValue
                                    maximumValue: 255
                                    minimumValue: 0
                                    stepSize: 1
                                    onValueChanged: parent.currentValue = value
                                }
                                TextField {
                                    width: platformStyle.fontSizeMedium * 3
                                    text: parent.currentValue
                                    validator: IntValidator { bottom: 0; top: 255 }
                                    onTextChanged: parent.currentValue = text || 0
                                    inputMethodHints: Qt.ImhDigitsOnly
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
