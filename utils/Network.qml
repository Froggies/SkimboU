import QtQuick 2.0

Item {

    property string connectUrl
    property string commandUrl
    property string token

    signal onNewDataFromServer(variant data)

    function connect(newToken) {
        token = newToken
        var http = new XMLHttpRequest()
        http.open("GET", connectUrl + token, true)
        var alreadyTraited = 0

        http.onreadystatechange = function() {
            var jsonArray = http.responseText.split('data: ')
            var lastCatched = false
            //console.log("Network :: http receive :: length == "+jsonArray.length)
            for(var index=alreadyTraited; index < jsonArray.length; index++) {
                var j = jsonArray[index].trim()
                if(lastCatched !== false) {
                    j = lastCatched + j
                }
                if(j.length > 0) {
                    //console.log(j)
                    try {
                        var cmd = JSON.parse(j)
                        //console.log(cmd.cmd)
                        if(cmd.cmd === "ping") {
                            send({cmd: "pong"})
                        } else {
                            onNewDataFromServer(cmd)
                        }
                        lastCatched = false
                    } catch(e) {
                        lastCatched = j
                    }
                }
            }
            alreadyTraited = jsonArray.length
        }
        http.send();
    }

    function send(data) {
        var http = new XMLHttpRequest()
        var param = data
        //console.log("Network :: send :: data == "+data)
        http.open("POST", commandUrl + token, true);
        http.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        http.send(JSON.stringify(param));
    }

}
