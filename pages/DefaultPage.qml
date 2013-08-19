import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"
import "../components"

Page {

    property Network network
    signal goBack()

    title: i18n.tr("Skimbo")

    Tabs {
        id: tabs
        anchors.fill: parent
        Tab {
            title: i18n.tr("All columns")
            anchors.fill: parent

            ListView {
                id: columnsContainer
                anchors.fill: parent
                clip: true
                delegate: MinColumnComponent{
                    column: modelData
                    MouseArea {
                        anchors.fill: parent
                        onClicked: tabs.selectedTabIndex = index + 1
                    }
                }
            }
        }
        Repeater {
            id: repeater
            Tab {
                title: modelData.title
                anchors.fill: parent

                ColumnPage {
                    id: columnPage
                    anchors.fill: parent
                    column: modelData
                }

                function addMsg(newMsg) {
                    columnPage.addMsg(newMsg);
                }
            }
        }

    }

    tools: ToolbarItems {
        ToolbarButton {
            text: i18n.tr("Logout")
            iconSource: Qt.resolvedUrl("../files/icone_logout.png")
            onTriggered: goBack()
        }
        ToolbarButton {
            text: i18n.tr("Column")
            iconSource: Qt.resolvedUrl("../files/icone_addcolumn.png")
        }
        ToolbarButton {
            text: i18n.tr("Skimber")
            iconSource: Qt.resolvedUrl("../files/icone_skimber.png")
        }
        ToolbarButton {
            text: i18n.tr("All columns")
            onTriggered: tabs.selectedTabIndex = 0
        }
    }

    function newDataFromServer(data) {
        //console.log("DefaultPage :: newDataFromServer :: "+data.cmd)
        if(data.cmd === "allColumns") {
            for(var i in data.body) {
                data.body[i].messages = [];
            }
            columnsContainer.model = data.body
            repeater.model = data.body
        } else if(data.cmd === "msg") {
            for(var c in repeater.model) {
                var column = repeater.model[c]
                if(column.title === data.body.column) {
                    repeater.itemAt(c).addMsg(data.body.msg);
                    return;
                }
            }
        }
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

}
