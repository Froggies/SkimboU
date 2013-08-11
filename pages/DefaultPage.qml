import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"

Page {

    property Network network
    signal goBack()

    title: i18n.tr("Skimbo")

    Column {
        id: pageLayout

        anchors {
            fill: parent
            margins: units.gu(1)
        }

        spacing: units.gu(1)

        Grid {
            id: columnsContainer
            spacing: units.gu(1)
        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            text: i18n.tr("Column")
            iconSource: Qt.resolvedUrl("../files/icone_addcolumn.png")
        }
        ToolbarButton {
            text: i18n.tr("Skimber")
            iconSource: Qt.resolvedUrl("../files/icone_skimber.png")
        }
        back: ToolbarButton {
            text: i18n.tr("Disconnect")
            iconSource: Qt.resolvedUrl("../files/brand/twitter.png")
            onTriggered: {
                goBack()
            }
        }
        opened: true
        locked: true
    }

    function newDataFromServer(data) {
        console.log("DefaultPage :: newDataFromServer :: "+data.cmd)
        var compo = Qt.createComponent(Qt.resolvedUrl("../components/MinColumnComponent.qml"))
        if(data.cmd === "allColumns") {
            for(var i in data.body) {
                var button = compo.createObject(columnsContainer)
                button.column = data.body[i]
            }
        }
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

}
