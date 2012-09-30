import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: root

    property string title
    Binding {
        target: app
        property: "title"
        value: root.title
        when: root.status == PageStatus.Active
    }
}
