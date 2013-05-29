import QtQuick 1.1
import com.nokia.meego 1.0
import "../../js/storage.js" as Database

Sheet {
    id: root;

    property string imgurl: "";
    property variant picsize: null;

    acceptButtonText: qsTr("Save");
    rejectButtonText: qsTr("Cancel");

    content: Column {
        anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge }
        spacing: constant.paddingLarge;
        Text {
            text: qsTr("Add To Custom Emoticon");
            font.pixelSize: constant.fontSizeLarge;
            color: constant.colorMid;
        }
        TextField {
            id: textField;
            anchors { left: parent.left; right: parent.right; }
            placeholderText: qsTr("Set name (optional)");
        }
    }

    onAccepted: {
        var img = utility.createThumbnail(imgurl, Qt.size(46, 46));
        if (img.length > 0){
            var picid = imgurl.match(/imgsrc.baidu.com\/forum\/pic\/item\/(.*)\.jpg/)[1];
            var list = Database.getCustomEmo();
            var name = textField.text || "MyEmo";
            function check(name){
                return list.some(function(value){return value.name == name});
            }
            if (check(name)){
                var i = 1;
                while (check(name+"-"+i))
                    i ++;
                name += "-"+i;
            }
            if (Database.addCustomEmo(name, img, "pic,"+picid+","+picsize.width+","+picsize.height)){
                signalCenter.showMessage(qsTr("Added to library"));
                return;
            }
        }
        signalCenter.showMessage(qsTr("> < Some error occurs, please add it later"));
    }
}
