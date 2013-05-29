import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
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
                platformInverted: root.platformInverted;
            }
            RatingIndicator {
                anchors.verticalCenter: parent.verticalCenter;
                maximumValue: 5;
                ratingValue: model.heat;
                platformInverted: root.platformInverted;
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
