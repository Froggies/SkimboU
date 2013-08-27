import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"

Tab {
    id: tab
    anchors.fill: parent

    signal selectMessage(var message)

    property var column

    onColumnChanged: {
        if(column) {
            tab.title = column.title
        } else {
            console.log("ColumnPage :: onColumnChanged :: "+JSON.stringify(column));
        }
    }

    function addMsg(newMsg) {
        //console.log("ColumnPage :: addMsg :: "+newMsg.sinceId);
        for(var i=0; i<listModel.count; i++) {
            if(listModel.get(i).createdAt < newMsg.createdAt) {
                listModel.insert(i, newMsg)
                return;
            } else if(listModel.get(i).createdAt === newMsg.createdAt) {
                listModel.set(i, newMsg)
                return;
            }
        }
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
            height: units.gu(20)
            onSelectMessage: tab.selectMessage(message)
        }
    }
}
