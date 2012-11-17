.pragma library

Qt.include("storage.js")

var signalCenter;
var tbsettings;

var userId = "", userName = "", BDUSS = "";
var tbs = "";
var clientId = "wappc_"+Date.now()+"_"+Math.floor(Math.random()*1000)

function sendWebRequest(method, url, callback, postText, param){
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function(){
                switch(xhr.readyState){
                case xhr.OPENED:
                    signalCenter.loadStarted()
                    break;
                case xhr.HEADERS_RECEIVED:
                    if (xhr.status != 200)
                        signalCenter.loadFailed("连接错误,代码:"+xhr.status+"  "+xhr.statusText)
                    break;
                case xhr.DONE:
                    if (xhr.status == 200){
                        try {
                            callback(xhr.responseText.replace(/id\":(\d+)/g,'id":"$1"'), param)
                            signalCenter.loadFinished()
                        } catch (e){
                            console.log(JSON.stringify(e))
                            signalCenter.loadFailed("")
                        }
                    } else {
                        signalCenter.loadFailed("")
                    }
                    break;
                }
            }
    xhr.open(method, url)
    if (method == "POST"){
        xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded")
        xhr.setRequestHeader("Content-Length",postText.length)
        xhr.send(postText)
    } else {
        xhr.send()
    }
}

function stringify(obj){
    var s = ""
    for (var i in obj)
        s += i+"="+obj[i]
    var sign = Qt.md5(decodeURIComponent(s)+"tiebaclient!!!").toUpperCase()

    var res = ""
    for (var i in obj)
        res += "&"+i+"="+obj[i]
    res += "&sign="+sign
    return res.replace("&","")
}

function login(caller, isPhoneNumber, username, password, vcode, vcodeMd5){
    signalCenter.loginStarted(caller)
    var obj = {
        _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        from: tbsettings.from, isphone: isPhoneNumber?1:0, net_type: tbsettings.netType,
        passwd: Qt.btoa(password), un: encodeURIComponent(username)
    }
    if (vcode) obj.vcode = vcode
    if (vcodeMd5) obj.vcode_md5 = vcodeMd5
    sendWebRequest("POST", tbsettings.host+"/c/s/login", loginResult, stringify(obj), caller)
}
function loginResult(oritxt, caller){
    var obj = JSON.parse(oritxt)
    //console.log("login=============================", oritxt)
    if (obj.error_code != 0){
        signalCenter.loginFailed(caller, obj.error_msg)
        if (obj.anti.need_vcode == 1){
            signalCenter.needVCode(caller, obj.anti.vcode_pic_url, obj.anti.vcode_md5)
        }
    } else {
        tbs = obj.anti.tbs
        userId = obj.user.id; userName = obj.user.name; BDUSS = obj.user.BDUSS
        signalCenter.loginSuccessed(caller, userId, userName, BDUSS)
    }
}

function getMyBarList(listModel){
    signalCenter.getMyBarListStarted()
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, ctime: new Date().getTime(), from: tbsettings.from, net_type: tbsettings.netType
    }
    sendWebRequest("POST", tbsettings.host+"/c/f/forum/favolike", loadMyBarList, stringify(obj), listModel)
}

function loadMyBarList(oritxt, listModel, cached){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0)
        signalCenter.getMyBarListFailed(obj.error_msg)
    else {
        tbs = obj.anti.tbs
        listModel.clear()
        for (var i in obj.forum_list)
            listModel.append(obj.forum_list[i])
        signalCenter.getMyBarListSuccessed(oritxt, cached||false)
    }
}

function getForumSuggest(searchText, listModel){
    signalCenter.getForumSuggestStarted()
    listModel.clear()
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType,
        q: encodeURIComponent(searchText, listModel)
    }
    sendWebRequest("POST", tbsettings.host+"/c/f/forum/sug", loadForumSuggest, stringify(obj), listModel)
}
function loadForumSuggest(oritxt, listModel){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0)
        signalCenter.getForumSuggestFailed(obj.error_msg)
    else {
        for (var i in obj.fname){
            listModel.append({
                                 "is_like": 0,
                                 "name": obj.fname[i]
                             })
        }
        signalCenter.getForumSuggestSuccessed(obj.error_msg)
    }
}

