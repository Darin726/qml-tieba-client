import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root

    property Flickable myView

    property int visualY

    property bool reloadTriggered

    property int indicatorStart: 25
    property int refreshStart: 120

    property string pullDownMessage: "下拉可以刷新"
    property string releaseRefreshMessage: "松开可以刷新"
    property bool platformInverted: tbsettings.whiteTheme

    signal refresh

    width: screen.width
    height: 0

    Connections {
        target: myView
        onContentYChanged: {
            if (myView.atYBeginning){
                var y = root.mapToItem(myView, 0, 0).y
                if ( y < refreshStart + 20 )
                    visualY = y
            }
        }
    }

    Row {
        anchors {
            bottom: parent.top
            horizontalCenter: parent.horizontalCenter
            bottomMargin: platformStyle.paddingLarge
        }
        Image {
            source: root.platformInverted ? "qrc:/gfx/pull_down_inverse.svg" : "qrc:/gfx/pull_down.svg"
            opacity: visualY < indicatorStart ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 100 } }
            rotation: {
                var newAngle = visualY
                if (newAngle > refreshStart && !myView.flicking){
                    root.reloadTriggered = true
                    return -180
                } else {
                    newAngle = newAngle > refreshStart ? 180 : 0
                    return -newAngle
                }
            }
            Behavior on rotation { NumberAnimation { duration: 150 } }
            onOpacityChanged: {
                if (opacity == 0 && root.reloadTriggered) {
                    root.reloadTriggered = false
                    root.refresh()
                }
            }
        }
        Label {
            platformInverted: root.platformInverted
            text: reloadTriggered ? releaseRefreshMessage : pullDownMessage
        }
    }
}
