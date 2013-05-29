import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Cal

Item {
    id: root

    property Flickable myView

    property int visualY

    property bool reloadTriggered

    property int indicatorStart: 25
    property int refreshStart: 120

    property string pullDownMessage: isHeader ? qsTr("Pull Down To Activate") : qsTr("Pull Up To Activate");
    property string releaseRefreshMessage: qsTr("Release To Activate");
    property string disabledMessage: qsTr("Now loading");
    property double lastUpdateTime: 0;
    onLastUpdateTimeChanged: {
        if (root.enabled) timer.restart();
    }

    property bool isHeader: true;

    signal refresh;

    width: parent ? parent.width : screen.width
    height: 0

    Connections {
        target: myView
        onContentYChanged: {
            if (isHeader){
                if (myView.atYBeginning){
                    var y = root.mapToItem(myView, 0, 0).y
                    if ( y < refreshStart + 20 )
                        visualY = y
                }
            } else {
                if (myView.atYEnd){
                    var y = root.mapToItem(myView, 0, 0).y
                    if ( myView.height - y < refreshStart + 20 )
                        visualY = myView.height - y
                }
            }
        }
    }

    Row {
        anchors {
            bottom: isHeader ? parent.top : undefined; top: isHeader ? undefined : parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: isHeader ? platformStyle.paddingLarge : 0
            topMargin: isHeader ? 0 : platformStyle.paddingLarge
        }
        Image {
            source: "../gfx/pull_down.svg"
            opacity: visualY < indicatorStart ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 100 } }
            rotation: {
                var newAngle = visualY
                if (newAngle > refreshStart && !myView.flicking){
                    root.reloadTriggered = true
                    return isHeader ? -180 : 0
                } else {
                    newAngle = newAngle > refreshStart ? 180 : 0
                    return isHeader ? -newAngle : newAngle - 180
                }
            }
            Behavior on rotation { NumberAnimation { duration: 150 } }
            onOpacityChanged: {
                if (opacity == 0 && root.reloadTriggered) {
                    root.reloadTriggered = false
                    if (root.enabled){
                        root.refresh();
                    }
                }
            }
        }
        Column {
            Label {
                text: root.enabled ? reloadTriggered ? releaseRefreshMessage : pullDownMessage : disabledMessage;
            }
            Label {
                visible: root.enabled && root.lastUpdateTime != 0;
                Timer {
                    id: timer;
                    running: root.enabled;
                    interval: 60000;
                    triggeredOnStart: true;
                    onTriggered: {
                        parent.text = qsTr("Last Update: ")+Cal.humaneDate(root.lastUpdateTime);
                    }
                }
            }
        }
    }
}