function getArticleList(caller, forumModel, goodModel, pageNumber, classid, isGood, keyword){
    signalCenter.loadForumStarted(caller)
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, cid: isGood?classid:0, ctime: new Date().getTime(), from: tbsettings.from,
        is_good: isGood ? 1: 0, kw: encodeURIComponent(keyword), net_type: tbsettings.netType,
        pn: pageNumber, rn: 35, st_type: "tb_forumlist"
    }
    sendWebRequest("POST", tbsettings.host+"/c/f/frs/page", loadArticleList, stringify(obj), [forumModel, goodModel, caller])
}

function loadArticleList(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.loadForumFailed(param[2], obj.error_msg)
    } else {
        tbs = obj.anti.tbs
        param[1].clear()
        for (var i in obj.forum.good_classify)
            param[1].append(obj.forum.good_classify[i])
        param[0].clear()
        for (var i in obj.thread_list){
            var t = obj.thread_list[i];
            var pic = [];
            for (var j=0;j<t.media.length && pic.length < 3;j++){
                if (t.media[j].type == 3){
                    pic.push(t.media[j].big_pic)
                }
            }
            t.pic = pic;
            param[0].append({"data": t})
        }
        signalCenter.loadForumSuccessed(param[2], obj.forum, obj.page, obj.anti.forbid_info)
    }
}

function getThreadList(page, threadId, option){
    signalCenter.loadThreadStarted(page.toString())
    var obj = {
        BDUSS: BDUSS,
        _client_id: clientId,
        _client_type: tbsettings.clientType,
        _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei,
        back: option.back||0,
        ctime: Date.now().toString().slice(-4),
        from: tbsettings.from,
        kz: threadId,
        last: option.last||0,
        lz: option.lz||0,
        mark: option.mark||0,
        net_type: tbsettings.netType,
        pid: option.pid||0,
        pn: option.pn||0,
        r: option.r||0,
        rn: option.rn||60,
        st_type: "tb_frslist"
    }
    sendWebRequest("POST", tbsettings.host+"/c/f/pb/page", loadThreadList, stringify(obj), [page, option])
}

function loadThreadList(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0){
        signalCenter.loadThreadFailed(param[0].toString(), obj.error_msg)
    } else {
        tbs = obj.anti.tbs
        var p = param[0]
        p.hasFloor = obj.has_floor == 1
        p.forum = obj.forum
        p.thread = obj.thread
        p.currentPage = obj.page.current_page
        p.totalPage = obj.page.total_page
        p.manageGroup = obj.user.is_manager || (obj.user.id == obj.thread.author.id ? 3 : 0)

        var opt = param[1]
        if (opt.back){
            if (opt.renew){
                p.downPage = obj.page.current_page
                p.hasDownwards = obj.page.has_more == 1;
                p.listModel.clear();
            }
            p.hasUpwards = obj.page.has_prev == 1
            p.topPage = obj.page.current_page
            for (var i in obj.post_list){
                var t = obj.post_list[i]
                t.contentData = decodeThreadContentList(t.content)
                p.listModel.insert(i, {"data":t})
            }
            p.threadView.positionViewAtIndex(obj.post_list.length, 3)
        } else {
            if (opt.renew){
                p.topPage = obj.page.current_page
                p.hasUpwards = obj.page.has_prev == 1
                p.listModel.clear()
            }
            p.hasDownwards = obj.page.has_more == 1
            p.downPage = obj.page.current_page

            for (var i in obj.post_list){
                var t = obj.post_list[i]
                t.contentData = decodeThreadContentList(t.content)
                p.listModel.append({"data":t})
            }
        }
        signalCenter.loadThreadSuccessed(p.toString())
    }
}

