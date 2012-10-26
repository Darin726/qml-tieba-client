import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "js/main.js" as Script

MyPage {
    id: myBarPage
    title: "我的贴吧"

    property bool firstStart: true
    property bool loading
    onVisibleChanged: {
        if (!visible)
            loader.sourceComponent = undefined
        else {
            loader.sourceComponent = comp
            if (firstStart){
                firstStart = false
                var c = utility.getCache("myBarList")
                try {
                    Script.loadMyBarList(c, myBarModel, true)
                } catch(e){
                    Script.getMyBarList(myBarModel)
                }
            }
        }
    }
    tools: homeTools

    Connections {
        target: signalCenter
        onGetMyBarListStarted: {
            myBarPage.loading = true
        }
        onGetMyBarListSuccessed: {
            myBarPage.loading = false
            if (!cached) utility.setCache("myBarList", result)
        }
        onGetMyBarListFailed: {
            myBarPage.loading = false
            app.showMessage(errorString)
        }
        onGetForumSuggestFailed: {
            app.showMessage(errorString)
        }
        onCurrentUserChanged: firstStart = true
    }

    QtObject {
        id: internal
        function getGrade(lv){
            if(lv<4)
                return 1
            else if (lv<10)
                return 2
            else if (lv<16)
                return 3
            else
                return 4
        }
    }

    ViewHeader {
        id: viewHeader
        implicitHeight: privateStyle.tabBarHeightPortrait
        ToolButton {
            id: goButton
            iconSource: "toolbar-next"
            platformInverted: tbsettings.whiteTheme
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            onClicked: if (searchInput.text != "") app.enterForum(searchInput.text)
        }
        SearchInput {
            id: searchInput
            anchors { left: parent.paddingItem.left; right: goButton.left; verticalCenter: parent.verticalCenter }
            placeholderText: "输入贴吧名称，如“诺记”"
            maximumLength: 31
            platformInverted: tbsettings.whiteTheme
            onTypeStopped: {
                if (text == '') suggestModel.clear()
                else Script.getForumSuggest(text, suggestModel)
            }
            onCleared: loader.focus = true
            KeyNavigation.down: loader
            Keys.onReturnPressed: goButton.clicked()
        }
    }
    ListModel { id: myBarModel }
    ListModel { id: suggestModel }

    Loader {
        id: loader
        anchors { fill: parent; topMargin: viewHeader.height }
    }
    Component {
        id: comp
        ListView {
            id: view
            clip: true
            cacheBuffer: height
            focus: true
            model: searchInput.text == "" ? myBarModel : suggestModel
            Component.onCompleted: forceActiveFocus()
            header: PullToActivate {
                myView: view
                onRefresh: Script.getMyBarList(myBarModel)
            }
            delegate: ListItem {
                id: del
                subItemIndicator: true
                platformInverted: tbsettings.whiteTheme
                onClicked: app.enterForum(model.name)
                Row {
                    anchors.fill: parent.paddingItem
                    spacing: platformStyle.paddingMedium
                    Image {
                        id: levelInd
                        anchors.verticalCenter: parent.verticalCenter
                        visible: model.is_like == 1
                        Component.onCompleted: {
                            if (model.is_like == 1){
                                source = "qrc:/gfx/home_grade_%1.png".arg(internal.getGrade(model.level_id))
                                lvtxt.text = model.level_id
                            }
                        }
                        Label {
                            id: lvtxt
                            anchors.centerIn: parent
                            font.pixelSize: platformStyle.fontSizeSmall
                            color: "red"
                        }
                    }
                    ListItemText {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - levelInd.width
                        elide: Text.ElideRight
                        text: model.name
                        platformInverted: del.platformInverted
                    }
                }
            }
        }
    }
    ScrollBar {
        anchors.right: parent.right; anchors.top: loader.top
        flickableItem: loader.item
    }
}
