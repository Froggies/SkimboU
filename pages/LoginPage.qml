import QtQuick 2.0
import Ubuntu.Components 0.1

Page {

    signal login(string provider)

    title: i18n.tr("Skimbo - Login")

    Column {
        id: pageLayout

        anchors {
            margins: units.gu(1)
            centerIn: parent
        }

        spacing: units.gu(1)

        Image {
            source: "../files/logo_skimbo.png"
        }

        Row {
            Button {
                text: i18n.tr("Login with Twitter")
                iconSource: Qt.resolvedUrl("../files/brand/twitter.png")
                onClicked: login("twitter")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("Login with Facebook")
                iconSource: Qt.resolvedUrl("../files/brand/facebook.png")
                onClicked: login("facebook")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("Login with G+")
                iconSource: Qt.resolvedUrl("../files/brand/googleplus.png")
                onClicked: login("googleplus")
                width: units.gu(25)
            }
        }
        Grid {
            columns: 4
            spacing: units.gu(1)

            Button {
                iconSource: Qt.resolvedUrl("../files/brand/github.png")
                onClicked: login("github")
                width: units.gu(5)
            }
            Button {
                iconSource: Qt.resolvedUrl("../files/brand/linkedin.png")
                onClicked: login("linkedin")
                width: units.gu(5)
            }
            Button {
                iconSource: Qt.resolvedUrl("../files/brand/viadeo.png")
                onClicked: login("viadeo")
                width: units.gu(5)
            }
            Button {
                iconSource: Qt.resolvedUrl("../files/brand/reddit.png")
                onClicked: login("reddit")
                width: units.gu(5)
            }
            Button {
                iconSource: Qt.resolvedUrl("../files/brand/scoopit.png")
                onClicked: login("scoopit")
                width: units.gu(5)
            }
            Button {
                iconSource: Qt.resolvedUrl("../files/brand/trello.png")
                onClicked: login("trello")
                width: units.gu(5)
            }
            Button {
                iconSource: Qt.resolvedUrl("../files/brand/bitbucket.png")
                onClicked: login("bitbucket")
                width: units.gu(5)
            }
        }
    }

}
