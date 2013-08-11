import QtQuick 2.0
import Ubuntu.Components 0.1

UbuntuShape {
    width: 200
    height: width

    property var column

    onColumnChanged: {
        if(column) {
            myText.text = column.title
            var compo = Qt.createComponent(Qt.resolvedUrl("ProviderServiceComponent.qml"))
            console.log("MinColumnComponent :: onColumnChanged :: "+column.unifiedRequests.length)
            for(var i in column.unifiedRequests) {
                var psc = compo.createObject(layout)
                psc.provider = column.unifiedRequests[i]
            }
        }
    }

    Column {
        anchors.centerIn: parent
        Row {
            Label {
                id: myText
            }
        }
        Row {
            Grid {
                id: layout
                columns: 4
            }
        }

    }
}
