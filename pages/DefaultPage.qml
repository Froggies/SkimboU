import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import "../utils"
import "../components"

Page {

    property Network network

    signal goAccount()
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
                header: Rectangle {
                    visible: listModelColumns.count == 0
                    anchors.top: parent.top
                    anchors.topMargin: units.gu(1)
                    width: parent.width
                    height: listModelColumns.count == 0 ? units.gu(10) : 0
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Create your first column")
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: goAddColumnPage()
                    }
                }
                delegate: MinColumnComponent {
                    column: listModelColumns.get(index)
                    nbMsg: listModelColumns.get(index).nbMsg
                    nbMsgNoView: listModelColumns.get(index).nbMsgNoView

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
                onMsgView:listModelColumns.setProperty(index, "nbMsgNoView", column.nbMsgNoView -1)
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
        ToolbarButton {
            text: i18n.tr("Account")
            iconSource: Qt.resolvedUrl("../files/icone_account.png")
            onTriggered: goAccount()
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
                data.body[i].nbMsg = 0;
                data.body[i].nbMsgNoView = 0;
                data.body[i].index = undefined;//!!! BUG !!! collision with index of ListView and Repeater
                listModelColumns.append(data.body[i])
            }
        } else if(data.cmd === "msg") {
            for(var c = 0; c < listModelColumns.count; c++) {
                var column = listModelColumns.get(c);
                if(column.title === data.body.column) {
                    data.body.msg.column = column.title
                    listModelColumns.setProperty(c, "nbMsg", column.nbMsg + 1)
                    listModelColumns.setProperty(c, "nbMsgNoView", column.nbMsgNoView + 1)
                    repeater.itemAt(c).addMsg(data.body.msg)
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
        } else if(data.cmd === "modColumn") {
            for(var modColumnIndex=0; modColumnIndex<listModelColumns.count; modColumnIndex++) {
                if(listModelColumns.get(modColumnIndex).title === data.body.title){
                    listModelColumns.set(modColumnIndex, data.body.column)
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
