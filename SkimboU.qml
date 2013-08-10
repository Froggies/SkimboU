import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import "pages"

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

    PageStack {
        id: globalContainer

        LoginPage {
            id: loginPage
            onLogged: {
                loginPage.visible = false//TODO : why it's obligatory to no show button login ?
                globalContainer.push(Qt.createComponent("pages/DefaultPage.qml"))
            }
        }

    }

}
