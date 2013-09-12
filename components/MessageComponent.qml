import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"

Rectangle {
    id: parentContainer
    width: parent.width
    border.color: "#ECECEC"
    border.width: 1

    signal selectMessage(var message)

    property ColorConstant colorConstant
    property var message
    property bool showMoreButton: true

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
            if(message.stared > -1) {
                starText.visible = true
                starText.text = message.stared + "★";
            } else {
                starText.visible = false
            }
            //console.log("MessageComponent :: onMessageChanged :: "+message.createdAt)
            var date = new Date()
            date.setTime(message.createdAt)
            datetimeMsg.text = Qt.formatDateTime(date, i18n.tr("yyyy-MM-dd hh:mm:ss"));
            console.log("MessageComponent :: onMessageChanged :: "+message.isView)
            if(message.isView === false) {
                parentContainer.color = "#ECECED"
            } else {
                parentContainer.color = "#FFFFFF"
            }
        }
    }

    FontLoader { id: localFont; source: "../files/font/fontello.ttf" }

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
        height: parent.height
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
            anchors.bottomMargin: units.gu(2.8)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            width: parent.width
            clip: true
            wrapMode: Text.WordWrap
        }
        Label {
            id: starText
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(0.5)
            anchors.left: parent.left
            anchors.leftMargin: units.gu(0.5)
            font: localFont.name
        }
        Item {
            visible: showMoreButton
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(0.5)
            anchors.right: parent.right
            anchors.rightMargin: units.gu(0.5)
            width: units.gu(6)
            height: units.gu(4)
            Label {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: i18n.tr("more...")
            }
            MouseArea {
                anchors.fill: parent
                onClicked: selectMessage(message)
            }
        }
    }
}