function postReply(callerItem, content, forum, threadId, floorNum, quoteId, vcode, vcodeMd5){
    signalCenter.postReplyStarted(callerItem.toString())
    content = adjustCustomEmotion(content)
    if (tbsettings.signText != "") content += "\n"+tbsettings.signText
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, anonymous: 0, content: encodeURIComponent(content), fid: forum.id,
        floor_num: floorNum||0, from: tbsettings.from, kw: encodeURIComponent(forum.name), net_type: tbsettings.netType,
        quote_id: quoteId||0, tbs: tbs, tid: threadId
    }
    if (vcode){
        obj.vcode = vcode; obj.vcode_md5 = vcodeMd5
    }
    sendWebRequest("POST", tbsettings.host+"/c/c/post/add", replyResult, stringify(obj),
                   {callerItem: callerItem, threadId: threadId})
}

function replyResult(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.postReplyFailed(param.callerItem.toString(), obj.error_msg)
        //console.log("reply===========================", oritxt)
        if (obj.info && obj.info.vcode_md5){
            signalCenter.needVCode(param.callerItem.toString(), obj.info.vcode_pic_url, obj.info.vcode_md5)
        }
    } else {
        signalCenter.postReplySuccessed(param.callerItem.toString())
    }
}

function getFriendList(caller, type, param, uid, listModel, isRenew, pageNumber){
    signalCenter.getFriendListStarted(caller)
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType
    }
    if (pageNumber) obj.pn = pageNumber
    if (uid) obj.uid = uid
    if (isRenew) listModel.clear()
    sendWebRequest("POST", tbsettings.host+"/c/u/"+type+"/"+param, loadFriendList, stringify(obj), [caller, listModel])
}

function loadFriendList(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.getFriendListFailed(param[0], obj.error_msg)
    } else {
        for (var i in obj.user_list)
            param[1].append(obj.user_list[i])
        signalCenter.getFriendListSuccessed(param[0], obj.page)
    }
}

function getFollowSuggest(caller, quest, friendModel, filterModel){
    signalCenter.getFriendListStarted(caller)
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType, q: encodeURIComponent(quest),
        uid: userId
    }
    sendWebRequest("POST", tbsettings.host+"/c/u/follow/sug", loadFollowSuggest, stringify(obj), [caller, friendModel, filterModel])
}

function loadFollowSuggest(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.getFriendListFailed(param[0], obj.error_msg)
    } else {
        param[2].clear()
        for (var i=0, l=param[1].count; i<l; i++){
            for (var j in obj.uname){
                var t = param[1].get(i)
                if (t.name == obj.uname[j])
                    param[2].append(t)
            }
        }
        signalCenter.getFriendListSuccessed(param[0], undefined)
    }
}

function getSubfloorList(page, threadId, option){
    console.log(JSON.stringify(option))
    signalCenter.getSubfloorListStarted(page.toString())
    var obj = {
        BDUSS: BDUSS,
        _client_id: clientId,
        _client_type: tbsettings.clientType,
        _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei,
        from: tbsettings.from,
        kz: threadId,
        net_type: tbsettings.netType,
        pid: option.pid||0,
        pn: option.pn||0,
        spid: option.spid||0,
        tbs: tbs
    }
    sendWebRequest("POST", tbsettings.host+"/c/f/pb/floor", loadSubfloorList, stringify(obj), [page, option])
}

function loadSubfloorList(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.getSubfloorListFailed(param[0].toString(), obj.error_msg)
    } else {
        var p = param[0]
        p.forum = obj.forum; p.thread = obj.thread;
        obj.post.contentString = decodeThreadContent(obj.post.content)
        p.post = obj.post
        tbs = obj.anti.tbs
        p.page = obj.page
        p.postId = obj.post.id
        p.pageNumber = obj.page.current_page||1

        var m = p.view.model;
        if (param[1].renew){
            m.clear(); p.view.positionViewAtBeginning();
        }
        for (var i in obj.subpost_list){
            var t = obj.subpost_list[i]
            t.contentString = decodeThreadContent(t.content)
            m.append({"data": t})
        }
        signalCenter.getSubfloorListSuccessed(p.toString())
    }
}

