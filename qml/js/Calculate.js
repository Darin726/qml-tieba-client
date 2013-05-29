.pragma library
/*
* Javascript Humane Dates
* Copyright (c) 2008 Dean Landolt (deanlandolt.com)
* Re-write by Zach Leatherman (zachleat.com)
*
* Adopted from the John Resig's pretty.js
* at http://ejohn.org/blog/javascript-pretty-date
* and henrah's proposed modification
* at http://ejohn.org/blog/javascript-pretty-date/#comment-297458
*
* Licensed under the MIT license.
*/
function humaneDate(date, compareTo){
    var lang = {
            ago: qsTr('ago'),
            from: qsTr('From Now'),
            now: qsTr('just now'),
            minute: qsTr('min'),
            minutes: qsTr('mins'),
            hour: qsTr('hr'),
            hours: qsTr('hrs'),
            day: qsTr('day'),
            days: qsTr('days'),
            week: qsTr('wk'),
            weeks: qsTr('wks'),
            month: qsTr('mth'),
            months: qsTr('mths'),
            year: qsTr('yr'),
            years: qsTr('yrs')
        },
        formats = [
            [60, lang.now],
            [3600, lang.minute, lang.minutes, 60], // 60 minutes, 1 minute
            [86400, lang.hour, lang.hours, 3600], // 24 hours, 1 hour
            [604800, lang.day, lang.days, 86400], // 7 days, 1 day
            [2628000, lang.week, lang.weeks, 604800], // ~1 month, 1 week
            [31536000, lang.month, lang.months, 2628000], // 1 year, ~1 month
            [Infinity, lang.year, lang.years, 31536000] // Infinity, 1 year
        ],
        date = new Date(date),
        compareTo = compareTo || new Date,
        seconds = (compareTo - date) / 1000,
        token;

    if(seconds < 0) {
        seconds = Math.abs(seconds);
        token = lang.from;
    } else {
        token = lang.ago;
    }

    /*
     * 0 seconds && < 60 seconds        Now
     * 60 seconds                       1 Minute
     * > 60 seconds && < 60 minutes     X Minutes
     * 60 minutes                       1 Hour
     * > 60 minutes && < 24 hours       X Hours
     * 24 hours                         1 Day
     * > 24 hours && < 7 days           X Days
     * 7 days                           1 Week
     * > 7 days && < ~ 1 Month          X Weeks
     * ~ 1 Month                        1 Month
     * > ~ 1 Month && < 1 Year          X Months
     * 1 Year                           1 Year
     * > 1 Year                         X Years
     *
     * Single units are +10%. 1 Year shows first at 1 Year + 10%
     */

    function normalize(val, single)
    {
        var margin = 0.1;
        if(val >= single && val <= single * (1+margin)) {
            return single;
        }
        return val;
    }

    for(var i = 0, format = formats[0]; formats[i]; format = formats[++i]) {
        if(seconds < format[0]) {
            if(i === 0) {
                // Now
                return format[1];
            }
            var val = Math.ceil(normalize(seconds, format[3]) / (format[3]));
            return qsTr('%1 %2 %3', 'e.g. %1 is number value such as 2, %2 is mins, %3 is ago').arg(val).arg(val != 1 ? format[2] : format[1]).arg(token);
        }
    }
}

function formatDateTime(milisec){
    var mydate = new Date(milisec)
    if (mydate.toDateString()==new Date().toDateString())
        return Qt.formatTime(mydate, "hh:mm:ss")
    else
        return Qt.formatDate(mydate, "yyyy-MM-dd")
}

function getAvatar(portrait){
    if (portrait){
        return "http://tb.himg.baidu.com/sys/portraitn/item/"+portrait;
    } else {
        return Qt.resolvedUrl("../gfx/photo.png");
    }
}

function getThumbnail(bigPic){
    var tbimg = bigPic.match(/http:\/\/imgsrc.baidu.com\/forum\/pic\/item\/(.*)/);
    if (tbimg){
        return "http://imgsrc.baidu.com/forum/abpic/item/"+tbimg[1];
    } else {
        return bigPic;
    }
}

function copyObject(oriObj){
    var result = new Object();
    for (var i in oriObj){
        result[i] = oriObj[i];
    }
    return result;
}

function extractContent(list){
    var res = "";
    list.forEach(function(value){
                     if (value.type == 3){ res += value.src;
                     } else { res += value.text; }
                 })
    return res;
}
