import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"

Page {

    property Network network

    title: i18n.tr("Skimbo")

    Column {
        id: pageLayout

        anchors {
            fill: parent
            margins: units.gu(1)
        }

        spacing: units.gu(1)

        Row {
            spacing: units.gu(1)

            Button {
                text: i18n.tr("logged")
            }
            Button {
                text: i18n.tr("logged")
            }
        }

        Row {
            spacing: units.gu(1)

            Button {
                text: i18n.tr("logged")
            }
        }
    }

    function newDataFromServer(data) {
        console.log("DefaultPage :: newDataFromServer :: "+data.cmd)
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

    /*tools: ToolbarActions {
        Button {
           anchors.verticalCenter: parent.verticalCenter
           text: "standard"
       }
    }*/

}