function getReplyList(pageNumber, isRenew, replyModel){
    signalCenter.getReplyListStarted()
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType,
        pn: pageNumber, uid: userId
    }
    sendWebRequest("POST", tbsettings.host+"/c/u/feed/replyme", loadReplyToMeResult, stringify(obj), [isRenew, replyModel])
}

function loadReplyToMeResult(oritxt, param, cached){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0){
        signalCenter.getReplyListFailed(obj.error_msg)
    } else {
        if (param[0])
            param[1].clear()
        for (var i in obj.reply_list)
            param[1].append(obj.reply_list[i])
        if (!cached)
            loadMessageObj(obj.message)
        signalCenter.getReplyListSuccessed(oritxt, obj.page, cached||false)
    }
}

function getAtMeList(pageNumber, isRenew, atModel){
    signalCenter.getAtListStarted()
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType,
        pn: pageNumber, uid: userId
    }
    sendWebRequest("POST", tbsettings.host+"/c/u/feed/atme", loadAtMeList, stringify(obj), [isRenew, atModel])
}

function loadAtMeList(oritxt, param, cached){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.getAtListFailed(obj.error_msg)
    } else {
        if(param[0]) param[1].clear()
        for (var i in obj.at_list)
            param[1].append(obj.at_list[i])
        if (!cached)
            loadMessageObj(obj.message)
        signalCenter.getAtListSuccessed(oritxt, obj.page, cached||false)
    }
}

function ding(caller, forum, threadId){
    signalCenter.dingStarted(caller)
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, fid: forum.id, from: tbsettings.from, kw: encodeURIComponent(forum.name), net_type: tbsettings.netType,
        tbs: tbs, tid: threadId
    }
    sendWebRequest("POST", tbsettings.host+"/c/c/thread/comment", dingResult, stringify(obj), caller)
}
function dingResult(oritxt, caller){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0)
        signalCenter.dingFailed(caller, obj.error_msg)
    else
        signalCenter.dingSuccessed(caller)
}

function getMessage(){
    signalCenter.getMessageStarted()
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType
    }
    sendWebRequest("POST", tbsettings.host+"/c/s/msg", loadMessage, stringify(obj))
}
function loadMessage(oritxt){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0)
        signalCenter.getMessageFailed(obj.error_msg)
    else {
        loadMessageObj(obj.message)
    }
}

function loadMessageObj(obj){
    var msg = "", type = ""
    if (obj.fans > 0 && tbsettings.remindNewFans){
        msg += "\n"+obj.fans+"个新粉丝"; type = "fans"
    }
    if (obj.replyme > 0 && tbsettings.remindReplyToMe){
        msg += "\n"+obj.replyme+"个新回复"; type = "replyme"
    }
    if (obj.atme > 0 && tbsettings.remindAtMe){
        msg += "\n"+obj.atme+"处提到我"; type = "atme"
    }
    signalCenter.getMessageSuccessed(msg.replace("\n", ""), type)
}

function getProfile(caller){
    signalCenter.getProfileStarted(caller.toString())
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType, uid: caller.userId
    }
    sendWebRequest("POST", tbsettings.host+"/c/u/user/profile", loadProfile, stringify(obj), caller)
}

function loadProfile(oritxt, caller){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0)
        signalCenter.getProfileFailed(caller.toString(), obj.error_msg)
    else {
        tbs = obj.anti.tbs
        caller.user = obj.user
        signalCenter.getProfileSuccessed(caller.toString())
    }
}

function followFriend(caller, isConcern){
    signalCenter.concernStarted(caller.toString())
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientTpe, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType, portrait: caller.user.portrait,
        tbs: tbs
    }
    var url = isConcern ? "/c/c/user/follow" : "/c/c/user/unfollow"
    sendWebRequest("POST", tbsettings.host+url, followResult, stringify(obj), [caller, isConcern])
}
function followResult(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0)
        signalCenter.concernFailed(param[0].toString(), obj.error_msg)
    else {
        param[0].hasConcerned = param[1]
        signalCenter.concernSuccessed(param[0].toString())
    }
}

