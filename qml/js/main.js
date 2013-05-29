.pragma library
Qt.include("storage.js");
Qt.include("const.js");
Qt.include("emoticon.js");

var signalCenter, tbsettings, utility;
var uid = "", username = "", BDUSS = "", tbs = "";

function sendWebRequest(url, param, callback, option){
    console.log("========request:", url);
    signalCenter.loadStarted();
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function(){
                if (xhr.readyState == XMLHttpRequest.DONE){
                    if (xhr.status == 200){
                        try {
                            callback(xhr.responseText, option);
                            signalCenter.loadFinished();
                        } catch(e){
                            console.log(JSON.stringify(e));
                            signalCenter.loadFailed("");
                        }
                    } else {
                        signalCenter.loadFailed(qsTr("Network Error > < Code:")+xhr.status);
                    }
                }
            }
    var postText = stringify(param);
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    xhr.setRequestHeader("Content-Length", postText.length);
    xhr.send(postText);
}

function loadAuthData(){
    if (tbsettings.clientId.length == 0){
        syncClient();
    }
    var u = getUserInfo(tbsettings.userId);
    if (u.length > 0){
        uid = u[0].userId;
        username = u[0].userName;
        BDUSS = u[0].BDUSS;
        signalCenter.userChanged();
    } else {
        signalCenter.needAuthorization(true);
    }
}

function stringify(obj){
    var paramArray = [];
    for (var i in obj){
        paramArray.push(i+"="+obj[i]);
    }
    paramArray = paramArray.sort();

    var sign = Qt.md5(decodeURIComponent(paramArray.join(""))+"tiebaclient!!!").toUpperCase();
    paramArray.push("sign="+sign);

    var result = paramArray.join("&");

    return result;
}

function tiebaParam(obj, notAuth){
    var res = new Object();
    if (!notAuth){
        res["BDUSS"] = BDUSS;
    }
    res["_client_id"] = tbsettings.clientId||"wappc_1362027349698_178";
    res["_client_type"] = tbsettings.clientType;
    res["_client_version"] = tbsettings.clientVersion;
    res["_phone_imei"] = tbsettings.imei;
    res["from"] = "baidu_appstore";
    res["net_type"] = 1;

    for (var i in obj){
        res[i] = obj[i];
    }

    return res;
}

function adjustCustomEmotion(content){
    var el = getCustomEmo();
    function change(emo){
        var name = emo.substring(2);
        for (var i in el){
            if (el[i].name == name){
                return "#("+el[i].imageinfo;
            }
        }
        return emo;
    }
    return content.replace(/#\([^)]*/g, change);
}

function syncClient(){
    var param = {
        "_client_type": tbsettings.clientType,
        "_client_version": tbsettings.clientVersion,
        "_msg_status": 1,
        "_os_version": "4.2.2",
        "_phone_imei": tbsettings.imei,
        "_phone_screen": "480%2C800",
        "from": "baidu_appstore",
        "net_type": 1
    }
    sendWebRequest(S_SYNC, param, syncClientResult);
}

function syncClientResult(oritxt){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        tbsettings.clientId = "wappc_1362027349698_178";
    } else {
        tbsettings.clientId = obj.client.client_id;
    }
}

function login(option){
    signalCenter.loginStarted();
    var param = {
        isphone: option.isPhone?1:0,
        passwd: Qt.btoa(option.password),
        un: encodeURIComponent(option.username)
    }
    if (option.vcode){
        param.vcode = option.vcode;
        param.vcode_md5 = option.vcodeMd5;
    }
    sendWebRequest(S_LOGIN, tiebaParam(param, true), loginResult);
}

function loginResult(oritxt){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.loginFailed();
        if (obj.anti.need_vcode == 1){
            signalCenter.needVCode("LoginPage", obj.anti.vcode_pic_url, obj.anti.vcode_md5);
        }
    } else {
        tbs = obj.anti.tbs;
        uid = obj.user.id;
        username = obj.user.name;
        BDUSS = obj.user.BDUSS;
        tbsettings.userId = uid;
        saveUserInfo(uid, username, BDUSS);
        utility.clearCache();
        signalCenter.userChanged();
        signalCenter.loginFinished();
    }
}

