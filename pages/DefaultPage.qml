import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import "../utils"
import "../components"

Page {

    property Network network
    signal goBack()
    signal goAddColumnPage()
    signal goModifColumnPage(var column)

    title: i18n.tr("Skimbo")

    ListModel {
        id: listModelColumns
    }

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
                model: listModelColumns
                delegate: MinColumnComponent {
                    column: listModelColumns.get(index)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: tabs.selectedTabIndex = index + 1
                    }
                }
            }
        }
        Repeater {
            id: repeater
            model: listModelColumns
            Tab {
                title: listModelColumns.get(index).title
                anchors.fill: parent

                ColumnPage {
                    id: columnPage
                    anchors.fill: parent
                    column: listModelColumns.get(index)
                }

                function addMsg(newMsg) {
                    columnPage.addMsg(newMsg);
                }
            }
        }

    }

    tools: ToolbarItems {
        back: ToolbarButton {
            //empty button according to the ubuntu general design = no back in tabPanel
        }

        ToolbarButton {
            text: i18n.tr("Logout")
            iconSource: Qt.resolvedUrl("../files/icone_logout.png")
            onTriggered: goBack()
        }
        ToolbarButton {
            text: i18n.tr("Delete")
            visible: tabs.selectedTabIndex != 0
            onTriggered: PopupUtils.open(dialogueDeleteColumn)
        }
        ToolbarButton {
            text: i18n.tr("Mod")
            visible: tabs.selectedTabIndex != 0
            onTriggered: goModifColumnPage(listModelColumns.get(tabs.selectedTabIndex-1))
        }
        ToolbarButton {
            text: i18n.tr("Column")
            iconSource: Qt.resolvedUrl("../files/icone_addcolumn.png")
            onTriggered: goAddColumnPage()
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

    Component {
        id: dialogueDeleteColumn
        Dialog {
             id: dialogDeleteColumn
             title: i18n.tr("Delete")
             text: i18n.tr("Are you sure that you want to delete this column ?")
             Button {
                 text: i18n.tr("Cancel")
                 onClicked: PopupUtils.close(dialogDeleteColumn)
             }
             Button {
                 text: i18n.tr("Delete")
                 onClicked: {
                     deleteCurrentColumn()
                     PopupUtils.close(dialogDeleteColumn)
                 }
             }
        }
    }

    function deleteCurrentColumn() {
        network.send({cmd:"delColumn", body:{title: tabs.selectedTab.title}});
    }

    function newDataFromServer(data) {
        //console.log("DefaultPage :: newDataFromServer :: "+data.cmd)
        if(data.cmd === "allColumns") {
            listModelColumns.clear();
            for(var i in data.body) {
                data.body[i].messages = [];
                listModelColumns.append(data.body[i])
            }
        } else if(data.cmd === "msg") {
            for(var c = 0; c < listModelColumns.count; c++) {
                var column = listModelColumns.get(c);
                if(column.title === data.body.column) {
                    repeater.itemAt(c).addMsg(data.body.msg);
                    return;
                }
            }
        } else if(data.cmd === "addColumn") {
            data.body.messages = []
            listModelColumns.append(data.body)
        } else if(data.cmd === "delColumn") {
            for(var i=0; i<listModelColumns.count; i++) {
                if(listModelColumns.get(i).title === data.body.title){
                    listModelColumns.remove(i)
                }
            }
        }
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

}
