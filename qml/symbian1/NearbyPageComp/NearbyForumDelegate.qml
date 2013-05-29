import QtQuick 1.0
import com.nokia.symbian 1.0
import com.nokia.extras 1.0
import "../Delegate"

AbstractDelegate {
    id: root;
    Column {
        anchors.fill: parent.paddingItem;
        Row {
            spacing: platformStyle.paddingMedium;
            ListItemText {
                anchors.verticalCenter: parent.verticalCenter;
                text: model.fname;
            }
            RatingIndicator {
                anchors.verticalCenter: parent.verticalCenter;
                maximumValue: 5;
                ratingValue: model.heat;
            }
        }
        ListItemText {
            role: "SubTitle";
            text: qsTr("%1 Members, %2 Posts").arg(model.member_count).arg(model.post_num);
        }
    }
    onClicked: {
        app.enterForum(model.fname);
    }
}
