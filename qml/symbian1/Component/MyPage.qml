import QtQuick 1.0
import com.nokia.symbian 1.0

Page {
    id: root;

    property string title;

    Binding {
        target: app;
        property: "title";
        value: root.title;
        when: root.status == PageStatus.Active && title.length > 0
    }
}
