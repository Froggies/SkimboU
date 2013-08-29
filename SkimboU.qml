import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import "pages"
import "utils"

MainView {
    objectName: "mainView"
    applicationName: "SkimboU"
    id: root
    
    /* 
     This property enables the application to change orientation 
     when the device is rotated. The default is false.
    */
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
                globalContainer.push(defaultPage)
            }
        }
        SelectServerPage {
            id: selectServerPage
            title: i18n.tr("Skimbo's servers")
            visible: false
            onAddServer: {
                storage.addServer(name, urlServer, selected)
            }
            onDeleteServer: {
                storage.deleteServer(name)
            }
        }
        DefaultPage {
            id: defaultPage
            visible: false
            onGoBack: {
                globalContainer.pop()
                storage.setSetting("token", "Unknown")
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
        AddColumnPage {
            id: addColumnPage
            visible: false
            onColumnAdded: globalContainer.pop()
        }
        MessagePage {
            id: messagePage
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
            defaultPage.setNetwork(network)
            addColumnPage.setNetwork(network)

            if(storage.getSetting("token") !== "Unknown") {
                network.connect(storage.getSetting("token"))
                loginPage.visible = false
                globalContainer.push(defaultPage)
            }
        }

    }

}
