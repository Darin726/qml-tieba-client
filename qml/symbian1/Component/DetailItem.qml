import QtQuick 1.0
import com.nokia.symbian 1.0

MenuItem {
    id: root;

    property alias title: title.text;
    property alias subTitle: subTitle.text;

    enabled: false;

    Text {
        id: title;
        anchors {
            left: parent.left; top: parent.top; right: parent.right;
            margins: platformStyle.paddingMedium;
        }
        font {
            bold: true;
            pixelSize: platformStyle.fontSizeMedium;
            family: platformStyle.fontFamilyRegular;
        }
        color: platformStyle.colorNormalLight;
        elide: Text.ElideRight;
    }

    Text {
        id: subTitle;
        anchors {
            left: parent.left; bottom: parent.bottom; right: parent.right;
            margins: platformStyle.paddingMedium;
        }
        font {
            pixelSize: platformStyle.fontSizeMedium;
            family: platformStyle.fontFamilyRegular;
        }
        color: platformStyle.colorNormalLight;
        horizontalAlignment: Text.AlignRight;
        elide: Text.ElideRight;
    }
}
