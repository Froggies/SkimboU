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
            //console.log("MessageComponent :: onMessageChanged :: "+message.from)
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
            console.log("MessageComponent :: onMessageChanged :: "+message.createdAt)
            var date = new Date()
            date.setTime(message.createdAt)
            datetimeMsg.text = Qt.formatDateTime(date, "dd-MM-yyyy hh:mm:ss");
        }
    }


    Item {
        id: providerView
        width: units.gu(4)
        height: parent.height
        Text {
            id: providerName
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            rotation: 270
            width: units.gu(2)
            font.capitalization: Font.Capitalize
        }
        Rectangle {
            id: separatorLine
            anchors.left: providerName.right
            anchors.leftMargin: units.gu(1)
            width: 1
            height: parent.height
            color: "#ECECEC"
        }
        Rectangle {
            id: providerRound
            width: units.gu(2)
            height: width
            anchors.horizontalCenter: separatorLine.horizontalCenter
            anchors.verticalCenter: separatorLine.verticalCenter
            radius: width * 0.5
            border.color: "#ECECEC"
            border.width: 1
            antialiasing: true
        }
    }
    Item {
        height: units.gu(20)
        anchors.left: providerView.right
        anchors.leftMargin: units.gu(1)
        anchors.right: parent.right
        Item {
            id: authorView
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
        }
        Text {
            id: myText
            anchors.top: parent.top
            anchors.topMargin: units.gu(6.5)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(0.5)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(0.5)
            width: parent.width
            wrapMode: Text.WordWrap
            clip: true
        }
    }
}
