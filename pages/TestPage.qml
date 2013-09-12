import QtQuick 2.0
import Ubuntu.Components 0.1

Page {

    Rectangle {
        id: rectangle1
        anchors.fill: parent

        ListModel {
            id: cModel
            ListElement {
                name: "Bill Smith"
                number: "555 3264"
            }
            ListElement {
                name: "John Brown"
                number: "555 8426"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
            ListElement {
                name: "Sam Wise"
                number: "555 0473"
            }
        }
        ListView {
            id: list_view1
            width: rectangle1.width
            height: rectangle1.height - 40
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: Text {
                text: name + ": " + number
            }
            model: cModel
        }

        Rectangle {
            id: rectangle2
            width: 320
            height: 40
            color: "#ffffff"
            anchors.top: list_view1.bottom

            Text {
                id: text1
                text: qsTr("Click to add!")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                MouseArea {
                    id: mouse_area1
                    anchors.fill: parent
                    onClicked: addNewItemTop()
                }
            }
        }

    }

    function addNewItemTop() {
        var i = Math.random()

        cModel.insert(0, {
                          name: "New Number",
                          number: i.toString()
                      })

        console.log("l.89 : "+list_view1.indexAt(list_view1.contentX, list_view1.contentY));

        if(list_view1.indexAt(list_view1.contentX, list_view1.contentY) <= 0) {
            list_view1.contentY += list_view1.currentItem.height
        }

    }
}
