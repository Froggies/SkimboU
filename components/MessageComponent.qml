import QtQuick 2.0
import Ubuntu.Components 0.1

Rectangle {
    width: parent.width
    height: units.gu(20)

    property var message

    onMessageChanged: {
        if(message) {
            console.log("MessageComponent :: onMessageChanged :: "+message.sinceId)
            myText.text = message.message;
            authorName.text = message.authorScreenName;
            avatar.source = Qt.resolvedUrl(message.authorAvatar);
        }
    }

    Row {
        width: parent.width
        height: units.gu(20)
        Rectangle {
            width: units.gu(1)
            height: parent.height
            color: "#FF0000"
        }
        Column {
            width: parent.width
            height: units.gu(20)
            Row {
                Image {
                    id: avatar
                    width: units.gu(5)
                    height: width
                }
                Label {
                    id: authorName
                    color: "#FF0000"
                }
            }
            Text {
                id: myText
                width: parent.width
            }
        }
    }
}
