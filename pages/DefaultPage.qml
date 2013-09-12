import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import "../utils"
import "../components"

Page {

    property Network network
    signal goBack()
    signal goSkimber()
    signal goAddColumnPage()
    signal goModifColumnPage(var column)
    signal goMessagePage(var message)

    ListModel {
        id: listModelColumns
    }

    Tabs {
        id: tabs

        Tab {
            title: i18n.tr("Columns")

            ListView {
                id: columnsContainer
                anchors.fill: parent
                clip: true
                model: listModelColumns
                delegate: MinColumnComponent {
                    column: listModelColumns.get(index)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tabs.selectedTabIndex = index+1
                    }
                }
            }
        }
        Repeater {
            id: repeater
            model: listModelColumns
            delegate: ColumnPage {
                column: listModelColumns.get(index)
                onSelectMessage: goMessagePage(message)
            }
        }
    }

    Component {
        id: columnPopover
        ColumnPopoverComponent {
            onNewColumn: {
                goAddColumnPage()
            }
            onModColumn: {
                goModifColumnPage(listModelColumns.get(tabs.selectedTabIndex-1))
            }
            onDelColumn: {
                PopupUtils.open(dialogueDeleteColumn)
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
            id: columnButton
            text: i18n.tr("Column")
            iconSource: Qt.resolvedUrl("../files/icone_addcolumn.png")
            onTriggered: {
                if(tabs.selectedTabIndex != 0) {
                    PopupUtils.open(columnPopover, columnButton)
                } else {
                    goAddColumnPage()
                }
            }
        }
        ToolbarButton {
            text: i18n.tr("Skimber")
            iconSource: Qt.resolvedUrl("../files/icone_skimber.png")
            onTriggered: goSkimber()
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
            listModelColumns.clear()
            for(var i=0; i<data.body.length; i++) {
                data.body[i].messages = [];
                data.body[i].index = undefined;//!!! BUG !!! collision with index of ListView and Repeater
                listModelColumns.append(data.body[i])
            }
        } else if(data.cmd === "msg") {
            for(var c = 0; c < listModelColumns.count; c++) {
                var column = listModelColumns.get(c);
                if(column.title === data.body.column) {
                    data.body.msg.column = column.title
                    repeater.itemAt(c).addMsg(data.body.msg);
                    return;
                }
            }
        } else if(data.cmd === "addColumn") {
            data.body.messages = []
            listModelColumns.append(data.body)
        } else if(data.cmd === "delColumn") {
            for(var ii=listModelColumns.count-1; ii>=0; ii--) {
                if(listModelColumns.get(ii).title === data.body.title){
                    listModelColumns.remove(ii)
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
