import QtQuick 2.0
import Ubuntu.Components 0.1

Page {

    title: i18n.tr("Skimbo's servers")

    signal addServer(string name, string urlServer, bool selected)
    signal deleteServer(string name)

    property var extraServers

    ListModel {
        id: listModelServers
    }

    ListView {
        id: listServers
        anchors.fill: parent
        model: listModelServers
        delegate: Rectangle {
           width: parent.width
           height: units.gu(10)
           border.color: "#ECECEC"
           border.width: 1
           property var modelData: listModelServers.get(index)
           Text {
               anchors.top: parent.top
               anchors.topMargin: units.gu(1)
               anchors.left: parent.left
               anchors.leftMargin: units.gu(1)
               text: modelData.name
           }
           Label {
               anchors.bottom: parent.bottom
               anchors.bottomMargin: units.gu(2)
               anchors.right: parent.right
               anchors.rightMargin: units.gu(2)
               text: modelData.urlServer
           }
           MouseArea {
               anchors.fill: parent
               onClicked: {
                   clearAndSelect(modelData)
               }
           }
           Rectangle {
               visible: modelData.selected
               width: units.gu(2)
               height: width
               anchors.top: parent.top
               anchors.topMargin: units.gu(1)
               anchors.right: parent.right
               anchors.rightMargin: units.gu(1)
               radius: width * 0.5
               color: "#ECECEC"
               border.color: "#999999"
               border.width: 1
               antialiasing: true
           }
        }
        footer: Rectangle {
            width: parent.width
            height: units.gu(15)
            border.color: "#ECECEC"
            border.width: 1
            Text {
                id: newServerLabel
                text: i18n.tr("New server")
                anchors.top: parent.top
                anchors.topMargin: units.gu(1)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(1)
            }
            TextField {
                id: nameInput
                anchors.top:newServerLabel.bottom
                anchors.topMargin: units.gu(1)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(1)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(15)
                placeholderText: i18n.tr("name")
            }
            TextField {
                id: urlInput
                anchors.top:nameInput.bottom
                anchors.topMargin: units.gu(1)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(1)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(15)
                placeholderText: i18n.tr("url")
            }
            Button {
                text: i18n.tr("Add")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: units.gu(1)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(1)
                onClicked: {
                    addNewServer(nameInput.text, urlInput.text)
                    nameInput.text = ""
                    urlInput.text = ""
                }
            }
         }
    }

    tools: ToolbarItems {
       ToolbarButton {
           text: i18n.tr("Delete current")
           iconSource: Qt.resolvedUrl("../files/icone_skimber.png")
           onTriggered: deleteSelected()
       }
    }

    onExtraServersChanged: {
        if(extraServers) {
            for(var i=0; i<extraServers.length; i++) {
                listModelServers.append(extraServers[i])
                if(extraServers[i].selected === true) {
                    clearAndSelect(listModelServers.get(listModelServers.count-1))
                }
            }
        }
    }

    function clearAndSelect(data) {
        for(var i=0; i<listModelServers.count; i++) {
            if(data === listModelServers.get(i)) {
                listModelServers.setProperty(i, "selected", true)
            } else {
                listModelServers.setProperty(i, "selected", false)
            }
        }
        addServer(data.name, data.urlServer, true)//if exist ==> update
    }

    function addNewServer(name, url) {
        var o = {name: name, urlServer: url, select: false}
        listModelServers.append(o)
        clearAndSelect(listModelServers.get(listModelServers.count-1))
    }

    function deleteSelected() {
        var data = undefined;
        for(var i=0; i<listModelServers.count && data === undefined; i++) {
            if(listModelServers.get(i).selected === true) {
                data = listModelServers.get(i)
                deleteServer(data.name)
                listModelServers.remove(i, 1)
            }
        }
        if(listModelServers.count > 0) {
            clearAndSelect(listModelServers.get(0))
        }
    }

}
