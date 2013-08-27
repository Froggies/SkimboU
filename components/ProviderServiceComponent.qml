import QtQuick 2.0
import Ubuntu.Components 0.1
import "../utils"

Rectangle {
    id: container
    width: parent.width
    height: units.gu(7)
    border.color: "#ECECEC"
    border.width: 1

    property variant service
    property ColorConstant colorConstant

    signal argValueChange(string newValue)
    signal tokenRequested(string provider)

    onServiceChanged: {
        if(service) {
            if(colorConstant === null) {
                colorConstant = Qt.createComponent(Qt.resolvedUrl("../utils/ColorConstant.qml")).createObject();
            }
            var providerName = service.providerName
            var serviceName = service.serviceName
            var hasToken = service.hasToken
            image.source = Qt.resolvedUrl("../files/brand/"+providerName+".png")
            text.text = serviceName
            updateServiceVisibility()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            service.selected = !service.selected
            if(service.hasToken === false && service.selected === true) {
                tokenRequested(service.providerName)
            }
            updateServiceVisibility()
        }
    }

    Image {
        id: image
        width: units.gu(5)
        height: width
        anchors.verticalCenter: container.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: units.gu(1)
    }
    Text {
        id: text
        anchors.verticalCenter: container.verticalCenter
        anchors.left: image.right
        anchors.leftMargin: units.gu(2)
    }
    TextField {
        id: argInput
        width: units.gu(12)
        visible: false
        anchors.verticalCenter: container.verticalCenter
        anchors.left: text.right
        anchors.leftMargin: units.gu(1)
        onTextChanged: {
            argValueChange(argInput.text)
        }
    }

    Rectangle {
        id: selected
        visible: false
        width: units.gu(2)
        height: width
        anchors.verticalCenter: container.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: units.gu(1)
        radius: width * 0.5
        border.color: "#ECECEC"
        border.width: 1
        antialiasing: true
    }

    function updateServiceVisibility() {
        if(service.selected) {
            selected.visible = true
            selected.color = colorConstant.getColorByProvider(providerName);
            if(service.arg.name) {
                argInput.visible = true
                argInput.placeholderText = arg.name
                argInput.text = arg.value
            }
        } else {
            selected.visible = false
            argInput.visible = false
        }
    }

}
