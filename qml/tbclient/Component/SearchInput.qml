import QtQuick 1.1
import com.nokia.symbian 1.1

TextField {
    id: searchField

    platformRightMargin: clearButton.width + platformStyle.paddingSmall

    signal typeStopped
    signal cleared

    onTextChanged: {
        inputTimer.restart()
        if(text!="")
            clearButton.state = "ClearVisible"
    }

    Timer {
        id: inputTimer
        interval: 350
        onTriggered: typeStopped()
    }
    Image {
        id: clearButton; objectName: "clearButton"
        height: platformStyle.graphicSizeSmall
        width: platformStyle.graphicSizeSmall
        anchors.right: parent.right
        anchors.rightMargin: platformStyle.paddingSmall
        anchors.verticalCenter: parent.verticalCenter
        state: "ClearHidden"
        source: privateStyle.imagePath(
                    clearMouseArea.pressed ? "qtg_graf_textfield_clear_pressed"
                                           : "qtg_graf_textfield_clear_normal", searchField.platformInverted)

        MouseArea {
            id: clearMouseArea
            anchors.fill: parent
            onClicked: {
                searchField.closeSoftwareInputPanel()
                searchField.text = ""
                clearButton.state = "ClearHidden"
                cleared()
            }
        }

        states: [
            State {
                name: "ClearVisible"
                PropertyChanges {target: clearButton; opacity: 1}
            },
            State {
                name: "ClearHidden"
                PropertyChanges {target: clearButton; opacity: 0}
            }
        ]

        transitions: [
            Transition {
                from: "ClearVisible"; to: "ClearHidden"
                NumberAnimation { properties: "opacity"; duration: 100; easing.type: Easing.Linear }
            },
            Transition {
                from: "ClearHidden"; to: "ClearVisible"
                NumberAnimation { properties: "opacity"; duration: 100; easing.type: Easing.Linear }
            }
        ]

    }
}
