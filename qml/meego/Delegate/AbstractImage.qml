import QtQuick 1.1
import com.nokia.meego 1.0

Row {
    id: root;
    spacing: constant.paddingSmall;
    Repeater {
        id: repeater;
        model: modelData.media;
        Item {
            width: Math.floor(root.width/repeater.count);
            height: root.height;
            Image {
                id: img;
                anchors.fill: parent; sourceSize.height: 75;
                source: modelData;
                fillMode: Image.PreserveAspectFit;
                opacity: 0;
                Behavior on opacity { NumberAnimation { duration: 250; } }
                onStatusChanged: {
                    if (status == Image.Ready){
                        placeHolder.opacity = 0;
                        img.opacity = 1;
                    }
                }
            }
            Image {
                id: placeHolder;
                anchors.fill: parent;
                source: "../gfx/photos.svg";
                fillMode: Image.PreserveAspectFit;
            }
        }
    }
}
