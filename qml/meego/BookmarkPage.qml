import QtQuick 1.1
import com.nokia.meego 1.0
import "Component"
import "Delegate"
import "../js/storage.js" as Database

Page {
    id: page;

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            platformIconId: "toolbar-delete";
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
        headerText: qsTr("Bookmark Manage");
        enabled: false;
    }

    ListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel { id: listModel; }
        delegate: delegateComp;
        Component {
            id: delegateComp;
            AbstractDelegate {
                id: root;
                implicitHeight: contentCol.height + constant.paddingLarge*2;

                onClicked: {
                    var opt = { threadId: model.threadId, title: model.title, isLz: model.isLz, pid: model.postId }
                    app.enterThread(opt);
                }

                Column {
                    id: contentCol;
                    anchors { left: root.paddingItem.left; top: root.paddingItem.top; right: delBtn.left; }
                    Text {
                        width: parent.width;
                        text: model.title;
                        wrapMode: Text.Wrap;
                        font.pixelSize: constant.fontSizeMedium;
                        color: constant.colorLight;
                    }
                    Text {
                        width: parent.width;
                        text: model.author;
                        font.pixelSize: constant.fontSizeSmall;
                        color: constant.colorMid;
                    }
                }

                Button {
                    id: delBtn;
                    platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                    anchors { right: root.paddingItem.right; verticalCenter: parent.verticalCenter; }
                    iconSource: "image://theme/icon-m-toolbar-delete"+(theme.inverted?"-white":"");
                    onClicked: {
                        Database.deleteBookMark(model.threadId);
                        listModel.remove(index);
                    }
                }
            }
        }
    }
}
