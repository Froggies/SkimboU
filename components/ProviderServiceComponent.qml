import QtQuick 2.0

Rectangle {
    width: 100
    height: 62

    property variant provider

    onProviderChanged: {
        console.log(provider)
        if(provider) {
            var providerName = provider.service.split('.')[0]
            var serviceName = provider.service.split('.')[1]
            image.source = Qt.resolvedUrl("../files/brand/"+providerName+".png")
            text.text = serviceName
        }
    }

    Image {
        id: image
    }
    Text {
        id: text
    }

}
