import QtQuick 2.0
import Ubuntu.Components 0.1

Rectangle {
    width: parent.width
    height: units.gu(20)
    border.color: "#ECECEC"
    border.width: 1

    property var column

    onColumnChanged: {
        if(column) {
            myText.text = column.title
            /*var compo = Qt.createComponent(Qt.resolvedUrl("ProviderServiceComponent.qml"))
            for(var i in column.unifiedRequests) {
                var psc = compo.createObject(layout)
                psc.provider = column.unifiedRequests[i]
            }*/
        } else {
            myText.text = "Huuuu"
        }
    }

    Label {
        id: myText
        anchors.centerIn: parent
        fontSize: units.gu(8)
    }
}
