import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
import "../utils"

Page {

    title: i18n.tr("Message")
    id: page

    signal sendToServer(var data)

    property var message
    property ColorConstant colorConstant

    onMessageChanged: {
        if(message) {
            if(colorConstant === null) {
                colorConstant = Qt.createComponent(Qt.resolvedUrl("../utils/ColorConstant.qml")).createObject();
            }
            var color = colorConstant.getColorByProvider(message.from);
            title = message.service
            authorName.text = message.authorScreenName;
            authorName.color = color;
            avatar.source = Qt.resolvedUrl(message.authorAvatar);
            text.text = message.message
            var date = new Date()
            date.setTime(message.createdAt)
            datetimeMsg.text = Qt.formatDateTime(date, i18n.tr("yyyy-MM-dd hh:mm:ss"));

            console.log("MessagePage :: onMessageChanged :: message = "+JSON.stringify(message))

            commentInput.visible = message.canComment
            commentButton.visible = message.canComment
            refreshButton.visible = message.hasDetails
            starButton.visible = message.canStar
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height

        Image {
            id: avatar
            width: units.gu(5)
            height: width
            anchors.top: parent.top
            anchors.topMargin: units.gu(1)
        }
        Label {
            id: authorName
            anchors.verticalCenter: avatar.verticalCenter
            anchors.verticalCenterOffset: -10
            anchors.left: avatar.right
            anchors.leftMargin: units.gu(1)
        }
        Label {
            id: datetimeMsg
            anchors.top: authorName.bottom
            anchors.left: authorName.left
        }

        Flickable {
            width: parent.width
            anchors.top: avatar.bottom
            topMargin: units.gu(1)
            anchors.bottom: parent.bottom
            contentWidth: text.width
            contentHeight: text.height+commentInput.height+units.gu(7)
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Text {
                id: text
                wrapMode: TextEdit.Wrap
                width: page.width
                anchors.margins: units.gu(2)
            }
            TextField {
                id: commentInput
                anchors.top: text.bottom
                anchors.topMargin: units.gu(1)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(1)
                anchors.right: commentButton.left
                anchors.rightMargin: units.gu(1)
                height: units.gu(5)
                placeholderText: i18n.tr("Comment")
            }
            Button {
                id: commentButton
                anchors.right: parent.right
                anchors.rightMargin: units.gu(1)
                anchors.top: commentInput.top
                height: commentInput.height
                text: i18n.tr("Send")
                onTriggered: {
                    sendToServer({
                        cmd: "comment",
                        body: {
                            "serviceName": message.service,
                            "providerId": message.idProvider,
                            "message": commentInput.text,
                            "columnTitle": message.column
                        }
                    })
                }
            }
        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            id: shareButton
            text: i18n.tr("Share")
            iconSource: Qt.resolvedUrl("../files/share.png")
        }
        ToolbarButton {
            id: refreshButton
            text: i18n.tr("Refresh")
            iconSource: Qt.resolvedUrl("../files/refresh.png")
            onTriggered: {
                sendToServer({
                    cmd: "detailsSkimbo",
                    body: {
                        "serviceName": message.service,
                        "id": message.idProvider,
                        "columnTitle": message.column
                    }
                })
            }
        }
        ToolbarButton {
            id: starButton
            text: i18n.tr("Star")
            iconSource: Qt.resolvedUrl("../files/star.png")
            onTriggered: {
                sendToServer({
                    cmd: "star",
                    body: {
                        "serviceName": message.service,
                        "id": message.idProvider,
                        "columnTitle": message.column
                    }
                })
            }
        }
    }

}
