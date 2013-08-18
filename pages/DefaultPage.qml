import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"
import "../components"

Page {

    property Network network
    signal goBack()

    title: i18n.tr("Skimbo")

    Column {

        anchors.fill: parent

        Tabs {
            id: tabs
            anchors.fill: parent
            Tab {
                title: i18n.tr("All columns")
                Column {
                    anchors {
                        fill: parent
                        margins: units.gu(1)
                    }

                    spacing: units.gu(1)

                    ListView {
                        id: columnsContainer
                        delegate: MinColumnComponent{}
                    }
                }
            }
            Repeater {
                id: repeater
                Tab {
                    title: modelData.title
                    page: Page {
                        Label {
                            anchors.centerIn: parent
                            text: "Use header to navigate between tabs"
                        }
                    }
                }
            }

        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            text: i18n.tr("Logout")
            iconSource: Qt.resolvedUrl("../files/icone_logout.png")
            onTriggered: {
                goBack()
            }
        }
        ToolbarButton {
            text: i18n.tr("Column")
            iconSource: Qt.resolvedUrl("../files/icone_addcolumn.png")
        }
        ToolbarButton {
            text: i18n.tr("Skimber")
            iconSource: Qt.resolvedUrl("../files/icone_skimber.png")
        }
    }

    function newDataFromServer(data) {
        console.log("DefaultPage :: newDataFromServer :: "+data.cmd)
        if(data.cmd === "allColumns") {
            for(var i in data.body) {
                console.log(data.body[i].title)
            }
            columnsContainer.model = data.body
            repeater.model = data.body
        }
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

}
