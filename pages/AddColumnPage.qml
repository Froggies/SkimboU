import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"
import "../components"

Page {
    anchors.fill: parent

    signal columnAdded

    property var column

    onColumnChanged: {
        if(column) {
            console.log("AddColumnPage :: onColumnChange :: column == "+JSON.stringify(column))
            titleInput.text = column.title
        } else {
            titleInput.text = ""
        }
    }

    PageStack {
        id: stackContainer
        anchors.fill: parent

        Component.onCompleted: {
            push(columnTitlePage)
        }

        Page {
            id: columnTitlePage
            title: i18n.tr("Create column")
            anchors.fill: parent
            visible: false

            TextField {
                id: titleInput
                placeholderText: i18n.tr("Column's title")
                anchors.centerIn: parent
            }

            Button {
                text: i18n.tr("validate title")
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: units.gu(1)
                anchors.rightMargin: units.gu(1)
                onClicked: stackContainer.push(selectServicesPage)
            }
        }

        Page {
            id: selectServicesPage
            title: i18n.tr("Create column")
            anchors.fill: parent
            visible: false

            ListModel {
                id: listModel
            }

            ListView {
                id: servicesContainer
                anchors.fill: parent
                width: parent.width
                clip: true
                model: listModel
                delegate: ProviderServiceComponent {
                    service: listModel.get(index)
                    onArgValueChange: {
                        var old = listModel.get(index)
                        old.arg = {name: old.arg.name, value:newValue}
                        listModel.set(index, old)
                    }
                }
            }

            Button {
                text: i18n.tr("add column")
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: units.gu(1)
                anchors.rightMargin: units.gu(1)
                onClicked: addColumn()
            }

            onVisibleChanged: {
                if(visible) {
                    network.send({cmd:"allUnifiedRequests"})
                }
            }
        }
    }

    property Network network;
    property var columns;

    function newDataFromServer(data) {
        //console.log("AddColumnPage :: newDataFromServer :: "+data.cmd)
        if(data.cmd === "allUnifiedRequests") {
            listModel.clear()
            for(var i in data.body) {
                var providerName = data.body[i].endpoint
                var hasToken = data.body[i].hasToken
                for(var j in data.body[i].services) {
                    var serviceName = data.body[i].services[j].service.split(".")[1];
                    var arg = data.body[i].services[j].args[0];
                    listModel.append({
                        providerName: providerName,
                        serviceName: serviceName,
                        hasToken: hasToken,
                        arg: {name: arg, value: ""},
                        selected: false
                    })
                }
            }
        } else if(data.cmd === "allColumns") {
            columns = data.body
        }
    }

    function addColumn() {
        var unifiedRequests = []
        for(var i=0; i < listModel.count; i++) {
            if(listModel.get(i).selected) {
                var args = {}
                args[listModel.get(i).arg.name] = listModel.get(i).arg.value
                unifiedRequests.push({
                    service:listModel.get(i).providerName + "." + listModel.get(i).serviceName,
                    args: args
                })
            }
        }

        var cmd = {
            cmd: "addColumn",
            body: {
                title: titleInput.text,
                unifiedRequests: unifiedRequests,
                index: columns.length,
                width: -1,
                height: -1
            }
        }

        network.send(cmd)
        columnAdded()
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

}
