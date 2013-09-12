import QtQuick 2.0
import Ubuntu.Components 0.1

Rectangle {
    id: rectangleContainer
    width: parent.width
    height: units.gu(8)
    border.color: "#ECECEC"
    border.width: 1

    property var column
    property var nbMsg
    property var nbMsgNoView

    onColumnChanged: {
        if(column) {
            myText.text = "<b>"+column.title+"</b> <i>("+i18n.tr("loading...")+")</i>"
            for(var i=0; i<column.unifiedRequests.count; i++) {
                var provider = column.unifiedRequests.get(i).service.split('.')[0]
                listModel.append({providerName: provider})
            }
        } else {
            myText.text = "Huuuu"
        }
    }

    onNbMsgChanged: {
        if(column && nbMsg) {
            myText.text = "<b>"+column.title+"</b> <i>("+nbMsgNoView+"/"+nbMsg+")</i>"
        }
    }

    onNbMsgNoViewChanged: {
        if(column && nbMsg) {
            myText.text = "<b>"+column.title+"</b> <i>("+nbMsgNoView+"/"+nbMsg+")</i>"
        }
    }

    ListModel {
        id: listModel
    }

    ListView {
        width: parent.width
        height: units.gu(8)
        anchors.bottom: parent.bottom
        orientation: ListView.Horizontal
        model: listModel
        delegate: Image {
            width: units.gu(8)
            height: width
            source: Qt.resolvedUrl("../files/brand/"+listModel.get(index).providerName+".png")
            opacity: 0.6
        }
    }
    Rectangle {
        opacity: 0.8
        anchors.fill: parent
        Text {
            id: myText
            anchors.centerIn: parent
            font.pointSize: units.gu(3)
            font.bold: true
            color: "#444"
        }
    }
}
