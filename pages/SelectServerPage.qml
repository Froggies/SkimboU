import QtQuick 2.0
import Ubuntu.Components 0.1

Page {

    title: i18n.tr("Skimbo's servers")

    Component.onCompleted: listServers.model = [
       {name: i18n.tr("Official"), urlServer: "http://skimbo-froggies.rhcloud.com"},
       {name: i18n.tr("Test"), urlServer: "http://skimbo.studio-dev.fr"},
       {name: i18n.tr("Dev"), urlServer: "http://127.0.0.1:9000"}
    ]

    ListView {
        id: listServers
        anchors.fill: parent
        delegate: Rectangle {
           width: parent.width
           height: units.gu(10)
           border.color: "#ECECEC"
           border.width: 1
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
            }
         }
    }

}