function signIn(caller){
    signalCenter.signInStarted(caller.toString())
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, kw: encodeURIComponent(caller.forum.name),
        net_type: tbsettings.netType, tbs: tbs
    }
    sendWebRequest("POST", tbsettings.host+"/c/c/forum/sign", signInResult, stringify(obj), [caller])
}
function signInResult(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.signInFailed(param[0].toString(), obj.error_msg)
    }
    else {
        signalCenter.signInSuccessed(param[0].toString(), obj.user_info)
    }
}

function likeForum(caller, islike){
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, fid: caller.forum.id, from: tbsettings.from, kw: encodeURIComponent(caller.forum.name),
        net_type: tbsettings.netType, tbs: tbs
    }
    sendWebRequest("POST", tbsettings.host+"/c/c/forum/"+(islike?"like":"unlike"), likeForumResult, stringify(obj), caller)
}
function likeForumResult(oritxt, caller){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0)
        signalCenter.likeForumFailed(caller.toString(), obj.error_msg)
    else {
        signalCenter.likeForumSuccessed(caller.toString())
    }
}

function getRecommendPic(){
    var obj = {
        ak: randomString(), ap: "tieba", os: "android"
    }
    sendWebRequest("POST", tbsettings.host+"/c/s/recommendPic/", getRecommendPicResult, stringify(obj))
}
function getRecommendPicResult(oritxt){
    //console.log(oritxt)
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.getRecommendPicFailed(obj.error_msg)
    } else {
        signalCenter.getRecommendPicSuccessed(obj.recommend_pic)
    }
}

function postArticle(caller, title, content, forum, vcode, vcodeMd5){
    signalCenter.postArticleStarted(caller.toString())
    content = adjustCustomEmotion(content)
    if (tbsettings.signText != "") content += "\n"+tbsettings.signText
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, anonymous: 0, content: encodeURIComponent(content), fid: forum.id, from: tbsettings.from,
        kw: encodeURIComponent(forum.name), net_type: tbsettings.netType, tbs: tbs, title: encodeURIComponent(title)
    }
    if (vcode){
        obj.vcode = vcode
        obj.vcode_md5 = vcodeMd5
    }
    sendWebRequest("POST", tbsettings.host+"/c/c/thread/add", postArticleResult, stringify(obj), [caller])
}
function postArticleResult(oritxt, param){
    var obj = JSON.parse(oritxt)
    //console.log("post===================", oritxt)
    if (obj.error_code != 0){
        signalCenter.postArticleFailed(param[0].toString(), obj.error_msg)
        if (obj.info && obj.info.vcode_md5){
            signalCenter.needVCode(param[0].toString(), obj.info.vcode_pic_url, obj.info.vcode_md5)
        }
    } else {
        signalCenter.postArticleSuccessed(param[0].toString())
    }
}

function threadManage(caller, option, postId, isVipDel, isFloor, source){
    var obj = {
        BDUSS: BDUSS,
        _client_id: clientId,
        _client_type: tbsettings.clientType,
        _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei,
        fid: caller.forum.id,
        from: tbsettings.from,
        is_vipdel: isVipDel?1:0,
        isfloor: isFloor?1:0,
        net_type: tbsettings.netType,
        pid: postId,
        src: source,
        tbs: tbs,
        word: encodeURIComponent(caller.forum.name),
        z: caller.thread.id
    }
    sendWebRequest("POST",
                   tbsettings.host+"/c/c/bawu/"+option,
                   threadManageResult,
                   stringify(obj),
                   [caller, option, postId])
}

function threadManageResult(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.manageFailed(param[0].toString(), obj.error_msg)
    } else {
        signalCenter.manageSuccessed(param[0].toString(), param[1], param[2])
    }
}

