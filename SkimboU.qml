import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import "pages"
import QtQuick.LocalStorage 2.0
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
    
    width: units.gu(100)
    height: units.gu(75)

    property Storage storage
    property string serverUrl: "http://127.0.0.1:9000/api/mobile/auth/"

    PageStack {
        id: globalContainer

        LoginPage {
            id: loginPage
            onLogin: {
                visible = false
                webView.visible = true
                webView.title = provider
                webView.webViewUrl = serverUrl + provider
            }
        }
        WebViewPage {
            id: webView
            visible: false
            onLogged: {
                visible = false
                storage.setSetting("token", token)
                defaultPage.visible = true
            }
        }
        DefaultPage {
            id: defaultPage
            visible: false
        }

        Component.onCompleted: {
            storage = Qt.createComponent("utils/Storage.qml").createObject();
            if(storage.getSetting("token") !== "Unknown") {
                console.log(storage.getSetting("token"))
                loginPage.visible = false
                defaultPage.visible = true
            }
        }

    }

}
