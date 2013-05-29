import QtQuick 1.0
import com.nokia.symbian 1.0
import "../../js/main.js" as Script
import "../../js/Calculate.js" as Calc

ContextMenu {
    id: root;

    property variant page: null;
    property int currentIndex: 0;
    property variant modelData: null;

    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy();
        }
    }

    MenuLayout {
        MenuItem {
            id: item1;
            text: qsTr("Add to bookmark");
            onClicked: {
                app.addBookmark(page.thread.id, modelData.id, page.thread.author.name_show, page.thread.title, page.isLz);
            }
        }
        MenuItem {
            id: item2;
            text: qsTr("Reader Mode");
            onClicked: {
                var prop = { currentIndex: currentIndex, caller: page, listModel: page.listView.model }
                pageStack.push(Qt.resolvedUrl("../ReaderPage.qml"), prop);
            }
        }
        MenuItem {
            id: item3;
            text: qsTr("Copy Content");
            onClicked: {
                var prop = { text: Calc.extractContent(modelData.content) };
                pageStack.push(Qt.resolvedUrl("../CopyPage.qml"), prop);
            }
        }
        MenuItem {
            id: item4;
            text: modelData.floor == 1 ? qsTr("Delete this thread") : qsTr("Delete this post");
            visible: page != null && page.user != null && (page.user.is_manager!=0||(modelData.floor!=1&&page.user.id==page.thread.author.id));
            onClicked: {
                var opt = { fid: page.forum.id, word: page.forum.name, z: page.thread.id };
                if (modelData.floor == 1){
                    Script.deleteThread(page, opt);
                } else {
                    opt.vip = page.user.is_manager == 0;
                    opt.pid = modelData.id;
                    opt.src = 1;
                    Script.deletePost(page, opt);
                }
            }
        }
        MenuItem {
            id: item5;
            text: qsTr("Commit to prison");
            visible: page != null && page.user != null && page.user.is_manager != 0;
            onClicked: {
                var opt = { fid: page.forum.id, un: modelData.author.name, word: page.forum.name, z: page.thread.id }
                dialog.commitPrison(page.user.is_manager, opt);
            }
        }
    }

    states: [
        State {
            name: "floor";
            PropertyChanges { target: item1; visible: false; }
            PropertyChanges { target: item2; visible: false; }
            PropertyChanges {
                target: item3;
                onClicked: {
                    var prop = { text: modelData.content.replace(/<[^>]*>/g, "") };
                    pageStack.push(Qt.resolvedUrl("../CopyPage.qml"), prop);
                }
            }
            PropertyChanges {
                target: item4;
                text: qsTr("Delete this post");
                visible: page != null && modelData.floor != 1 && (page.manager != 0||Script.uid == page.thread.author.id);
                onClicked: {
                    var opt = {
                        fid: page.forum.id,
                        vip: page.manager == 0,
                        isfloor: modelData.floor == 0,
                        pid: modelData.id,
                        src: modelData.floor == 0 ? 3 : 1,
                        word: page.forum.name,
                        z: page.thread.id
                    };
                    Script.deletePost(page, opt);
                }
            }
            PropertyChanges {
                target: item5;
                visible: page != null && page.manager != 0;
                onClicked: {
                    var opt = {
                        fid: page.forum.id,
                        un: modelData.author.name,
                        word: page.forum.name,
                        z: page.thread.id
                    }
                    dialog.commitPrison(page.manager, opt);
                }
            }
            when: root.currentIndex < 0;
        }
    ]
}
