import QtQuick 1.1
import com.nokia.symbian 1.1
import "Component"
import "Delegate"
import "../js/main.js" as Script

MyPage {
    id: homePage;

    property bool firstStart: false;

    onStatusChanged: {
        if (status == PageStatus.Active && firstStart){
            firstStart = false;
            getlist();
        }
    }

    title: qsTr("My Tieba");
    tools: mainTools;

    function getlist(){
        try {
            Script.getFavoriteTiebaResult(utility.getCache("myBarList"));
        } catch(e){
            Script.getFavoriteTieba();
        }
    }

    function searchPost(option){        
        option = option||"renew"
        var opt = new Object();
        if (option == "renew"){
            searchPostView.currentPage = 1;
            searchPostView.hasMore = false;
            searchPostView.word = searchInput.text;
            opt.pn = 1;
        } else if (option == "more"){
            opt.pn = searchPostView.currentPage + 1;
        }
        opt.word = searchPostView.word;
        Script.searchPost(opt);
    }

    Connections {
        target: signalCenter;
        onUserChanged: {
            if (homePage.status == PageStatus.Active){
                getlist();
            } else {
                firstStart = true;
            }
        }
        onGetFavoriteTiebaStarted: myFavoView.loading = true;
        onGetFavoriteTiebaFinished: {
            if (time) myFavoView.updateTime = time;
            myFavoView.loading = false;
            worker.sendMessage({ list: forumList, model: myFavoModel, option: "favo" });
        }
        onGetForumSuggestStarted: sugView.loading = true;
        onGetForumSuggestFinished: {
            sugView.loading = false;
            worker.sendMessage({ list: fname, model: sugModel, option: "sug" });
        }
        onSearchPostStarted: searchPostView.loading = true;
        onSearchPostFinished: {
            searchPostView.loading = false;
            if (page){
                searchPostView.currentPage = page.current_page;
                searchPostView.hasMore = page.has_more>0;
                worker.sendMessage({ list: postList, model: searchPostModel, option: "search", renew: page.current_page == 1 });
            }
        }
        onLoadFailed: { myFavoView.loading = false; sugView.loading = false; searchPostView.loading = false; }
    }

    Column {
        id: headerCol;
        anchors { left: parent.left; top: parent.top; right: parent.right; }
        spacing: platformStyle.paddingLarge;
        z: 10;

        ViewHeader {
            id: viewHeader;
            anchors.top: undefined;
            headerIcon: privateStyle.toolBarIconPath("toolbar-home");
            headerText: homePage.title;
            loading: tabGroup.currentTab.loading;
        }
        Item {
            anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingMedium; }
            height: childrenRect.height;
            SearchInput {
                id: searchInput;
                anchors { left: parent.left; right: searchButton.left; rightMargin: platformStyle.paddingMedium; }
                platformInverted: tbsettings.whiteTheme;
                placeholderText: qsTr("Tap To Search");
                onActiveFocusChanged: {
                    if (activeFocus){
                        homePage.state = searchThreadButton.checked ? "searchPost" : "searchTieba";
                    } else {
                        homePage.state = "";
                    }
                }
            }
            Button {
                id: searchButton;
                anchors { right: parent.right; verticalCenter: searchInput.verticalCenter; }
                iconSource: privateStyle.toolBarIconPath("toolbar-mediacontrol-play", platformInverted);
                onClicked: searchInput.forceActiveFocus();
                platformInverted: tbsettings.whiteTheme;
            }
        }
        ButtonRow {
            id: buttonRow;
            anchors {
                left: parent.left; right: parent.right;
                margins: platformStyle.paddingLarge;
            }
            visible: false;
            Button {
                id: searchTiebaButton;
                platformInverted: tbsettings.whiteTheme;
                text: qsTr("Search Tieba");
                onClicked: homePage.state = "searchTieba";
            }
            Button {
                id: searchThreadButton;
                platformInverted: tbsettings.whiteTheme;
                text: qsTr("Search Thread");
                onClicked: homePage.state = "searchPost";
            }
        }
    }

    TabGroup {
        id: tabGroup;
        anchors {
            fill: parent; topMargin: headerCol.height + platformStyle.paddingMedium;
        }
        currentTab: myFavoView;
        ListView {
            id: myFavoView;
            property double updateTime;
            property bool loading;
            clip: true;
            model: ListModel { id: myFavoModel; }
            header: PullToActivate {
                myView: myFavoView;
                enabled: !myFavoView.loading;
                lastUpdateTime: myFavoView.updateTime;
                onRefresh: {
                    Script.getFavoriteTieba();
                }
            }
            delegate: myFavoDelegate;
            Component {
                id: myFavoDelegate;
                ListItem {
                    id: root;
                    subItemIndicator: true;
                    platformInverted: tbsettings.whiteTheme;
                    onClicked: app.enterForum(model.name);
                    Image {
                        id: icon;
                        anchors { left: root.paddingItem.left; verticalCenter: parent.verticalCenter; }
                        source: getSource(model.level_id);
                        function getSource(level){
                            var code;
                            if (level < 4) code = 1;
                            else if (level < 10) code = 2;
                            else if (level < 16) code = 3;
                            else code = 4;
                            return "gfx/home_grade_"+code+".png";
                        }
                    }
                    ListItemText {
                        id: info;
                        role: "SubTitle";
                        anchors { right: root.paddingItem.right; verticalCenter: parent.verticalCenter; }
                        text: qsTr("Level %1").arg(model.level_id);
                        platformInverted: root.platformInverted;
                    }
                    ListItemText {
                        anchors {
                            left: icon.right; right: info.left;
                            margins: platformStyle.paddingMedium; verticalCenter: parent.verticalCenter;
                        }
                        text: model.name;
                        platformInverted: root.platformInverted;
                    }
                }
            }
            ScrollDecorator { platformInverted: tbsettings.whiteTheme; flickableItem: myFavoView; }
        }
        ListView {
            id: sugView;
            property bool loading: false;
            clip: true;
            model: ListModel { id: sugModel; }
            delegate: ListItem {
                platformInverted: tbsettings.whiteTheme;
                ListItemText {
                    anchors { left: parent.paddingItem.left; right: parent.paddingItem.right; verticalCenter: parent.verticalCenter; }
                    text: model.name;
                    platformInverted: parent.platformInverted;
                }
                onClicked: app.enterForum(model.name);
            }
        }
        ListView {
            id: searchPostView;

            property bool loading: false;
            property int currentPage: 1;
            property bool hasMore: false;
            property string word: "";

            clip: true;
            model: ListModel { id: searchPostModel; }
            delegate: SearchPostDelegate {}
            header: PullToActivate {
                myView: searchPostView;
                onRefresh: {
                    if (searchInput.text != "") searchPost();
                }
            }
            footer: FooterItem {
                visible: searchPostView.hasMore;
                enabled: !searchPostView.loading;
                onClicked: {
                    searchPost("more");
                }
            }
            ScrollDecorator { platformInverted: tbsettings.whiteTheme; flickableItem: searchPostView; }
        }
    }

    states: [
        State {
            name: "searchTieba";
            PropertyChanges { target: homePage; title: qsTr("Search Tieba"); }
            PropertyChanges { target: viewHeader; headerIcon: privateStyle.toolBarIconPath("toolbar-search"); }
            PropertyChanges { target: buttonRow; visible: true; }
            PropertyChanges { target: tabGroup; currentTab: sugView; }
            PropertyChanges {
                target: searchInput;
                onTypeStopped: {
                    if (searchInput.text.length > 0){
                        Script.getForumSuggest(searchInput.text);
                    } else {
                        sugModel.clear();
                    }
                }
            }
            PropertyChanges {
                target: searchButton;
                onClicked: if (searchInput.text != "") app.enterForum(searchInput.text);
            }
        },
        State {
            name: "searchPost"
            PropertyChanges { target: homePage; title: qsTr("Search Post"); }
            PropertyChanges { target: viewHeader; headerIcon: privateStyle.toolBarIconPath("toolbar-search"); }
            PropertyChanges { target: buttonRow; visible: true; }
            PropertyChanges { target: tabGroup; currentTab: searchPostView; }
            PropertyChanges {
                target: searchInput;
                onCleared: {
                    searchPostModel.clear();
                    searchPostView.hasMore = 0;
                }
            }
            PropertyChanges { target: searchButton; onClicked: if (searchInput.text != "") searchPost(); }
        }
    ]
}
