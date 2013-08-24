import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"

Rectangle {

    anchors.fill: parent

    property var column

    function addMsg(newMsg) {
        console.log("ColumnPage :: addMsg :: "+newMsg.sinceId);
        listModel.append(newMsg);
    }

    ListModel {
        id: listModel
    }

    ListView {
        anchors.fill: parent
        clip: true
        model: listModel
        delegate: MessageComponent {
            message: listModel.get(index)
        }
    }
}
