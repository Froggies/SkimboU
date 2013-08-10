import QtQuick 2.0
import Ubuntu.Components 0.1

Page {

    signal logged(string token)

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
                onClicked: logged("1")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("Login with Facebook")
                onClicked: logged("2")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("Login with G+")
                onClicked: logged("3")
                width: units.gu(25)
            }
        }
        Row {
            Button {
                text: i18n.tr("?")
                onClicked: logged("?")
                width: units.gu(5)
            }
            Button {
                text: i18n.tr("?")
                onClicked: logged("?")
                width: units.gu(5)
            }
            Button {
                text: i18n.tr("?")
                onClicked: logged("?")
                width: units.gu(5)
            }
            Button {
                text: i18n.tr("?")
                onClicked: logged("?")
                width: units.gu(5)
            }
            Button {
                text: i18n.tr("?")
                onClicked: logged("?")
                width: units.gu(5)
            }
        }
    }

}