function getFavoriteTieba(){
    signalCenter.getFavoriteTiebaStarted();
    var param = { ctime: Date.now() }
    sendWebRequest(F_FORUM_FAVOCOMMEND, tiebaParam(param), getFavoriteTiebaResult, true);
}

function getFavoriteTiebaResult(oritxt, refreshCache){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.getFavoriteTiebaFinished([], 0);
    } else {
        if (refreshCache){ utility.setCache("myBarList", oritxt); }
        tbs = obj.anti.tbs;
        signalCenter.getFavoriteTiebaFinished(obj.forum_list, obj.time*1000)
    }
}

function getForumSuggest(quest){
    signalCenter.getForumSuggestStarted();
    var param = {
        q: encodeURIComponent(quest)
    }
    sendWebRequest(F_FORUM_SUG, tiebaParam(param), getForumSuggestResult);
}

function getForumSuggestResult(oritxt){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.getForumSuggestFinished([]);
    } else {
        signalCenter.getForumSuggestFinished(obj.fname);
    }
}

function searchPost(option){
    signalCenter.searchPostStarted();
    var param = {
        pn: option.pn,
        rn: option.rn||50,
        st_type: "search_post",
        word: encodeURIComponent(option.word)
    }
    sendWebRequest(S_SEARCHPOST, tiebaParam(param), searchPostResult);
}

function searchPostResult(oritxt, renew){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.searchPostFinished([], null);
    } else {
        signalCenter.searchPostFinished(obj.post_list, obj.page);
    }
}

function getThreadList(caller, option){
    signalCenter.getThreadListStarted(caller.toString());
    var param = {
        ctime: Date.now(),
        kw: encodeURIComponent(option.kw),
        pn: option.pn,
        rn: option.rn||35,
        st_type: "tb_forumlist"
    }
    if (option.isGood){
        param.is_good = 1;
        param.cid = option.cid;
    }
    option.caller = caller;
    sendWebRequest(F_FRS_PAGE, tiebaParam(param), loadThreadList, option);
}
function loadThreadList(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        if (!page.forum && obj.anti.forbid_flag != 0){
            signalCenter.showMessage(obj.anti.forbid_info);
        }
        tbs = obj.anti.tbs;
        page.forum = obj.forum;

        var classModel = option.classModel;
        classModel.clear();
        obj.forum.good_classify.forEach(function(value){
                                            classModel.append(value);
                                        })

        page.currentPage = obj.page.current_page;
        page.hasMore = obj.page.has_more == 1;
        page.hasPrev = obj.page.has_prev == 1;
        page.curGoodId = obj.page.cur_good_id;
        page.totalPage = obj.page.total_page;

        var threadModel = option.threadModel;
        threadModel.clear();
        obj.thread_list.forEach(function(value){
                                    value.author = value.author.name_show;
                                    value.last_replyer = value.last_replyer.name_show;
                                    value.abstract = value.abstract.length > 0 ? value.abstract[0].text : "";
                                    var pic = "";
                                    value.media.some(function(media){
                                                         if (media.type == 3 && media.small_pic){
                                                             pic = media.small_pic;
                                                             return true;
                                                         }
                                                     })
                                    value.media = pic;
                                    threadModel.append(value);
                                })
    }
    signalCenter.getThreadListFinished(page.toString());
}

function likeForum(option){
    signalCenter.showBusyIndicator();
    var param = {
        fid: option.fid,
        kw: encodeURIComponent(option.kw),
        tbs: tbs
    }
    sendWebRequest(option.islike?C_FORUM_LIKE:C_FORUM_UNLIKE, tiebaParam(param), requestResult);
}

