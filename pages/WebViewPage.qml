import QtQuick 2.0
import QtWebKit 3.0
import Ubuntu.Components 0.1

Page {

    property string webViewUrl
    signal goBack()
    signal logged(string token)

    WebView {
        id: webView
        height: parent.height
        width: parent.width
        url: webViewUrl

        onLoadingChanged: {
            if(webView.title.indexOf("skimboToken") == 0) {
                var token = webView.title.split("=")[1];
                console.log(token);
                logged(token);
            }
        }

        onLoadProgressChanged: {
            var percent = loadProgress / 100.0
            if(!percent) {//at begining percent is undefined
                percent = 0.0
            }
            progressBar.value = percent
            if(loadProgress === 100) {
                progressBar.visible = false
            } else {
                progressBar.visible = true
            }
        }

    }
    ProgressBar {
        id: progressBar
        anchors.centerIn: parent
        width: units.gu(20)
    }


}
