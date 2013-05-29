import QtQuick 1.1
import com.nokia.symbian 1.1

QtObject {
    id: root;

    property color colorLight: tbsettings.whiteTheme ? platformStyle.colorNormalLightInverted
                                                     : platformStyle.colorNormalLight;
    property color colorMid: tbsettings.whiteTheme ? platformStyle.colorNormalMidInverted
                                                   : platformStyle.colorNormalMid;
    property color colorDisabled: tbsettings.whiteTheme ? platformStyle.colorDisabledLightInverted
                                                        : platformStyle.colorDisabledMid;

    property int doublePaddingLarge: platformStyle.paddingLarge*2;
}
