.pragma library

var signalCenter;
var tbsettings;

var userId = "", userName = "", BDUSS = ""
var tbs = ""

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
        pn: pageNumber, st_type: "tb_forumlist"
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
        for (var i in obj.thread_list)
            param[0].append(obj.thread_list[i])
        signalCenter.loadForumSuccessed(param[2], obj.forum, obj.page, obj.anti.forbid_info)
    }
}

function getThreadList(page, postId, isBack, isLast, isMark, from, isRenew){
    signalCenter.loadThreadStarted(page.toString())
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, back: isBack?1:0, ctime: new Date().getTime(),
        from: tbsettings.from, kz: page.threadId, last: isLast?1:0, lz: page.isLz?1:0, mark: isMark?1:0,
        net_type: tbsettings.netType, pid: postId||0, r: page.isReverse?1:0, rn: isMark&&!from?1:60,
        st_type: from||"tb_frslist"
    }
    var param = {
        page: page, isBack: isBack, isRenew: isRenew
    }
    sendWebRequest("POST", tbsettings.host+"/c/f/pb/page", loadThreadList, stringify(obj), param)
}
function loadThreadList(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code!=0){
        signalCenter.loadThreadFailed(param.page.toString(), obj.error_msg)
    } else {
        tbs = obj.anti.tbs
        var p = param.page
        p.hasFloor = obj.has_floor == 1
        p.forum = obj.forum
        p.thread = obj.thread

        if (param.isBack){
            if (param.isRenew){
                p.hasMore = obj.page.has_more == 1
                p.listModel.clear()
            } else
                p.hasMore = p.hasMore && obj.page.has_more == 1
            p.hasPrev = obj.page.has_prev == 1
            for (var i in obj.post_list){
                var t = obj.post_list[i]
                t.contentData = decodeThreadContentList(t.content)
                p.listModel.insert(i, {"data":t})
            }
        } else {
            if (param.isRenew){
                p.hasPrev = obj.page.has_prev == 1
                p.listModel.clear()
            } else
                p.hasPrev = p.hasPrev && obj.page.has_prev == 1
            p.hasMore = obj.page.has_more == 1

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

function getSubFloorList(caller, threadId, postId, subpostId, pageNumber, subpostModel, isRenew){
    signalCenter.getSubfloorListStarted(caller.toString())
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientType, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, kz: threadId, net_type: tbsettings.netType
    }
    if (postId || false){
        obj.pid = postId
        obj.pn = pageNumber
    } else {
        obj.spid = subpostId
    }
    if (isRenew) subpostModel.clear()
    sendWebRequest("POST", tbsettings.host+"/c/f/pb/floor", loadSubfloorList, stringify(obj), [caller, subpostModel, isRenew])
}

function loadSubfloorList(oritxt, param){
    var obj = JSON.parse(oritxt)
    if (obj.error_code != 0){
        signalCenter.getSubfloorListFailed(param[0].toString())
    } else {
        param[0].forum = obj.forum
        param[0].thread = obj.thread
        obj.post.contentString = decodeThreadContent(obj.post.content)
        param[0].post = obj.post
        tbs = obj.anti.tbs
        param[0].page = obj.page
        param[0].postId = obj.post.id
        param[0].pageNumber = obj.page.current_page || 1

        for (var i in obj.subpost_list){
            var t = obj.subpost_list[i]
            t.contentString = decodeThreadContent(t.content)
            param[1].append(t)
        }

        signalCenter.getSubfloorListSuccessed(param[0].toString(), param[2])
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
        var msg = "", type = ""
        if (obj.message.fans > 0 && tbsettings.remindNewFans){
            msg += "\n"+obj.message.fans+"个新粉丝"; type = "fans"
        }
        if (obj.message.replyme > 0 && tbsettings.remindReplyToMe){
            msg += "\n"+obj.message.replyme+"个新回复"; type = "replyme"
        }
        if (obj.message.atme > 0 && tbsettings.remindAtMe){
            msg += "\n"+obj.message.atme+"处提到我"; type = "atme"
        }
        signalCenter.getMessageSuccessed(msg.replace("\n", ""), type)
    }
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

function concern(caller, isConcern){
    signalCenter.concernStarted(caller.toString())
    var obj = {
        BDUSS: BDUSS, _client_type: tbsettings.clientTpe, _client_version: tbsettings.clientVersion,
        _phone_imei: tbsettings.imei, from: tbsettings.from, net_type: tbsettings.netType, portrait: caller.user.portrait,
        tbs: tbs
    }
    var url = isConcern ? "/c/c/user/follow" : "/c/c/user/unfollow"
    sendWebRequest("POST", tbsettings.host+url, concernResult, stringify(obj), [caller, isConcern])
}
function concernResult(oritxt, param){
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

///////////////////////////////////////////////////////////////////////

function decodeThreadContentList(obj){
    var res = []
    var len = -1
    for (var i in obj){
        var o = obj[i]
        if (o.type == 3){
            res.push([false,o.src])
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
                var _txt = o.text.toLowerCase().replace(/i_f/,"write_face_")
                res[len][1] += "<img src=\"qrc:/pics/" + _txt + (/(b|t|w)_/.test(_txt)?".gif\"/>":".png\"/>")
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
            var _txt = obj[i].text.toLowerCase().replace(/i_f/,"write_face_")
            res += "<img src=\"qrc:/pics/" + _txt + (/(b|t|w)_/.test(_txt)?".gif\"/>":".png\"/>")
            break
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
    var t = new Date().getTime()
    var t2 = t + 1
    var res = Qt.md5(t)+Qt.md5(t2)
    return res.slice(0, 45)
}
