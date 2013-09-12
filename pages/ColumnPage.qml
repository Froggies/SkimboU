import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"

Tab {
    id: tab

    signal selectMessage(var message)

    property var column

    onColumnChanged: {
        if(column) {
            tab.title = column.title
        }
    }

    function addMsg(newMsg) {
        //console.log("ColumnPage :: addMsg :: "+JSON.stringify(newMsg));
        newMsg.isView = false
        var isInView = false
        for(var i=0; i<listModel.count && isInView === false; i++) {
            if(listModel.get(i).createdAt < newMsg.createdAt) {
                listModel.insert(i, newMsg)
                isInView = true;
            } else if(listModel.get(i).createdAt === newMsg.createdAt) {
                newMsg.isView = true
                listModel.set(i, newMsg)
                isInView = true;
            }
        }
        if(isInView === false) {
            listModel.append(newMsg);
        }
        if(newMsg.isView === false && messagesListView.indexAt(messagesListView.contentX, messagesListView.contentY) <= 0) {
            messagesListView.contentY += units.gu(20)
        }
    }

    ListModel {
        id: listModel
    }

    ListView {
        id: messagesListView
        clip: true
        model: listModel
        delegate: MessageComponent {
            message: listModel.get(index)
            height: units.gu(20)
            onSelectMessage: tab.selectMessage(message)
        }
        onContentYChanged: {
            //console.log("ColumnPage :: listView (l.56) :: "+messagesListView.indexAt(contentX, contentY))
            var oldMsg = messagesListView.itemAt(contentX, contentY + units.gu(12))
            var oldIndex = messagesListView.indexAt(contentX, contentY + units.gu(12))
            if(oldMsg && oldMsg.message && oldMsg.message.isView === false) {
                oldMsg.message.isView = true
                oldMsg.message = oldMsg.message//update view
                for(var i=oldIndex; i<listModel.count; i++) {
                    listModel.setProperty(oldIndex, "isView", true)//update model in case of scroll down
                }
            }
        }
    }
}
