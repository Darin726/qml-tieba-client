import QtQuick 1.0
import com.nokia.symbian 1.0

ContextMenu {
    id: root;

    property variant modelData: null;

    MenuLayout {
        MenuItem {
            text: qsTr("View This Reply");
            onClicked: {
                if (modelData.is_floor == 1){
                    app.enterFloor({ threadId: modelData.thread_id, subpostId: modelData.post_id });
                } else {
                    app.enterFloor({threadId: modelData.thread_id, postId: modelData.post_id});
                }
            }
        }
        MenuItem {
            text: qsTr("View This Thread");
            onClicked: {
                var opt = { threadId: modelData.thread_id, title: modelData.title }
                app.enterThread(opt);
            }
        }
        MenuItem {
            text: qsTr("Enter Forum");
            onClicked: {
                app.enterForum(modelData.fname);
            }
        }
    }
}
