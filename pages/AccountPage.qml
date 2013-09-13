import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
import "../utils"

Page {

    title: i18n.tr("Accounts")

    signal goContact()
    signal disconnect()

    Rectangle {
        id: rectangleAccount
        width: parent.width
        height: parent.height

        ListModel {
            id: listModelAccounts
        }

        ListView {
            anchors.top: parent.top
            anchors.bottom: rectangleButtons.top
            anchors.bottomMargin: units.gu(1)
            width: parent.width
            clip: true
            model: listModelAccounts
            delegate: Rectangle {
                width: parent.width
                height: units.gu(8)
                border.color: "#ECECEC"
                border.width: 1
                property var account: listModelAccounts.get(index)
                Image {
                    id: imageProvider
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(1)
                    width: units.gu(3)
                    height: width
                    source: Qt.resolvedUrl("../files/brand/"+account.socialType+".png")
                }
                Image {
                    id: imageAccount
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: imageProvider.right
                    anchors.leftMargin: units.gu(1)
                    width: units.gu(3)
                    height: width
                    source: Qt.resolvedUrl(account.avatar)
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: imageAccount.right
                    anchors.leftMargin: units.gu(1)
                    text: account.username
                    color: account.providerColor
                }
            }

        }

        Row {
            id: rectangleButtons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(1)
            spacing: units.gu(1)
            Button {
                text: i18n.tr("Contact us")
                onTriggered: goContact()
            }
            Button {
                text: i18n.tr("About")
                onTriggered: Qt.openUrlExternally(i18n.tr("http://froggies.github.io/Skimbo/mobile_en.html"))
            }
            Button {
                text: i18n.tr("Logout")
                onTriggered: disconnect()
            }
        }

    }

    property Network network;
    property ColorConstant colorConstant

    function newDataFromServer(data) {
        //console.log("AccountPage :: newDataFromServer (l.79) :: "+data.cmd)
        if(data.cmd === "userInfos") {
            if(colorConstant === null) {
                colorConstant = Qt.createComponent(Qt.resolvedUrl("../utils/ColorConstant.qml")).createObject()
            }
            data.body.providerColor = colorConstant.getColorByProvider(data.body.socialType)
            listModelAccounts.append(data.body)
        }
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }
}