function requestResult(oritxt){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        signalCenter.showMessage(qsTr("Success"));
    }
    signalCenter.hideBusyIndicator();
}

function sign(option){
    signalCenter.showBusyIndicator();
    var param = {
        fid: option.fid,
        kw: encodeURIComponent(option.kw),
        tbs: tbs
    }
    sendWebRequest(C_FORUM_SIGN, tiebaParam(param), signResult);
}

function signResult(oritxt){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        signalCenter.showMessage(qsTr("Sign Success! Rank: %1").arg(obj.user_info.user_sign_rank));
    }
    signalCenter.hideBusyIndicator();
}

function getPostList(caller, option){
    signalCenter.getPostListStarted(caller.toString());
    var param = {
        back: option.back ? 1 : 0,
        ctime: Date.now(),
        kz: option.kz,
        mark: option.mark ? 1 : 0,
        rn: 30,
        st_type: option.st||"tb_frslist"
    }
    if (option.weipost) { param.weipost = 1 }
    if (option.lz) { param.lz = 1; }
    if (option.pid){ param.pid = option.pid; }
    if (option.pn){ param.pn = option.pn; }
    if (option.last) { param.last = 1; }
    if (option.r) { param.r = 1; }

    option.caller = caller;
    sendWebRequest(F_PB_PAGE, tiebaParam(param), loadPostList, option)
}

function loadPostList(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        tbs = obj.anti.tbs;
        page.user = obj.user;
        page.forum = obj.forum;
        page.thread = obj.thread;
        page.currentPage = option.last?obj.page.total_page:obj.page.current_page;
        page.totalPage = obj.page.total_page;
        if (obj.hasOwnProperty("location") && page.hasOwnProperty("location")){
            page.location = obj.location;
        }
        var model = option.model;        
        if (option.renew){
            model.clear();
            page.hasMore = obj.page.has_more == 1;
            page.hasPrev = obj.page.has_prev == 1;
        }
        if (option.back){
            page.hasPrev = obj.page.has_prev == 1;
            obj.post_list.forEach(function(value, index){
                                      value.contentData = decodePostContent(value.content);
                                      model.insert(index, {"data": "", "modelData": value});
                                  })
        } else {
            page.hasMore = obj.page.has_more == 1;
            obj.post_list.forEach(function(value){
                                      value.contentData = decodePostContent(value.content);
                                      model.append({"data": "", "modelData": value});
                                  })
        }
    }
    signalCenter.getPostListFinished(page.toString());
}

function decodePostContent(list){
    var res = [];
    var len = -1;
    list.forEach(function(value){
                     if (value.type == 3){
                         var size = value.bsize.split(",");
                         res.push([false, value.src, size[0], size[1]]);
                         len ++;
                     } else {
                         //[isText, content, isRichText]
                         if (!res[len] || !res[len][0]){
                             res.push([true, "", false]);
                             len ++;
                         }
                         if (value.type != 0){
                             res[len][2] = true;
                         }
                         switch (value.type){
                         case "0":
                             res[len][1] += value.text||"";
                             break;
                         case "1":
                             res[len][1] += "<a href=\"link:%1\">%2</a>".arg(value.link).arg(value.text);
                             break;
                         case "2":
                             res[len][1] += getEmotion(value.text);
                             break;
                         case "4":
                             res[len][1] += "<a href=\"at:%1\">%2</a>".arg(value.uid).arg(value.text);
                             break;
                         case "5":
                             res[len][1] += "<a href=\"video:%1\" >%2</a>".arg(value.text).arg(qsTr("Click To Watch Video"));
                             break;
                         }
                     }
                 })
    return res;
}

function getFloorList(caller, option){
    signalCenter.getFloorListStarted(caller.toString());
    var param = {
        kz: option.kz,
        pn: option.pn,
        tbs: tbs
    }
    if (option.pid){ param.pid = option.pid }
    else { param.spid = option.spid }
    option.caller = caller;
    sendWebRequest(F_PB_Floor, tiebaParam(param), loadFloorList, option);
}

