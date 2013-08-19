import QtQuick 2.0

Item {
    property var all: JSON.parse('{
        "twitter": "#00a0d1",
        "facebook": "#3b5998",
        "linkedin": "#0e76a8",
        "github": "#4183c4",
        "googleplus": "#db4a39",
        "scoopit": "#90D302",
        "viadeo": "#FFC906",
        "stackexchange": "#C47B07",
        "trello": "#A38F8F",
        "betaseries": "#3B8DD0",
        "rss": "#FC8815",
        "bitbucket": "#28649C",
        "reddit": "#FF4500"
    }')

    function getColorByProvider(provider) {
        return all[provider];
    }
}
