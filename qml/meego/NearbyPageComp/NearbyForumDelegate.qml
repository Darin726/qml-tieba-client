import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../Delegate"

AbstractDelegate {
    id: root;
    Column {
        anchors { left: root.paddingItem.left; verticalCenter: parent.verticalCenter; }
        Row {
            spacing: constant.paddingMedium;
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                text: model.fname;
                font.pixelSize: constant.fontSizeLarge;
                color: constant.colorLight;
            }
            RatingIndicator {
                anchors.verticalCenter: parent.verticalCenter;
                maximumValue: 5;
                ratingValue: model.heat;
            }
        }
        Text {
            text: qsTr("%1 Members, %2 Posts").arg(model.member_count).arg(model.post_num);
            font { pixelSize: constant.fontSizeSmall; weight: Font.Light; }
            color: constant.colorMid;
        }
    }
    onClicked: {
        app.enterForum(model.fname);
    }
}
