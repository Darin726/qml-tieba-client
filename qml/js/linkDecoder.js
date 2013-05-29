function linkActivated(link){
    var l = link.split(":");
    switch (l[0]){
    case "at": {
        if (l[1]!=0){
            var p = pageStack.push(Qt.resolvedUrl("UserPage.qml"), { uid: l[1] });
            p.getlist();
        }
        break;
    }
    case "link": {
        var url = link.slice(link.indexOf(":")+1);
        var m;

        m = url.match(/(?:tieba|wapp).baidu.com\/(p\/|f\?.*z=|.*m\?kz=)(\d+)/);
        if (m) return enterThread({"threadId": m[2]});

        m = url.match(/c.tieba.baidu.com\/f\?.*kw=(.+)/);
        if (m) return enterForum(m[1]);

        m = url.match(/tieba.baidu.com\/f\?.*kw=(.+?)[&#]/);
        if (m) return enterForum(decodeForumName(m[1]));

        m = url.match(/tieba.baidu.com\/f\?.*kw=(.+)/);
        if (m) return enterForum(decodeForumName(m[1]));

        utility.openURLDefault(url);
        break;
    }
    case "img": {
        loadImage(link.slice(link.indexOf(":")+1));
        break;
    }
    case "video": {
        loadVideo(link.slice(link.indexOf(":")+1));
        break;
    }
    }
}

function decodeForumName(oristring){
    var i = 0, res = ""
    while (i<oristring.length){
        if ( oristring.charAt(i)!="%" || i+2>oristring.length ){
            res += oristring.charCodeAt(i).toString(16);
            i ++;
        } else {
            res += oristring.charAt(i+1) + oristring.charAt(i+2);
            i += 3;
        }
    }
    return utility.decodeGBKHex(res);
}

function loadImage(url){
    pageStack.push(Qt.resolvedUrl("ImagePage.qml"), { imageUrl: url });
}

function loadVideo(url){
    var v;
    v = url.match(/youku.*v_show\/id_(.+)\./) || url.match(/youku.*\/sid\/(.+)\//);
    if (v){
        getYoukuSource(v[1], "3gphd")
        return
    }
    v = url.match(/56\.com.*\/v_(.+)\./)
    if (v){
        get56Source(url, v[1])
        return
    }
    v = url.match(/yinyuetai.*\/player\/(.+)\//)
    if (v){
        getYinyuetaiSource(url, v[1])
        return
    }

    v = url.match(/video\.sina\..*vid=(\d+)_\d+/) || url.match(/video\.sina\..*v\/b\/(\d+)-\d+/)
    if (v){
        getSinaSource(url, v[1])
        return
    }
    utility.openURLDefault(url)
}

function getYoukuSource(sid, type){
    signalCenter.showMessage(qsTr("Requesting Video Source..."));
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function(){
                switch (doc.readyState){
                case doc.HEADERS_RECEIVED: {
                    if (doc.status != 200){
                        signalCenter.showMessage(qsTr("Cannot Open Video"));
                    }
                    break;
                }
                case doc.LOADING: {
                    if (doc.status == 200){
                        if (!/text/.test(doc.getResponseHeader("content-type"))){
                            doc.abort();
                            utility.launchPlayer("http://m.youku.com/pvs?id="+sid+"&format="+type);
                        }
                    }
                    break;
                }
                case doc.DONE: {
                    if (doc.status == 200){
                        if (type == "3gphd")
                            getYoukuSource(sid, "3gp");
                        else
                            signalCenter.showMessage(doc.responseText);
                    }
                    break;
                }
                }
            }
    doc.open("GET", "http://m.youku.com/pvs?id="+sid+"&format="+type);
    doc.send();
}

function get56Source(url, seed){
    signalCenter.showMessage(qsTr("Requesting Video Source..."));
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function(){
                switch(doc.readyState){
                case doc.HEADERS_RECEIVED: {
                    if (doc.status != 200)
                        utility.openURLDefault(url);
                    break;
                }
                case doc.DONE: {
                    if (doc.status == 200){
                        try {
                            var f = JSON.parse(doc.responseText).info.rfiles;
                            for (var i in f){
                                var u = f[i].url;
                                if (u.split(".").pop() == "mp4"){
                                    utility.launchPlayer(u);
                                    return;
                                }
                            }
                            if (f) utility.openURLDefault(url);
                        } catch(e){
                            utility.openURLDefault(url);
                        }
                    }
                    break;
                }
                }
            }
    doc.open("GET", "http://vxml.56.com/json/%1/?src=out".arg(seed));
    doc.send();
}

function getYinyuetaiSource(url, seed){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function(){
                if (doc.readyState == doc.HEADERS_RECEIVED){
                    if (doc.status != 200)
                        utility.openURLDefault(url);
                } else if (doc.readyState == doc.DONE){
                    if (doc.status == 200){
                        var s = doc.responseText.match(/http:\/\/[^:]*\.(flv|mp4|f4v|hlv)\?(t|sc)=[a-z0-9]*/g);
                        if (s)
                            utility.openURLDefault(s[0]);
                        else
                            utility.openURLDefault(url);
                    }
                }
            }
    doc.open("GET", "http://www.yinyuetai.com/explayer/get-video-info?videoId="+seed+"&flex=true&platform=null");
    doc.send();
}

function getSinaSource(url, seed){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function(){
                if (doc.readyState == doc.HEADERS_RECEIVED){
                    if (doc.status != 200){
                        utility.openURLDefault(url);
                    }
                } else if (doc.readyState == doc.DONE){
                    if (doc.status == 200){
                        var d = JSON.parse(doc.responseText).ipad_vid;
                        if (d != 0){
                            utility.launchPlayer("http://v.iask.com/v_play_ipad.php?vid="+d);
                        } else
                            utility.openURLDefault(url);
                    }
                }
            }
    doc.open("GET", "http://video.sina.com.cn/interface/video_ids/video_ids.php?v="+seed);
    doc.send();
}
