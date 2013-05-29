import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/main.js" as Script

Page {
    id: homePage;

    property bool firstStart: false;

    onVisibleChanged: {
        if (visible && firstStart){
            firstStart = false;
            getlist();
        }
    }

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

    function homeButtonClicked(){
        searchInput.searching = false;
    }

    Connections {
        target: signalCenter;
        onUserChanged: visible ? getlist() : firstStart = true;
        onGetFavoriteTiebaStarted: myFavoView.loading = true;
        onGetFavoriteTiebaFinished: {
            if (time) myFavoView.updateTime = time;
            myFavoView.loading = false;
            myFavoModel.clear();
            forumList.forEach(function(value){
                                  if (value.is_like == 1) myFavoModel.append(value);
                              })
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
        spacing: constant.paddingLarge;
        z: 10;

        ViewHeader {
            id: viewHeader;
            anchors.top: undefined;
            headerText: qsTr("My Tieba");
            loading: tabGroup.currentTab.loading;
        }
        Item {
            anchors { left: parent.left; right: parent.right; margins: constant.paddingMedium; }
            height: childrenRect.height;
            SearchInput {
                id: searchInput;
                property bool searching: false;
                onSearchingChanged: {
                    if (searching){
                        homePage.state = searchThreadButton.checked ? "searchPost" : "searchTieba";
                    } else {
                        homePage.state = "";
                    }
                }
                anchors { left: parent.left; right: searchButton.left; rightMargin: constant.paddingMedium; }
                placeholderText: qsTr("Tap To Search");
                onActiveFocusChanged: {
                    if (activeFocus) searching = true;
                }
                onCleared: searching = false;
            }
            Button {
                id: searchButton;
                anchors { right: parent.right; verticalCenter: searchInput.verticalCenter; }
                platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                iconSource: "image://theme/icon-m-toolbar-mediacontrol-play"+(theme.inverted?"-white":"");
                onClicked: searchInput.searching = true;
            }
        }
        ButtonRow {
            id: buttonRow;
            anchors {
                left: parent.left; right: parent.right;
                margins: constant.paddingLarge;
            }
            visible: false;
            Button {
                id: searchTiebaButton;
                text: qsTr("Search Tieba");
                onClicked: homePage.state = "searchTieba";
            }
            Button {
                id: searchThreadButton;
                text: qsTr("Search Thread");
                onClicked: homePage.state = "searchPost";
            }
        }
    }

    TabGroup {
        id: tabGroup;
        anchors {
            fill: parent; topMargin: headerCol.height + constant.paddingMedium;
        }
        currentTab: myFavoView;
        GridView {
            id: myFavoView;
            property double updateTime;
            property bool loading;
            anchors.fill: parent;
            clip: true;
            cellHeight: constant.graphicSizeLarge;
            cellWidth: parent.width / 2;
            model: ListModel { id: myFavoModel; }
            header: PullToActivate {
                myView: myFavoView;
                enabled: !myFavoView.loading;
                lastUpdateTime: myFavoView.updateTime;
                onRefresh: {
                    Script.getFavoriteTieba();
                }
            }
            delegate: myFavoDelegate
            Component {
                id: myFavoDelegate;
                MouseArea {
                    id: root;

                    implicitWidth: GridView.view.cellWidth;
                    implicitHeight: GridView.view.cellHeight;

                    onClicked: app.enterForum(model.name);

                    Rectangle {
                        id: bg;
                        anchors { fill: parent; margins: constant.paddingMedium; }
                        radius: constant.paddingSmall;
                        border { width: 1; color: constant.colorMidInverted; }
                        color: {
                            var pre = root.pressed ? "#" : "#80";
                            var con = theme.inverted ? "1f1f1f" : "eeeeee";
                            return pre + con;
                        }
                    }

                    Image {
                        id: icon;
                        anchors { left: bg.left; leftMargin: constant.paddingMedium; verticalCenter: parent.verticalCenter; }
                        source: getSource(model.level_id);
                        function getSource(level){
                            var code;
                            if (level < 4) code = 1;
                            else if (level < 10) code = 2;
                            else if (level < 16) code = 3;
                            else code = 4;
                            return "gfx/home_grade_"+code+".png";
                        }
                        Text {
                            anchors.centerIn: parent;
                            text: model.level_id;
                            font.pixelSize: constant.fontSizeXSmall;
                            color: "red";
                        }
                    }

                    Text {
                        anchors {
                            left: icon.right; right: bg.right; margins: constant.paddingMedium;
                            verticalCenter: parent.verticalCenter;
                        }
                        font.pixelSize: constant.fontSizeMedium;
                        color: constant.colorLight;
                        text: model.name;
                        wrapMode: Text.Wrap;
                        maximumLineCount: 2;
                        elide: Text.ElideRight;
                    }
                }
            }
        }
        ListView {
            id: sugView;
            property bool loading: false;
            anchors.fill: parent;
            clip: true;
            model: ListModel { id: sugModel; }
            delegate: AbstractDelegate {
                Text {
                    anchors { left: parent.paddingItem.left; right: parent.paddingItem.right; verticalCenter: parent.verticalCenter; }
                    text: model.name;
                    font.pixelSize: constant.fontSizeLarge;
                    color: constant.colorLight;
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

            anchors.fill: parent;
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
        }
    }

    states: [
        State {
            name: "searchTieba";
            PropertyChanges { target: viewHeader; headerText: qsTr("Search Tieba"); }
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
            PropertyChanges { target: viewHeader; headerText: qsTr("Search Post"); }
            PropertyChanges { target: buttonRow; visible: true; }
            PropertyChanges { target: tabGroup; currentTab: searchPostView; }
            PropertyChanges {
                target: searchInput;
                onCleared: {
                    searchPostModel.clear();
                    searchPostView.hasMore = 0;
                    searchInput.searching = false;
                }
            }
            PropertyChanges { target: searchButton; onClicked: if (searchInput.text != "") searchPost(); }
        }
    ]
}
