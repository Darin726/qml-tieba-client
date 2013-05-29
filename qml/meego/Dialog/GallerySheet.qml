import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

Sheet {
    id: root;

    property Item caller: null;

    property int __isPage;  //to make sheet happy
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: open();

    rejectButtonText: qsTr("Cancel");

    title: Text {
        font.pixelSize: constant.fontSizeXXLarge;
        color: constant.colorLight;
        anchors { right: parent.right; rightMargin: constant.paddingXLarge; verticalCenter: parent.verticalCenter; }
        text: qsTr("Select Image");
    }

    DocumentGalleryModel {
        id: galleryModel;
        autoUpdate: true;
        rootType: DocumentGallery.Image;
        properties: ["url", "title", "lastModified", "dateTaken"];
        sortProperties: ["-lastModified","-dateTaken", "+title"];
    }

    content: GridView {
        id: galleryView;
        model: galleryModel;
        anchors.fill: parent;
        clip: true;
        cellWidth: app.inPortrait ? parent.width/3 : parent.width/5;
        cellHeight: cellWidth;
        delegate: MouseArea {
            implicitWidth: GridView.view.cellWidth;
            implicitHeight: GridView.view.cellHeight;

            onClicked: {
                signalCenter.imageSelected(caller.toString(), model.url);
                root.accept();
            }

            Image {
                anchors.fill: parent;
                sourceSize.width: parent.width;
                asynchronous: true;
                source: model.url;
                fillMode: Image.PreserveAspectCrop;
                clip: true;
                opacity: parent.pressed ? 0.7 : 1;
            }
        }
    }
}
