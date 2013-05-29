import QtQuick 1.0
import com.nokia.symbian 1.0

ListHeading {
    id: root;

    property alias text: text.text;

    ListItemText {
        id: text;
        role: "Heading";
        anchors.fill: parent.paddingItem;
    }
}
