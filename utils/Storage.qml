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
}
