import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"

Page {

    title: i18n.tr("Message")
    id: page

    property var message

    onMessageChanged: {
        if(message) {
            title = message.authorScreenName
            text.text = message.message
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height

        Flickable {
            width: parent.width
            height: parent.height
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
