import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

Popover {
    id: popover

    signal newColumn()
    signal modColumn()
    signal delColumn()

    Column {
        id: containerLayout
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        ListItem.Standard {
            text: i18n.tr("New column")
            onClicked: {
                newColumn()
                PopupUtils.close(popover)
            }
        }
        ListItem.Standard {
            text: i18n.tr("Mod column")
            onClicked: {
                modColumn()
                PopupUtils.close(popover)
            }
        }
        ListItem.Standard {
            text: i18n.tr("Del column")
            onClicked: {
                delColumn()
                PopupUtils.close(popover)
            }
        }
    }
}
