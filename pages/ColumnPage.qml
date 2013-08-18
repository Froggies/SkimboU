import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"

Rectangle {

    anchors.fill: parent

    property var column

    onColumnChanged: {
        if(column) {
        }
    }

    function addMsg(newMsg) {
        console.log("ColumnPage :: addMsg :: "+newMsg.sinceId);
        listModel.append(newMsg);
    }

    ListModel {
        id: listModel
    }

    ListView {
        anchors.fill: parent
        model: listModel
        delegate: MessageComponent {
            message: listModel.get(index)
        }
    }
}