function loadFloorList(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        tbs = obj.anti.tbs;
        page.forum = obj.forum;
        page.thread = obj.thread;

        obj.post.content = decodeFloorList(obj.post.content)

        page.post = obj.post;
        page.postId = obj.post.id;
        page.currentPage = obj.page.current_page||1;
        page.totalPage = obj.page.total_page||1;
        var model = option.model;
        if (option.renew){ model.clear(); }
        obj.subpost_list.forEach(function(value){
                                     value.content = decodeFloorList(value.content);
                                     model.append(value);
                                 })
    }
    signalCenter.getFloorListFinished(page.toString());
}

function decodeFloorList(list){
    var res = "";
    list.forEach(function(value){
                     switch(value.type){
                     case "0":
                         res += (value.text || "").replace(/</g,"&lt;").replace(/\n/g,"<br/>");
                         break;
                     case "1":
                         res += "<a href=\"link:%1\">%2</a>".arg(value.link).arg(value.text);
                         break;
                     case "2":
                         res += getEmotion(value.text);
                         break;
                     case "3":
                         res += "<a href=\"img:%1\"><img src=\"%1\"/></a><br/>".arg(value.src);
                         break;
                     case "4":
                         res += "<a href=\"at:%1\">%2</a>".arg(value.uid).arg(value.text);
                         break;
                     }
                 })
    return res;
}

function getReplyMe(option){
    signalCenter.getReplyMeStarted();
    var param = { pn: option.pn, uid: uid }
    option.refreshCache = true;
    sendWebRequest(U_FEED_REPLYME, tiebaParam(param), loadReplyMe, option);
}

function loadReplyMe(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var page = option.page;
        page.currentPage = obj.page.current_page;
        page.hasMore = obj.page.has_more>0;
        page.lastUpdate = obj.time*1000;
        var model = option.model;
        if (obj.page.current_page==1){
            if (option.refreshCache) { utility.setCache("ReplyMe", oritxt); }
            model.clear();
        }
        obj.reply_list.forEach(function(value){ model.append(value); });
    }
    signalCenter.getReplyMeFinished();
}

function getAtMe(option){
    signalCenter.getAtMeStarted();
    var param = { pn: option.pn, uid: uid };
    option.refreshCache = true;
    sendWebRequest(U_FEED_ATME, tiebaParam(param), loadAtMe, option);
}

function loadAtMe(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var page = option.page;
        page.currentPage = obj.page.current_page;
        page.hasMore = obj.page.has_more > 0;
        page.lastUpdate = obj.time*1000;
        var model = option.model;
        if (obj.page.current_page == 1){
            if (option.refreshCache){ utility.setCache("AtMe", oritxt) }
            model.clear();
        }
        obj.at_list.forEach(function(value){ model.append(value); })
    }
    signalCenter.getAtMeFinished();
}

function getUserProfile(caller, option){
    signalCenter.getUserProfileStarted(caller.toString());
    var param = { uid: option.uid };
    option.caller = caller;
    sendWebRequest(U_USER_PROFILE, tiebaParam(param), loadUserProfile, option);
}

function loadUserProfile(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        if (option.refreshCache){ utility.setCache("Profile", oritxt); }
        page.user = obj.user;
        page.lastUpdate = obj.time*1000;
        tbs = obj.anti.tbs;
    }
    signalCenter.getUserProfileFinished(page.toString())
}

function getTimeline(caller, option){
    signalCenter.getTimelineStarted(caller.toString());
    var param = { pn: option.pn }
    option.caller = caller;
    sendWebRequest(U_FEED_MYPOST, tiebaParam(param), loadTimeline, option)
}
function loadTimeline(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.getTimelineFinished(page.toString(), []);
    } else {
        page.currentPage = obj.page.current_page;
        page.hasMore = obj.page.has_more == 1;
        signalCenter.getTimelineFinished(page.toString(), obj.post_list);
    }
}