function commitprison(caller, username, day){
    var obj = {
        BDUSS: BDUSS,
        _client_id: clientId,
        _client_type: tbsettings.clientType,
        _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei,
        day: day,
        fid: caller.forum.id,
        from: tbsettings.from,
        net_type: tbsettings.netType,
        ntn: "banid",
        tbs: tbs,
        un: encodeURIComponent(username),
        word: encodeURIComponent(caller.forum.name),
        z: caller.thread.id
    }
    sendWebRequest("POST", tbsettings.host+"/c/c/bawu/commitprison", commitprisonResult, stringify(obj), [caller])
}

function commitprisonResult(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.manageFailed(param[0].toString(), obj.error_msg)
    } else {
        signalCenter.manageSuccessed(param[0].toString(), "commitprison", "")
    }
}

///////////////////////////////////////////////////////////////////////

function decodeThreadContentList(obj){
    var res = []
    var len = -1
    for (var i in obj){
        var o = obj[i]
        if (o.type == 3){
            res.push([false, o.src, o.bsize])
            len ++
        } else {
            //[isText, Content, isRichText]
            if (!res[len] || !res[len][0]){
                res.push([true,"",false])
                len ++
            }
            if (o.type!=0 && !res[len][2])
                res[len][2] = true
            switch(o.type){
            case 0:
                res[len][1] += o.text || ""
                break
            case 1:
                res[len][1] += "<a href=\"link:%1\">%2</a>".arg(o.link).arg(o.text);
                break
            case 2:
                var txt = o.text.replace(/i_f/,"write_face_")
                var sfx = /(B|t|w)_/.test(txt)?".gif\"/>":".png\"/>"
                res[len][1] += "<img src=\"qrc:/emo/pics/" + txt.toLowerCase() + sfx
                break;
            case 4:
                res[len][1] += "<a href=\"at:%1\">%2</a>".arg(o.uid).arg(o.text);
                break
            case 5:
                res[len][1] += "<a href=\"video:%1\" >点击链接查看视频</a>".arg(o.text);
                break
            }
        }
    }
    return res
}


function decodeThreadContent(obj){
    var res = ""
    for (var i in obj){
        switch(obj[i].type){
        case 0: res += (obj[i].text || "").replace(/</g,"&lt;").replace(/\n/g,"<br/>"); break;
        case 1: res += "<a href=\"link:%1\">%2</a>".arg(obj[i].link).arg(obj[i].text); break
        case 2:
            var txt = obj[i].text.replace(/i_f/,"write_face_")
            var sfx = /(B|t|w)_/.test(txt)?".gif\"/>":".png\"/>"
            res += "<img src=\"qrc:/emo/pics/" + txt.toLowerCase() + sfx
            break;
        case 3:
            if (tbsettings.showImage)
                res += "<a href=\"img:%1\" ><img src=\"%1\"/></a><br/>".arg(obj[i].src)
            else
                res += "<a href=\"img:%1\" >点击链接查看图片</a><br/>".arg(obj[i].src)
            break;
        case 4: res += "<a href=\"at:%1\">%2</a>".arg(obj[i].uid).arg(obj[i].text); break
        case 5: res += "<a href=\"video:%1\" >点击链接查看视频</a>".arg(obj[i].text); break
        }
    }
    return res
}

function formatDateTime(milisec){
    var mydate = new Date(milisec)
    if (mydate.toDateString()==new Date().toDateString())
        return Qt.formatTime(mydate, "hh:mm:ss")
    else
        return Qt.formatDate(mydate, "yyyy-MM-dd")
}

function randomString(){
    var res = Qt.md5(Math.random())+Qt.md5(Math.random())
    return res.slice(0, 45)
}

function adjustCustomEmotion(content){
    var el = getCustomEmo()
    function change(emo){
        var name = emo.substring(2)
        for (var i in el){
            if (el[i].name == name)
                return "#("+el[i].imageinfo
        }
        return emo
    }
    return content.replace(/#\([^)]*/g, change)
}
