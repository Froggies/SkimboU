import QtQuick 2.0
import Ubuntu.Components 0.1
//import Ubuntu.Unity.Action 1.0
import "components"
import "pages"
import "utils"

MainView {
    objectName: "SkimboU"
    applicationName: "SkimboU"

    id: root
    
    //automaticOrientation: true
    
    width: units.gu(35)
    height: units.gu(60)

    property Storage storage
    property Network network
    property string serverUrl: "http://127.0.0.1:9000"
    property string authUrl: serverUrl + "/api/mobile/auth/"
    property string connectUrl: serverUrl + "/api/mobile/connect/"
    property string commandUrl: serverUrl + "/api/mobile/command/"

    PageStack {
        id: globalContainer
        width: parent.width
        height: parent.height

        LoginPage {
            id: loginPage
            visible: false
            onLogin: {
                webView.title = provider
                webView.webViewUrl = authUrl + provider
                globalContainer.push(webView)
            }
            onGoSelectServerPage: {
                globalContainer.push(selectServerPage)
            }
        }
        WebViewPage {
            id: webView
            visible: false
            onGoBack: {
                globalContainer.pop()
            }
            onLogged: {
                storage.setSetting("token", token)
                network.connect(storage.getSetting("token"))
                globalContainer.pop()//webView delete
                globalContainer.push(defaultPageItem)
            }
        }
        SelectServerPage {
            id: selectServerPage
            title: i18n.tr("Skimbo's servers")
            visible: false
            onAddServer: {
                storage.addServer(name, urlServer, selected)
                serverUrl = urlServer
                if(network) {
                    network.connectUrl = connectUrl
                    network.commandUrl = commandUrl
                }
            }
            onDeleteServer: {
                storage.deleteServer(name)
            }
        }
        SkimberPage {
            id: skimberPage
            visible: false
            onNewTokenRequested: {
                webView.title = provider
                webView.webViewUrl = authUrl + provider
                globalContainer.push(webView)
            }
        }
        Item {
            id: defaultPageItem
            visible: false
            width: parent.width
            height: parent.height

            Component.onCompleted: {
                console.log("Skimbou :: itemOnComplet (l.88) :: width == "+width+" :: height == "+height)
            }

            QtObject {
                id: defaultPageSettings
                property Network network
            }

            Loader {
                id: loaderDefaultPageCompo
                active: false
                sourceComponent: defaultPageCompo
            }

            Component {
                id: defaultPageCompo

                DefaultPage {
                    width: defaultPageItem.width
                    height: defaultPageItem.height
                    Component.onCompleted: {
                        setNetwork(defaultPageSettings.network)
                        console.log("Skimbou :: defaultPageOnComplet (l.111) :: width == "+width+" :: height == "+height)
                    }

                    onGoBack: {
                        globalContainer.pop()
                        storage.setSetting("token", "Unknown")
                    }
                    onGoSkimber: {
                        skimberPage.text = ""
                        globalContainer.push(skimberPage)
                    }
                    onGoAddColumnPage: {
                        addColumnPage.column = null
                        globalContainer.push(addColumnPage)
                    }
                    onGoModifColumnPage: {
                        addColumnPage.column = column
                        globalContainer.push(addColumnPage)
                    }
                    onGoMessagePage: {
                        messagePage.message = message
                        globalContainer.push(messagePage)
                    }
                }
            }
        }
        AddColumnPage {
            id: addColumnPage
            visible: false
            onColumnAdded: globalContainer.pop()
        }
        MessagePage {
            id: messagePage
            visible: false
            onSendToServer: network.send(data)
            onGoSkimber: {
                skimberPage.text = message.message
                globalContainer.push(skimberPage)
            }
        }
        TestPage {
            id: testPage
            visible: false
        }

        Component.onCompleted: {
            globalContainer.push(loginPage)

            storage = Qt.createComponent("utils/Storage.qml").createObject();
            var servers = storage.getServers()
            selectServerPage.extraServers = servers;
            var foundServer = false;
            for(var i=0; i<servers.length && foundServer === false; i++) {
                if(servers[i].selected === true) {
                    foundServer = true
                    serverUrl = servers[i].urlServer
                }
            }

            network = Qt.createComponent("utils/Network.qml").createObject();
            network.connectUrl = connectUrl
            network.commandUrl = commandUrl
            defaultPageSettings.network = network
            addColumnPage.setNetwork(network)
            skimberPage.setNetwork(network)

            if(storage.getSetting("token") !== "Unknown") {
                network.connect(storage.getSetting("token"))
                loginPage.visible = false
                globalContainer.push(defaultPageItem)
                loaderDefaultPageCompo.active = true
                //globalContainer.push(testPage)
            }
        }

    }

    // HUD Actions
    /*Action {
        id: nextAction
        text: i18n.tr("Next")
        keywords: i18n.tr("Next Track")
        onTriggered: nextSong()
    }

    actions: [nextAction]*/

}