function addThread(caller, option){
    signalCenter.postStarted(caller.toString());

    var content = option.content;
    content = adjustCustomEmotion(content);
    if (tbsettings.signText){ content+="\n"+tbsettings.signText };

    var param = {
        anonymous: 0,
        content: encodeURIComponent(content),
        fid: option.fid,
        tbs: tbs
    }
    if (option.weipost){
        param.st_type = "tb_suishoufa";
        param.thread_type = 7;
    }
    if (option.kw){ param.kw = encodeURIComponent(option.kw); }
    if (option.title){ param.title = encodeURIComponent(option.title); }
    if (option.lbs){ param.lbs = option.lbs; }
    if (option.vcode){
        param.vcode = option.vcode;
        param.vcode_md5 = option.vcodeMd5;
    }
    sendWebRequest(C_THREAD_ADD, tiebaParam(param), addThreadResult, caller);
}

function addThreadResult(oritxt, caller){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.postFailed(caller.toString());
        if (obj.info && obj.info.vcode_md5){
            signalCenter.needVCode(caller.toString(), obj.info.vcode_pic_url, obj.info.vcode_md5);
        }
    } else {
        signalCenter.showMessage(qsTr("Post Success!"));
        signalCenter.postFinished(caller.toString(), "thread");
    }
}

function addPost(caller, option){
    signalCenter.postStarted(caller.toString());

    var content = option.content;
    if (!option.hasOwnProperty("quote_id")){ content = adjustCustomEmotion(content); }
    if (tbsettings.signText){ content+="\n"+tbsettings.signText };

    var param = {
        anonymous: 0,
        content: encodeURIComponent(content),
        fid: option.fid,
        is_ad: 0,
        kw: encodeURIComponent(option.kw),
        tid: encodeURIComponent(option.tid),
        tbs: tbs
    }
    if (option.quote_id){
        param.quote_id = option.quote_id;
        param.floor_num = option.floor_num;
    }
    if (option.vcode){
        param.vcode = option.vcode;
        param.vcode_md5 = option.vcodeMd5;
    }
    sendWebRequest(C_POST_ADD, tiebaParam(param), addPostResult, caller);
}

function addPostResult(oritxt, caller){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
        signalCenter.postFailed(caller.toString());
        if (obj.info && obj.info.vcode_md5){
            signalCenter.needVCode(caller.toString(), obj.info.vcode_pic_url, obj.info.vcode_md5);
        }
    } else {
        signalCenter.showMessage(qsTr("Post Success!"));
        signalCenter.postFinished(caller.toString(), "post");
    }
}

function getFriendList(caller, option){
    signalCenter.getFriendListStarted(caller.toString());
    var param = new Object();
    if (option.uid) param.uid = option.uid;
    if (option.pn) param.pn = option.pn;
    var type = option.type;
    var url = type == "list" ? U_FOLLOW_LIST : type == "follow" ? U_FOLLOW_PAGE : U_FANS_PAGE
    option.caller = caller;
    sendWebRequest(url, tiebaParam(param), loadFriendlist, option);
}

function loadFriendlist(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var model = option.model;
        if (option.renew){ model.clear(); }
        if (obj.hasOwnProperty("page")){
            page.totalCount = obj.page.total_count;
            page.hasMore = obj.page.has_more == 1;
            page.currentPage = obj.page.current_page;
        }
        obj.user_list.forEach(function(value){ model.append(value); });
    }
    signalCenter.getFriendListFinished(page.toString());
}

function getFriendSuggest(caller, option){
    signalCenter.getFriendSuggestStarted(caller.toString());
    var param = {
        q: encodeURIComponent(option.q),
        uid: uid
    }
    option.caller = caller;
    sendWebRequest(U_FOLLOW_SUG, tiebaParam(param), loadFriendSuggest, option);
}

