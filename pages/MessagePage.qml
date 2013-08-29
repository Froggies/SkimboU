import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
import "../utils"

Page {

    title: i18n.tr("Message")
    id: page

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
            /*"canComment":false,"canStar":false
            "hasDetails":false,"iStared":false
            "stared":-1*/
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
            contentHeight: text.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Text {
                id: text
                wrapMode: TextEdit.Wrap
                width: page.width
                anchors.margins: units.gu(2)
            }

        }
    }

}
