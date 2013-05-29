import QtQuick 1.1
import com.nokia.symbian 1.1
import "../../js/storage.js" as Database

CommonDialog {
    id: root;

    property string imgurl: "";
    property variant picsize: null;

    titleText: qsTr("Add To Custom Emoticon");
    titleIcon: "../gfx/btn_insert_face_res.png";
    buttonTexts: [qsTr("Save"), qsTr("Cancel")];

    content: Item {
        width: platformContentMaximumWidth;
        height: textField.height+platformStyle.paddingLarge*2;
        TextField {
            id: textField;
            anchors {
                left: parent.left; right: parent.right; margins: platformStyle.paddingLarge;
                verticalCenter: parent.verticalCenter;
            }
            placeholderText: qsTr("Set name (optional)");
        }
    }

    onButtonClicked: {
        if (index == 0) accept();
        else reject();
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