function loadFriendSuggest(oritxt, option){
    var obj = JSON.parse(oritxt);
    var page = option.caller;
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var friendModel = option.friendModel;
        var model = option.model;
        model.clear();
        for (var i=0, l=friendModel.count; i<l; i++){
            var name = friendModel.get(i).name;
            obj.uname.some(function(value){
                               if (value == name){
                                   model.append(friendModel.get(i));
                                   return true;
                               }
                           })
        }
    }
    signalCenter.getFriendSuggestFinished(page.toString());
}

function commitTop(option){
    signalCenter.showBusyIndicator();
    var param = {
        fid: option.fid,
        ntn: option.ntn,
        tbs: tbs,
        word: encodeURIComponent(option.word),
        z: option.z
    }
    sendWebRequest(C_BAWU_COMMITTOP, tiebaParam(param), requestResult);
}

function getGoodList(option){
    signalCenter.showBusyIndicator();
    var param = {
        tbs: tbs,
        word: encodeURIComponent(option.word)
    }
    sendWebRequest(C_BAWU_GOODLIST, tiebaParam(param), loadGoodList, option);
}
function loadGoodList(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var cate = {id:0,name:qsTr("Boutique"),class_id:0,class_name:qsTr("Boutique")};
        var list = [cate].concat(obj.cates);
        signalCenter.commitGood(list, option);
    }
    signalCenter.hideBusyIndicator();
}

function commitGood(option){
    signalCenter.showBusyIndicator();
    var param = {
        fid: option.fid,
        ntn: option.ntn,
        tbs: tbs,
        word: encodeURIComponent(option.word),
        z: option.z
    }
    if (option.hasOwnProperty("cid")) param.cid = option.cid;
    sendWebRequest(C_BAWU_COMMITGOOD, tiebaParam(param), requestResult);
}

function deleteThread(caller, option){
    signalCenter.showBusyIndicator();
    var param = {
        fid: option.fid,
        is_vipdel: option.vip?1:0,
        tbs: tbs,
        word: encodeURIComponent(option.word),
        z: option.z
    }
    sendWebRequest(C_BAWU_DELTHREAD, tiebaParam(param), deleteThreadResult, caller);
}
function deleteThreadResult(oritxt, caller){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        signalCenter.showMessage(qsTr("Success"));
        signalCenter.threadDeleted(caller.toString());
    }
    signalCenter.hideBusyIndicator();
}

function deletePost(caller, option){
    signalCenter.showBusyIndicator();
    var param = {
        fid: option.fid,
        is_vipdel: option.vip?1:0,
        isfloor: option.isfloor?1:0,
        pid: option.pid,
        src: option.src,
        tbs: tbs,
        word: encodeURIComponent(option.word),
        z: option.z
    }
    option.caller = caller;
    sendWebRequest(C_BAWU_DELPOST, tiebaParam(param), deletePostResult, option);
}
function deletePostResult(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        signalCenter.showMessage(qsTr("Success"));
        signalCenter.postDeleted(option.caller.toString(), option.pid);
    }
    signalCenter.hideBusyIndicator();
}

function commitPrison(option){
    signalCenter.showBusyIndicator();
    var param = {
        day: option.day,
        fid: option.fid,
        ntn: option.ntn,
        tbs: tbs,
        un: encodeURIComponent(option.un),
        word: encodeURIComponent(option.word),
        z: option.z
    }
    sendWebRequest(C_BAWU_COMMITPRISON, tiebaParam(param), requestResult);
}

function getHotFeed(option){
    signalCenter.getHotFeedStarted();
    var param = { pn: option.pn, rn: 35 }
    sendWebRequest(S_HOTFEED, tiebaParam(param), loadHotFeed, option);
}

