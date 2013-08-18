import QtQuick 2.0
import QtWebKit 3.0
import Ubuntu.Components 0.1

Page {

    property string webViewUrl
    signal goBack()
    signal logged(string token)

    WebView {
        id: webView
        anchors {
            fill: parent
        }
        url: webViewUrl

        onLoadingChanged: {
            if(webView.title.indexOf("skimboToken") == 0) {
                var token = webView.title.split("=")[1];
                console.log(token);
                logged(token);
            }
        }
    }

}
