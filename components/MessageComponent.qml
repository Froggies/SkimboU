import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"

Rectangle {
    width: parent.width
    height: units.gu(20)
    border.color: "#ECECEC"
    border.width: 1

    property ColorConstant colorConstant
    property var message

    onMessageChanged: {
        if(message) {
            console.log("MessageComponent :: onMessageChanged :: "+message.from)
            if(colorConstant === null) {
                colorConstant = Qt.createComponent(Qt.resolvedUrl("../utils/ColorConstant.qml")).createObject();
            }
            var color = colorConstant.getColorByProvider(message.from);
            myText.text = message.message;
            authorName.text = message.authorScreenName;
            authorName.color = color;
            avatar.source = Qt.resolvedUrl(message.authorAvatar);
            providerRound.color = color;
            providerName.color = color;
            providerName.text = message.from;
        }
    }

    Row {
        width: parent.width
        height: units.gu(20)
        Item {
            width: units.gu(6)
            height: parent.height
            Text {
                id: providerName
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -15
                rotation: 270
            }
            Rectangle {
                anchors.centerIn: parent
                width: 1
                height: parent.height
                color: "#ECECEC"
            }
            Rectangle {
                id: providerRound
                width: units.gu(2)
                height: width
                anchors.centerIn: parent
                radius: width * 0.5
                border.color: "#ECECEC"
                border.width: 1
                antialiasing: true
            }
        }
        Column {
            width: parent.width
            height: units.gu(20)
            spacing: units.gu(1)
            Row {
                Image {
                    id: avatar
                    width: units.gu(5)
                    height: width
                }
                Label {
                    id: authorName
                    anchors.verticalCenter: avatar.verticalCenter
                }
            }
            Text {
                id: myText
                width: parent.width
                height: parent.height
                wrapMode: Text.WordWrap
                clip: true
            }
        }
    }
}
