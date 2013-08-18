import QtQuick 2.0
import Ubuntu.Components 0.1

UbuntuShape {

    width: parent.width
    height: units.gu(20)

    property var column

    onColumnChanged: {
        if(column) {
            myText.text = column.title
            var compo = Qt.createComponent(Qt.resolvedUrl("ProviderServiceComponent.qml"))
            for(var i in column.unifiedRequests) {
                var psc = compo.createObject(layout)
                psc.provider = column.unifiedRequests[i]
            }
        }
    }

    Row {
        Label {
            id: myText
        }
        Grid {
            id: layout
            columns: 4
        }
    }
}
