import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
import "../utils"

Page {

    title: i18n.tr("Contact us")

    signal sendMsg(var msg)

    Rectangle {
        id: rectangleAccount
        width: parent.width
        height: parent.height

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: units.gu(1)
            spacing: units.gu(1)

            TextField {
                id: emailTextField
                width: messageTextField.width
                placeholderText: i18n.tr("mail")
            }
            TextField {
                id: objectTextField
                width: messageTextField.width
                placeholderText: i18n.tr("object")
            }
            TextArea {
                id: messageTextField
                placeholderText: i18n.tr("message")
                height: units.gu(25)
            }
            Button {
                text: i18n.tr("send")
                anchors.right: messageTextField.right
                onTriggered: sendMsg({email: emailTextField.text, object: objectTextField.text, message: messageTextField.text})
            }
        }
    }
}
