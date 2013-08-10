import QtQuick 2.0

Item {

    property string connectUrl
    property string commandUrl
    property string token

    signal onNewDataFromServer(variant data)

    function connect(newToken) {
        token = newToken
        var http = new XMLHttpRequest()
        http.open("GET", connectUrl + token, true);

        http.onreadystatechange = function() { // Call a function when the state changes.
            var jsonArray = http.responseText.split('data: ')
            for(var json in jsonArray) {
                var j = jsonArray[json].trim()
                if(j.length > 0) {
                    var cmd = JSON.parse(j)
                    //console.log(j)
                    if(cmd.cmd === "ping") {
                        send("{cmd: pong}")
                    } else {
                        onNewDataFromServer(cmd)
                    }
                }
            }
        }
        http.send();
    }

    function send(data) {
        var http = new XMLHttpRequest()
        var param = data
        http.open("POST", commandUrl + token, true);

        http.send(param);
    }

}
