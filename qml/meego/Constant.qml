import QtQuick 1.1

QtObject {
    id: constant;

    property color colorLight: theme.inverted ? "#ffffff" : "#191919";
    property color colorMid: theme.inverted ? "#8c8c8c" : "#666666";
    property color colorMidInverted: theme.inverted ? "#666666" : "#8c8c8c";
    property color colorTextSelection: "#4591ff";
    property color colorDisabled: theme.inverted ? "#444444" : "#b2b2b4";

    property int paddingSmall: 4;
    property int paddingMedium: 8;
    property int paddingLarge: 12;
    property int paddingXLarge: 16;

    property int fontSizeXSmall: 20;
    property int fontSizeSmall: 22;
    property int fontSizeMedium: 24;
    property int fontSizeLarge: 26;
    property int fontSizeXLarge: 28;
    property int fontSizeXXLarge: 32;

    property int graphicSizeTiny: 24;
    property int graphicSizeSmall: 32;
    property int graphicSizeMedium: 48;
    property int graphicSizeLarge: 72;

    property int thumbnailSize: 150;

    property int headerHeight: 72;
    property int textFieldHeight: 52;
}
