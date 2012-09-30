import QtQuick 1.1

QtObject {
    signal swipeLeft
    signal swipeRight

    signal loadStarted
    signal loadFinished
    signal loadFailed(string errorString)

    signal uploadStarted
    signal uploadFailed(string errorString)
    signal uploadFinished(string caller, variant info)

    signal needVCode(string caller, string picurl, string vcodeMd5)
    signal vcodeSent(string caller, string vcode, string vcodeMd5)

    signal loginStarted (string caller)
    signal loginSuccessed (string caller, string id, string name, string BDUSS)
    signal loginFailed (string caller, string errorString)

    signal getMyBarListStarted
    signal getMyBarListSuccessed(string result, bool cached)
    signal getMyBarListFailed(string errorString)

    signal getForumSuggestStarted
    signal getForumSuggestSuccessed
    signal getForumSuggestFailed(string errorString)

    signal loadForumStarted(string caller)
    signal loadForumSuccessed(string caller, variant forum, variant page, string forbidInfo)
    signal loadForumFailed(string caller, string errorString)

    signal loadThreadStarted(string caller)
    signal loadThreadFailed(string caller, string errorString)
    signal loadThreadSuccessed(string caller)

    signal postReplyStarted(string caller)
    signal postReplyFailed(string caller, string errorString)
    signal postReplySuccessed(string caller)

    signal getFriendListStarted(string caller)
    signal getFriendListFailed(string caller, string errorString)
    signal getFriendListSuccessed(string caller, variant page)

    signal getSubfloorListStarted(string caller)
    signal getSubfloorListFailed(string caller, string errorString)
    signal getSubfloorListSuccessed(string caller, bool isRenew)

    signal getReplyListStarted
    signal getReplyListFailed(string errorString)
    signal getReplyListSuccessed(string result, variant page, bool cached)

    signal getAtListStarted
    signal getAtListFailed(string errorString)
    signal getAtListSuccessed(string result, variant page, bool cached)

    signal dingStarted(string caller)
    signal dingFailed(string caller, string errorString)
    signal dingSuccessed(string caller)

    signal getMessageStarted
    signal getMessageFailed(string errorString)
    signal getMessageSuccessed(string msg, string type)

    signal getProfileStarted(string caller)
    signal getProfileFailed(string caller, string errorString)
    signal getProfileSuccessed(string caller)

    signal concernStarted(string caller)
    signal concernFailed(string caller, string errorString)
    signal concernSuccessed(string caller)

    signal signInStarted(string caller)
    signal signInFailed(string caller, string errorString)
    signal signInSuccessed(string caller, variant info)

    signal likeForumFailed(string caller, string errorString)
    signal likeForumSuccessed(string caller)

    signal getRecommendPicFailed(string errorString)
    signal getRecommendPicSuccessed(variant list)

    signal postArticleStarted(string caller)
    signal postArticleFailed(string caller, string errorString)
    signal postArticleSuccessed(string caller)

    signal postImage(string caller, string url)
    signal emotionSelected(string caller, string name)
    signal imageSelected(string caller, string url)
    signal friendSelected(string caller, string name)
    signal linkActivated(string link)

    signal currentUserChanged
}
