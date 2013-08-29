import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {

    property var db

    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("Skimbo", "1.0", "StorageDatabase", 100000, db);
        init();
    }

    function init() {
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS servers(name TEXT UNIQUE, url TEXT, selected INTEGER)');
            tx.executeSql('INSERT OR IGNORE INTO servers VALUES (?,?,?);', [i18n.tr("Official"),"http://skimbo-froggies.rhcloud.com",true]);
            tx.executeSql('INSERT OR IGNORE INTO servers VALUES (?,?,?);', [i18n.tr("Test"),"http://skimbo.studio-dev.fr",false]);
            tx.executeSql('INSERT OR IGNORE INTO servers VALUES (?,?,?);', [i18n.tr("Dev"),"http://127.0.0.1:9000",false]);
        });
    }

    function setSetting(setting, value) {
       var res = "";
       db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
                  if (rs.rowsAffected > 0) {
                    res = "OK";
                  } else {
                    res = "Error";
                  }
            }
      );
      return res;
    }

    function getSetting(setting) {
       var res="";
       db.transaction(function(tx) {
         var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
         if (rs.rows.length > 0) {
              res = rs.rows.item(0).value;
         } else {
             res = "Unknown";
         }
      })
      return res
    }

    function addServer(name, url, selected) {
       var res = "";
       db.transaction(function(tx) {
             tx.executeSql('UPDATE servers SET selected=?;', [false]);
       });
       db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT OR REPLACE INTO servers VALUES (?,?,?);', [name,url,selected]);
                  if (rs.rowsAffected > 0) {
                    res = "OK";
                  } else {
                    res = "Error";
                  }
            }
      );
      return res;
    }

    function getServers() {
        var res=[];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM servers;');
            for (var i=0; i<rs.rows.length; i++) {
                var o = rs.rows.item(i)
                res.push({name: o.name, urlServer: o.url, selected: o.selected === 0 ? false : true});
            }
        })
        return res
    }

    function deleteServer(name) {
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM servers WHERE name=?;', [name]);
        })
    }
}