function loadHotFeed(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var page = option.caller;
        page.currentPage = obj.page.current_page;
        page.hasMore = obj.page.has_more == 1;

        var model = option.model;
        if (option.renew){ model.clear(); }
        obj.thread_list.forEach(function(value){
                                    var pic = [];
                                    value.media.some(function(media){
                                                         if (media.type == 3 && media.small_pic){
                                                             pic.push(media.small_pic);
                                                         }
                                                         return pic.length >= 3;
                                                     })
                                    value.media = pic;
                                    value.abstract = value.abstract.length > 0 ? value.abstract[0].text : "";
                                    model.append({"data": "", "modelData": value});
                                })
    }
    signalCenter.getHotFeedFinished();
}

function followUser(caller, option){
    signalCenter.showBusyIndicator();
    var param = { portrait: option.portrait };
    var url = option.isfollow?C_USER_FOLLOW:C_USER_UNFOLLOW;
    sendWebRequest(url, tiebaParam(param), followUserResult, [caller, option]);
}
function followUserResult(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        signalCenter.showMessage(qsTr("Success"));
        signalCenter.followFinished(option[0].toString(), option[1].isfollow);
    }
    signalCenter.hideBusyIndicator();
}

function getMessage(){
    signalCenter.showBusyIndicator();
    var param = new Object();
    sendWebRequest(S_MSG, tiebaParam(param), loadMessage)
}
function loadMessage(oritxt){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var msg = obj.message;
        signalCenter.messageReceived(msg.fans, msg.replyme, msg.atme);
    }
    signalCenter.hideBusyIndicator();
}

function getPhotoBatch(caller, option){
    signalCenter.getThreadListStarted(caller.toString());
    var param = {
        an: 30,
        bs: option.bs,
        be: option.be,
        kw: encodeURIComponent(option.kw)
    }
    option.caller = caller;
    sendWebRequest(F_FRS_PHOTOLIST, tiebaParam(param), loadPhotoBatch, option);
}
function loadPhotoBatch(oritxt, option){
    var page = option.caller;
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        if (!page.forum && obj.anti.forbid_flag != 0){
            signalCenter.showMessage(obj.anti.forbid_info);
        }
        tbs = obj.anti.tbs;
        page.forum = obj.forum;

        var photoData = obj.photo_data;
        page.hasMore = photoData.has_more == 1;
        page.batchStart = photoData.batch_start;
        page.batchEnd = photoData.batch_end;
        page.photolist = photoData.alb_id_list;

        var model1 = option.model1, model2 = option.model2;
        model1.clear(); model2.clear();
        model1.cursor = 0; model2.cursor = 0;

        page.cursor = photoData.thread_list.length;
        decodePhotoList(photoData.thread_list, model1, model2);
    }
    signalCenter.getThreadListFinished(page.toString());
}

function getPhotoList(caller, option){
    signalCenter.getThreadListStarted(caller.toString());
    var param = {
        alb_ids: option.ids.join("%2C"),
        kw: encodeURIComponent(option.kw)
    }
    option.caller = caller;
    sendWebRequest(F_FRS_PHOTO, tiebaParam(param), loadPhotoList, option);
}
function loadPhotoList(oritxt, option){
    var page = option.caller;
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var list = obj.photo_data.thread_list;
        page.cursor += list.length;
        decodePhotoList(list, option.model1, option.model2);
    }
    signalCenter.getThreadListFinished(page.toString());
}
function decodePhotoList(list, model1, model2){
    var cursor1 = model1.cursor, cursor2 = model2.cursor;
    list.forEach(function(value){
                     var height = Math.round(value.photo.height/value.photo.width*200);
                     if (cursor1 <= cursor2){
                         model1.append(value);
                         cursor1 += height;
                     } else {
                         model2.append(value);
                         cursor2 += height;
                     }
                 })
    model1.cursor = cursor1;
    model2.cursor = cursor2;
}

function getPhotoPage(caller, option){
    signalCenter.getPostListStarted(caller.toString());
    var param = {
        kw: encodeURIComponent(option.kw),
        next: option.next,
        prev: option.prev,
        tid: option.tid
    }
    if (option.picid){ param.pic_id = option.picid; }
    option.caller = caller;
    sendWebRequest(F_PB_PICPAGE, tiebaParam(param), loadPhotoPage, option);
}

