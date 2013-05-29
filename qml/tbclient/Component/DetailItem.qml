import QtQuick 1.1
import com.nokia.symbian 1.1

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
        color: root.platformInverted ? platformStyle.colorNormalLightInverted
                                     : platformStyle.colorNormalLight;
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
        color: root.platformInverted ? platformStyle.colorNormalLightInverted
                                     : platformStyle.colorNormalLight;
        horizontalAlignment: Text.AlignRight;
        elide: Text.ElideRight;
    }
}
