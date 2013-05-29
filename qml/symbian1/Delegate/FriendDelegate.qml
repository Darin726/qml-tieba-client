import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/Calculate.js" as Calc

AbstractDelegate {
    id: root;

    Image {
        id: avatar;
        anchors {
            left: root.paddingItem.left;
            top: root.paddingItem.top;
            bottom: root.paddingItem.bottom;
        }
        width: height;
        source: tbsettings.showAvatar ? Calc.getAvatar(model.portrait) : Calc.getAvatar();
        opacity: 0;
        Behavior on opacity { NumberAnimation { duration: 200; } }
        onStatusChanged: {
            if (status == Image.Ready){
                opacity = 1;
            }
        }
    }

    ListItemText {
        anchors {
            left: avatar.right; leftMargin: platformStyle.paddingLarge;
            verticalCenter: parent.verticalCenter;
        }
        text: model.name_show;
    }
}
