import QtQuick 1.0
import com.nokia.symbian 1.0
import "Component"
import "../js/storage.js" as Database

MyPage {
    id: page;

    title: qsTr("Bookmark Manage");

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back");
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButtonWithTip {
            toolTipText: qsTr("Clear");
            iconSource: "toolbar-delete";
            onClicked: {
                dialog.createQueryDialog(qsTr("Clear Bookmark"),
                                         qsTr("Do you want to clear all these bookmarks?"),
                                         qsTr("Yes"),
                                         qsTr("No"),
                                         clear);
            }
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active){
            Database.getBookMark(listModel);
        }
    }

    function clear(){
        Database.deleteBookMark();
        listModel.clear();
    }

    ViewHeader {
        id: viewHeader;
        headerText: page.title;
        headerIcon: "gfx/bookmark.svg";
        enabled: false;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel { id: listModel; }
        delegate: delegateComp;
        Component {
            id: delegateComp;
            ListItem {
                id: root;
                implicitHeight: contentCol.height + platformStyle.paddingLarge*2;

                onClicked: {
                    var opt = { threadId: model.threadId, title: model.title, isLz: model.isLz, pid: model.postId }
                    app.enterThread(opt);
                }

                Column {
                    id: contentCol;
                    anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: delBtn.left; }
                    Label {
                        width: parent.width;
                        text: model.title;
                        wrapMode: Text.Wrap;
                    }
                    ListItemText {
                        width: parent.width;
                        text: model.author;
                        role: "SubTitle";
                    }
                }

                Button {
                    id: delBtn;
                    anchors { right: root.paddingItem.right; verticalCenter: parent.verticalCenter; }
                    iconSource: privateStyle.toolBarIconPath("toolbar-delete");
                    onClicked: {
                        Database.deleteBookMark(model.threadId);
                        listModel.remove(index);
                    }
                }
            }
        }
    }
}
