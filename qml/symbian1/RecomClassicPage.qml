import QtQuick 1.0
import com.nokia.symbian 1.0
import CustomWebKit 1.0
import "../js/const.js" as Const

Page {
    id: page;

    property string title: qsTr("Recommend");
    property bool loading: false;
    property bool firstStart: true;

    onVisibleChanged: {
        if (visible && firstStart){
            firstStart = false;
            getlist();
        }
    }

    function positionAtTop(){
        if (flickable.atYBeginning){
            getlist();
        } else {
            flickable.contentY = 0;
        }
    }

    function getlist(){
        var url = Const.S_CLASSIC+"?platform=android"
        if (webView.url == url){ webView.reload.trigger() }
        else { webView.url = url; }
    }

    Flickable {
        id: flickable;
        anchors.fill: parent;
        contentWidth: parent.width;
        contentHeight: webView.height;
        WebView {
            id: webView;
            preferredWidth: page.width;
            preferredHeight: page.height;
            onLoadStarted: page.loading = true;
            onLoadFinished: page.loading = false;
            onLoadFailed: page.loading = false;
            onLinkClicked: {
                if (/c\/s\/classic/.test(link)){
                    webView.url = link;
                } else if (/m\?kz=/.test(link)){
                    signalCenter.linkActivated("link:"+link);
                }
            }
            settings {
                defaultFixedFontSize: tbsettings.fontSize;
                defaultFontSize: tbsettings.fontSize;
            }
        }
    }

}
