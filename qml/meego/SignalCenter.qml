import QtQuick 1.1

QtObject {
    signal showMessage(string message);
    signal needAuthorization(bool forceLogin);
    signal linkActivated(string link);

    signal needVCode(string caller, string vcodePicUrl, string vcodeMd5);
    signal vcodeSent(string caller, string vcode, string vcodeMd5);

    signal userChanged;

    signal loadStarted;
    signal loadFinished;
    signal loadFailed(string errorString);

    signal showBusyIndicator;
    signal hideBusyIndicator;

    signal loginStarted;
    signal loginFinished;
    signal loginFailed;

    signal getFavoriteTiebaStarted;
    signal getFavoriteTiebaFinished(variant forumList, double time);

    signal getForumSuggestStarted;
    signal getForumSuggestFinished(variant fname);

    signal searchPostStarted;
    signal searchPostFinished(variant postList, variant page);

    signal getThreadListStarted(string caller);
    signal getThreadListFinished(string caller);

    signal getPostListStarted(string caller);
    signal getPostListFinished(string caller);

    signal getFloorListStarted(string caller);
    signal getFloorListFinished(string caller);

    signal getReplyMeStarted;
    signal getReplyMeFinished;

    signal getAtMeStarted;
    signal getAtMeFinished;

    signal getUserProfileStarted(string caller);
    signal getUserProfileFinished(string caller);

    signal getTimelineStarted(string caller);
    signal getTimelineFinished(string caller, variant list);

    signal postStarted(string caller);
    signal postFinished(string caller, string type);
    signal postFailed(string caller);

    signal getForumListStarted(string caller);
    signal getForumListFinished(string caller);

    signal getFriendListStarted(string caller);
    signal getFriendListFinished(string caller);

    signal getFriendSuggestStarted(string caller);
    signal getFriendSuggestFinished(string caller);

    signal getHotFeedStarted;
    signal getHotFeedFinished;

    signal uploadFinished(string caller, variant info);
    signal postImage(string caller, string url);
    signal imageSelected(string caller, string url);
    signal emotionSelected(string caller, string name);
    signal friendSelected(string caller, string name);

    signal commitGood(variant catelist, variant param);
    signal threadDeleted(string caller);
    signal postDeleted(string caller, string pid);
    signal followFinished(string caller, bool isfollow);
    signal messageReceived(int fans, int replyme, int atme);
}
