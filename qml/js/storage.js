.pragma library

function getDatabase() {
    return openDatabaseSync("tbclient", "1.0", "StorageDatabase", 10000000);
}

function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS userInfo(userId TEXT UNIQUE, userName TEXT, BDUSS TEXT, password TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS bookmark(threadId TEXT UNIQUE, postId TEXT, author TEXT, title TEXT, isLz BOOLEAN)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS customEmo(name TEXT UNIQUE, thumbnail TEXT, imageinfo TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS signTieba(fid TEXT UNIQUE, fname TEXT)');
                });
}

function saveUserInfo(userId, userName, BDUSS){
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT OR REPLACE INTO userinfo VALUES (?,?,?,?);', [userId, userName, BDUSS, ""]);
                       res = rs.rowsAffected > 0
                   })
    return res;
}

function getUserInfo(userId){
    var db = getDatabase()
    var res = []
    db.readTransaction(function(tx){
                           if (userId != undefined){
                               var rs = tx.executeSql('SELECT * FROM userInfo WHERE userId=?;',[userId]);
                               if (rs.rows.length > 0){
                                   var t = rs.rows.item(0)
                                   res.push({ userId: t.userId, userName: t.userName, BDUSS: t.BDUSS })
                               }
                           } else {
                               var rs = tx.executeSql('SELECT * FROM userInfo')
                               for (var i =0, l = rs.rows.length; i < l; i++){
                                   var t = rs.rows.item(i)
                                   res.push({ userId: t.userId, userName: t.userName, BDUSS: t.BDUSS })
                               }
                           }
                       })
    return res;
}

function deleteUserInfo(userId){
    var db = getDatabase()
    db.transaction(function(tx){
                       if (userId){
                           tx.executeSql('DELETE FROM userInfo WHERE userId=?;',[userId])
                       } else {
                           tx.executeSql('DELETE FROM userInfo')
                       }
                   })
}

function saveBookMark(threadId, postId, author, title, isLz){
    var db = getDatabase()
    var res = false
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT OR REPLACE INTO bookmark VALUES (?,?,?,?,?);',
                                              [threadId, postId, author, title, isLz]);
                       res = rs.rowsAffected > 0});
    return res
}
function getBookMark(listModel){
    var db = getDatabase()
    listModel.clear()
    db.readTransaction(function(tx) {
                           var rs = tx.executeSql('SELECT * FROM bookmark')
                           for (var i=0, l=rs.rows.length;i<l;i++){
                               var t = rs.rows.item(i)
                               listModel.append({
                                                    threadId: t.threadId,
                                                    postId: t.postId,
                                                    author: t.author,
                                                    title: t.title,
                                                    isLz: t.isLz
                                                })
                           }})
}
function deleteBookMark(threadId){
    var db = getDatabase();
    db.transaction(function(tx) {
                       if (threadId)
                           tx.executeSql('DELETE FROM bookmark WHERE threadId =?;',[threadId])
                       else
                           tx.executeSql('DELETE FROM bookmark')
                   })
}

function getCustomEmo(){
    var db = getDatabase()
    var res = []
    db.readTransaction(function(tx){
                           var rs = tx.executeSql('SELECT * FROM customEmo')
                           for (var i =0, l = rs.rows.length; i < l; i++){
                               var t = rs.rows.item(i)
                               res.push({ name: t.name, thumbnail: t.thumbnail, imageinfo: t.imageinfo })
                           }
                       })
    return res;
}

function addCustomEmo(name, thumbnail, imageinfo){
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT OR REPLACE INTO customEmo VALUES (?,?,?);', [name, thumbnail, imageinfo]);
                       res = rs.rowsAffected > 0
                   })
    return res;
}

function deleteCustomEmo(name){
    var db = getDatabase();
    db.transaction(function(tx) {
                       if (name)
                           tx.executeSql('DELETE FROM customEmo WHERE name =?;',[name])
                       else
                           tx.executeSql('DELETE FROM customEmo')
                   })
}

function getSignTieba(listModel){
    var db = getDatabase()
    listModel.clear()
    db.readTransaction(function(tx) {
                           var rs = tx.executeSql('SELECT * FROM signTieba')
                           for (var i=0, l=rs.rows.length;i<l;i++){
                               var t = rs.rows.item(i)
                               listModel.append({
                                                    fid: t.fid,
                                                    fname: t.fname,
                                                    state: 0,
                                                    errmsg: ""
                                                })
                           }})
}

function addSignTieba(list){
    var db = getDatabase();
    db.transaction(function(tx){
                       list.forEach(function(value){
                                        tx.executeSql('INSERT OR REPLACE INTO signTieba VALUES (?,?);', [value.fid, value.fname]);
                                    })
                   })
}

function deleteSignTieba(fid){
    var db = getDatabase();
    db.transaction(function(tx) {
                       if (fid)
                           tx.executeSql('DELETE FROM signTieba WHERE fid =?;',[fid]);
                       else
                           tx.executeSql('DELETE FROM signTieba');
                   })
}
