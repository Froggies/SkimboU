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
                iconSource: "../files/brand/twitter.png"
                onClicked: login("twitter")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("Login with Facebook")
                iconSource: "../files/brand/facebook.png"
                onClicked: login("facebook")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("Login with G+")
                iconSource: "../files/brand/googleplus.png"
                onClicked: login("googleplus")
                width: units.gu(25)
            }
        }
        Grid {
            columns: 4
            spacing: units.gu(1)

            Button {
                iconSource: "../files/brand/github.png"
                onClicked: login("?")
                width: units.gu(5)
            }
            Button {
                iconSource: "../files/brand/linkedin.png"
                onClicked: login("?")
                width: units.gu(5)
            }
            Button {
                iconSource: "../files/brand/viadeo.png"
                onClicked: login("?")
                width: units.gu(5)
            }
            Button {
                iconSource: "../files/brand/reddit.png"
                onClicked: login("?")
                width: units.gu(5)
            }
            Button {
                iconSource: "../files/brand/scoopit.png"
                onClicked: login("?")
                width: units.gu(5)
            }
            Button {
                iconSource: "../files/brand/trello.png"
                onClicked: login("?")
                width: units.gu(5)
            }
            Button {
                iconSource: "../files/brand/bitbucket.png"
                onClicked: login("?")
                width: units.gu(5)
            }
        }
    }

}
