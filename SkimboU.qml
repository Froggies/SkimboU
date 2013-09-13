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
                globalContainer.push(globalContainer.getDefaultPage(network))
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
        AccountPage {
            id: accountPage
            visible: false
            onGoContact: globalContainer.push(contactPage)
            onDisconnect: {
                globalContainer.pop()//go on defaultPage
                globalContainer.pop()//go on loginPage
                storage.setSetting("token", "Unknown")
            }
        }
        ContactPage {
            id: contactPage
            visible: false
            onSendMsg: {
                network.send({cmd: "sendEmail", body:msg})
                globalContainer.pop()
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
            addColumnPage.setNetwork(network)
            skimberPage.setNetwork(network)
            accountPage.setNetwork(network)

            if(storage.getSetting("token") !== "Unknown") {
                network.connect(storage.getSetting("token"))
                loginPage.visible = false
                globalContainer.push(getDefaultPage(network))
                //globalContainer.push(testPage)
            }
        }

        property DefaultPage defaultPage;

        function getDefaultPage(network) {
            if(defaultPage === null) {
                var component = Qt.createComponent("pages/DefaultPage.qml");
                defaultPage = component.createObject(globalContainer);
                defaultPage.onGoAccount.connect(function() {
                    globalContainer.push(accountPage)
                })
                defaultPage.onGoSkimber.connect(function() {
                    skimberPage.text = ""
                    globalContainer.push(skimberPage)
                })
                defaultPage.onGoAddColumnPage.connect(function() {
                    addColumnPage.column = null
                    globalContainer.push(addColumnPage)
                })
                defaultPage.onGoModifColumnPage.connect(function(column) {
                    addColumnPage.column = column
                    globalContainer.push(addColumnPage)
                })
                defaultPage.onGoMessagePage.connect(function(message) {
                    messagePage.message = message
                    globalContainer.push(messagePage)
                })
            }
            defaultPage.setNetwork(network)
            return defaultPage;
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
