import QtQuick 1.1
import com.nokia.symbian 1.1
import "../Component"
import "../../js/main.js" as Script

CommonDialog {
    id: root;

    titleText: qsTr("Tieba Infomation");

    content: Item {
        width: platformContentMaximumWidth;
        height: Math.min(platformContentMaximumHeight, contentCol.height);

        Flickable {
            anchors.fill: parent;
            clip: true;
            contentWidth: parent.width;
            contentHeight: contentCol.height;
            Column {
                id: contentCol;
                width: parent.width;
                DetailItem {
                    title: qsTr("Forum Name");
                    subTitle: forum.name;
                }
                DetailItem {
                    title: qsTr("Forum Class");
                    visible: forum.hasOwnProperty("first_class");
                    subTitle: {
                        if (forum.first_class == ""){
                            return qsTr("(None)");
                        } else if (forum.second_class == ""){
                            return forum.first_class;
                        } else {
                            return forum.first_class + "-" + forum.second_class;
                        }
                    }
                }
                DetailItem {
                    title: qsTr("Members")
                    subTitle: forum.member_num;
                }
                DetailItem {
                    title: qsTr("Thread");
                    visible: forum.hasOwnProperty("thread_num");
                    subTitle: visible ? forum.thread_num : "";
                }
                DetailItem {
                    title: qsTr("Post");
                    visible: forum.hasOwnProperty("post_num");
                    subTitle: visible ? forum.post_num : "";
                }
                DetailItem {
                    enabled: true;
                    title: qsTr("Is Like");
                    subTitle: forum.is_like == 1 ? qsTr("Yes(Click To Cancel)") : qsTr("No(Click To Like)");
                    onClicked: {
                        close();
                        var opt = {
                            fid: forum.id,
                            kw: forum.name,
                            islike: forum.is_like==1?false:true
                        }
                        Script.likeForum(opt);
                    }
                }
                DetailItem {
                    title: qsTr("Level");
                    subTitle: " Lv." + forum.level_id+"  "+forum.level_name;
                }
                DetailItem {
                    title: qsTr("Score");
                    visible: forum.hasOwnProperty("cur_score");
                    subTitle: visible ? forum.cur_score + "/" + forum.levelup_score : "";
                }
                Loader {
                    width: parent.width;
                    sourceComponent: forum.sign_in_info.forum_info.is_on==1 ? signColComp : undefined;
                    Component {
                        id: signColComp;
                        Column {
                            DetailItem {
                                enabled: forum.sign_in_info.user_info.is_sign_in == 0;
                                title: qsTr("Signed");
                                subTitle: enabled?qsTr("No(Click To Sign)"):qsTr("Yes.Rank:")+forum.sign_in_info.user_info.user_sign_rank;
                                onClicked: {
                                    close();
                                    var opt = { fid: forum.id, kw: forum.name };
                                    Script.sign(opt);
                                }
                            }
                            DetailItem {
                                title: qsTr("Sign Days");
                                subTitle: qsTr("Continuous: %1, Total: %2").arg(String(forum.sign_in_info.user_info.cont_sign_num)).arg(String(forum.sign_in_info.user_info.cout_total_sing_num))
                            }
                            DetailItem {
                                title: qsTr("Signed Count");
                                subTitle: {
                                    var info = forum.sign_in_info.forum_info.current_rank_info;
                                    return info.sign_count+"  ("+Math.floor(info.sign_count/info.member_count*100)+"%)";
                                }
                            }
                            DetailItem {
                                title: qsTr("Current Rank");
                                subTitle: {
                                    var info = forum.sign_in_info.forum_info.current_rank_info
                                    return info.sign_rank /*+qsTr("  (Beat%1%Forums)").arg(100-info.dir_rate)*/;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    onClickedOutside: close();
}
