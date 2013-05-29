import QtQuick 1.0
import com.nokia.symbian 1.0

QtObject {
    id: root;

    property color colorLight: platformStyle.colorNormalLight;
    property color colorMid: platformStyle.colorNormalMid;
    property color colorDisabled: platformStyle.colorDisabledMid;

    property int doublePaddingLarge: platformStyle.paddingLarge*2;
}
