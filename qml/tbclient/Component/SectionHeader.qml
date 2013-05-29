import QtQuick 1.1
import com.nokia.symbian 1.1

ListHeading {
    id: root;

    property alias text: text.text;

    platformInverted: tbsettings.whiteTheme;
    ListItemText {
        id: text;
        role: "Heading";
        anchors.fill: parent.paddingItem;
        platformInverted: root.platformInverted;
    }
}