function loadPhotoPage(oritxt, option){
    var page = option.caller;
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        page.forum = obj.forum;
        page.picAmount = obj.pic_amount;
        var model = option.model;
        if (option.renew){ model.clear(); }
        obj.pic_list.forEach(function(value){
                                 value.descr = decodeFloorList(value.descr);
                                 model.append(value);
                             })
    }
    signalCenter.getPostListFinished(page.toString());
}

function getPicComment(caller, option){
    signalCenter.getFloorListStarted(caller.toString());
    var param = {
        alt: "json",
        kw: encodeURIComponent(option.kw),
        pic_id: option.picid,
        pn: option.pn,
        rn: 10,
        tid: option.tid,
        tbs: tbs
    }
    option.caller = caller;
    sendWebRequest(F_PB_PICCOMMENT, tiebaParam(param), loadPicComment, option);
}

function loadPicComment(oritxt, option){
    var page = option.caller;
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        tbs = obj.tbs.common;
        page.commentAmount = obj.comment_amount;
        page.currentPage = obj.cur_page;
        page.totalPage = obj.total_page;

        var model = option.model;
        if (option.renew){ model.clear(); }
        obj.comment_list.forEach(function(value){
                                     value.content = decodeFloorList(value.content);
                                     model.append(value);
                                 })
    }
    signalCenter.getFloorListFinished(page.toString());
}

function getLbsThread(caller, option){
    signalCenter.getThreadListStarted(caller.toString());
    var param = {
        lat: option.lat,
        lng: option.lng,
        pn: option.pn,
        ispv: 1,
        guide: 0,
        height: 800,
        width: 480
    }
    option.caller = caller;
    sendWebRequest(F_LBS_THREAD, tiebaParam(param), loadLbsThread, option);
}
function loadLbsThread(oritxt, option){
    var page = option.caller;
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        page.currentPage = obj.page.current_page;
        page.hasMore = obj.page.has_more == 1;

        var model = option.model;
        if (option.renew) model.clear();
        obj.thread_list.forEach(function(value){
                                    if (value.type == 0){
                                        model.append({
                                                         "tid": value.tid,
                                                         "fid": value.fid,
                                                         "fname": value.fname,
                                                         "reply_num": value.reply_num,
                                                         "author": value.author,
                                                         "content": {"list": decodePostContent(value.content)},
                                                         "time": value.time,
                                                         "replyer": value.replyer,
                                                         "reply_content": value.reply_content?decodeFloorList(value.reply_content):"",
                                                         "reply_time": value.reply_time,
                                                         "distance": value.distance
                                                     })
                                    }
                                })
    }
    signalCenter.getThreadListFinished(page.toString());
}

function getLbsForum(caller, option){
    signalCenter.getForumListStarted(caller.toString());
    var param = {
        ispv: 0,
        lat: option.lat,
        lng: option.lng
    }
    option.caller = caller;
    sendWebRequest(F_LBS_FORUM, tiebaParam(param), loadLbsForum, option);
}
function loadLbsForum(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var model = option.model;
        model.clear();
        obj.forum_list.forEach(function(value){
                                   model.append(value);
                               })
    }
    signalCenter.getForumListFinished(option.caller.toString());
}

function getLikeForum(caller, option){
    signalCenter.getForumListStarted(caller.toString());
    var param = new Object();
    if (option.uid){ param.uid = option.uid; }
    option.caller = caller;
    sendWebRequest(F_FORUM_LIKE, tiebaParam(param), loadLikeForum, option);
}
function loadLikeForum(oritxt, option){
    var obj = JSON.parse(oritxt);
    if (obj.error_code != 0){
        signalCenter.showMessage(obj.error_msg);
    } else {
        var model = option.model;
        model.clear();
        obj.forum_list.forEach(function(value){ model.append(value); })
    }
    signalCenter.getForumListFinished(option.caller.toString());
}
