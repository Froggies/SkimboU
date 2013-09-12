import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
import "../utils"

Page {

    title: i18n.tr("Skimber")

    signal newTokenRequested(var provider)

    property alias text: textEditMessage.text

    Rectangle {
        id: rectangleSkimber
        width: parent.width
        height: parent.height

        Label {
            id: labelTitle
            anchors.top: parent.top
            anchors.topMargin: units.gu(1)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            text: i18n.tr("Title : ")
        }

        Rectangle {
            id: rectangleTextEditTitle
            anchors.top: labelTitle.bottom
            anchors.topMargin: units.gu(1)
            height: units.gu(4)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(1)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            border.color: "#ECECEC"
            border.width: 1
            antialiasing: true
            TextEdit {
                id: textEditTitle
                anchors.top: parent.top
                anchors.topMargin: units.gu(1)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: units.gu(1)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(1)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(1)
                clip: true
                wrapMode: Text.WordWrap
            }
        }

        Label {
            id: labelMessage
            anchors.top: rectangleTextEditTitle.bottom
            anchors.topMargin: units.gu(1)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            text: i18n.tr("Message : ")
        }

        Rectangle {
            id: rectangleTextEditMessage
            anchors.top: labelMessage.bottom
            anchors.topMargin: units.gu(1)
            height: units.gu(15)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(1)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            border.color: "#ECECEC"
            border.width: 1
            antialiasing: true
            TextEdit {
                id: textEditMessage
                anchors.top: parent.top
                anchors.topMargin: units.gu(1)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: units.gu(1)
                anchors.right: parent.right
                anchors.rightMargin: units.gu(1)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(1)
                clip: true
                wrapMode: Text.WordWrap
            }
        }

        Label {
            id: providersMessage
            anchors.top: rectangleTextEditMessage.bottom
            anchors.topMargin: units.gu(1)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            text: i18n.tr("Providers : ")
        }

        ListModel {
            id: postersListModel
        }

        ListView {
            anchors.top: providersMessage.bottom
            anchors.topMargin: units.gu(1)
            height: units.gu(30)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(1)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            clip: true
            model: postersListModel
            delegate: ProviderServiceComponent {
                service: postersListModel.get(index)
                onArgValueChange: {
                    var old = listModel.get(index)
                    old.arg = {name: old.arg.name, value:newValue}
                    listModel.set(index, old)
                }
                onTokenRequested: newTokenRequested(provider)
            }
        }

        Button {
            id: buttonValidate
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: units.gu(1)
            anchors.rightMargin: units.gu(1)
            text: i18n.tr("Send")
            onClicked: validate()
        }

        onVisibleChanged: {
            if(visible) {
                network.send({cmd:"allPosters"})
            }
        }

    }

    property Network network;

    function newDataFromServer(data) {
        if(data.cmd === "allPosters") {
            //console.log("SkimberPage :: newDataFromServer :: "+JSON.stringify(data.body))
            postersListModel.clear()
            for(var i in data.body) {
                var serviceName = data.body[i].service
                var providerName = data.body[i].tokenProvider
                var hasToken = data.body[i].hasToken
                var arg = data.body[i].canHavePageId === true  ? {name:"id", value:""} : undefined
                postersListModel.append({providerName: providerName, serviceName: serviceName, hasToken: hasToken, arg: arg})
            }
        }
    }

    function setNetwork(pnetwork) {
        network = pnetwork
        network.onNewDataFromServer.connect(newDataFromServer)
    }

    function validate() {
        var unifiedRequests = []
        for(var i=0; i < postersListModel.count; i++) {
            if(postersListModel.get(i).selected) {
                var args = {}
                if(postersListModel.get(i).arg) {
                    args[postersListModel.get(i).arg.name] = postersListModel.get(i).arg.value
                }
                unifiedRequests.push({
                    name:postersListModel.get(i).serviceName,
                    args: args
                })
            }
        }
        var o = {
          cmd: "post",
          body: {
            providers:unifiedRequests,
            post: {
              title: textEditTitle.text,
              message: textEditMessage.text,
              url: "",//TODO $scope.url,
              url_image: ""//TODO $scope.image
            }
          }
        }
        console.log("SkimberPage :: validate :: "+JSON.stringify(o))
        network.send(o);
    }

}
