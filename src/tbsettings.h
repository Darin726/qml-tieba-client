#ifndef TBSETTINGS_H
#define TBSETTINGS_H

#include <QObject>
#include <QSettings>

class TBSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appVersion READ appVersion CONSTANT)
    Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString clientId READ clientId WRITE setClientId NOTIFY clientIdChanged)
    Q_PROPERTY(bool whiteTheme READ whiteTheme WRITE setWhiteTheme NOTIFY whiteThemeChanged)
    Q_PROPERTY(bool showImage READ showImage WRITE setShowImage NOTIFY showImageChanged)
    Q_PROPERTY(bool showAvatar READ showAvatar WRITE setShowAvatar NOTIFY showAvatarChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(QString backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)
    Q_PROPERTY(bool splitScreenInput READ splitScreenInput CONSTANT)
    Q_PROPERTY(int clientType READ clientType WRITE setClientType NOTIFY clientTypeChanged)
    Q_PROPERTY(QString clientVersion READ clientVersion CONSTANT)
    Q_PROPERTY(QString imei READ imei CONSTANT)
    Q_PROPERTY(bool showAbstract READ showAbstract WRITE setShowAbstract NOTIFY showAbstractChanged)
    Q_PROPERTY(int maxThreadCount READ maxThreadCount WRITE setMaxThreadCount NOTIFY maxThreadCountChanged)
    Q_PROPERTY(bool shareLocation READ shareLocation WRITE setShareLocation NOTIFY shareLocationChanged)
    Q_PROPERTY(QString signText READ signText WRITE setSignText NOTIFY signTextChanged)
    Q_PROPERTY(QString savePath READ savePath WRITE setSavePath NOTIFY savePathChanged)
    Q_PROPERTY(int remindFrequency READ remindFrequency WRITE setRemindFrequency NOTIFY remindFrequencyChanged)
    Q_PROPERTY(bool remindFans READ remindFans WRITE setRemindFans NOTIFY remindFansChanged)
    Q_PROPERTY(bool remindReplyme READ remindReplyme WRITE setRemindReplyme NOTIFY remindReplymeChanged)
    Q_PROPERTY(bool remindAtme READ remindAtme WRITE setRemindAtme NOTIFY remindAtmeChanged)
    Q_PROPERTY(bool remindBackground READ remindBackground WRITE setRemindBackground NOTIFY remindBackgroundChanged)
    Q_PROPERTY(bool viewPhoto READ viewPhoto WRITE setViewPhoto)
    Q_PROPERTY(QString draftBox READ draftBox WRITE setDraftBox)

public:
    explicit TBSettings(QObject *parent = 0);
    ~TBSettings();

    QString appVersion() const;

    QString userId() const;
    void setUserId(const QString &userId);

    QString clientId() const;
    void setClientId(const QString &clientId);

    bool whiteTheme() const;
    void setWhiteTheme(const bool &whiteTheme);

    bool showImage() const;
    void setShowImage(const bool &showImage);

    bool showAvatar() const;
    void setShowAvatar(const bool &showAvatar);

    int fontSize() const;
    void setFontSize(const int &fontSize);

    QString backgroundImage() const;
    void setBackgroundImage(const QString &backgroundImage);

    bool splitScreenInput() const;

    int clientType() const;
    void setClientType(const int &clientType);

    bool showAbstract() const;
    void setShowAbstract(const bool &showAbstract);

    int maxThreadCount() const;
    void setMaxThreadCount(const int &maxThreadCount);

    bool shareLocation() const;
    void setShareLocation(const bool &shareLocation);

    QString signText() const;
    void setSignText(const QString &signText);

    QString savePath() const;
    void setSavePath(const QString &savePath);

    int remindFrequency() const;
    void setRemindFrequency(const int &remindFrequency);

    bool remindFans() const;
    void setRemindFans(const bool &remindFans);

    bool remindReplyme() const;
    void setRemindReplyme(const bool &remindReplyme);

    bool remindAtme() const;
    void setRemindAtme(const bool &remindAtme);

    bool remindBackground() const;
    void setRemindBackground(const bool &remindBackground);

    bool viewPhoto() const;
    void setViewPhoto(const bool &viewPhoto);

    QString draftBox() const;
    void setDraftBox(const QString &draftBox);

    QString clientVersion() const;

    QString imei() const;

    Q_INVOKABLE void load();
    Q_INVOKABLE void save();
    Q_INVOKABLE void clear();

    void setUserStyle();

signals:
    void userIdChanged();
    void clientIdChanged();
    void whiteThemeChanged();
    void showImageChanged();
    void showAvatarChanged();
    void fontSizeChanged();
    void backgroundImageChanged();
    void clientTypeChanged();
    void showAbstractChanged();
    void maxThreadCountChanged();
    void shareLocationChanged();
    void signTextChanged();
    void savePathChanged();
    void remindFrequencyChanged();
    void remindFansChanged();
    void remindReplymeChanged();
    void remindAtmeChanged();
    void remindBackgroundChanged();

private:
    QSettings* mSettings;
    QString mUserId;
    QString mClientId;
    bool mWhiteTheme;
    bool mShowImage;
    bool mShowAvatar;
    int mFontSize;
    QString mBackgroundImage;
    int mClientType;
    QString mClientVersion;
    bool mSplitScreenInput;
    QString mImei;
    bool mShowAbstract;
    int mMaxThreadCount;
    bool mShareLocation;
    QString mSignText;
    QString mSavePath;
    int mRemindFrequency;
    bool mRemindFans;
    bool mRemindReplyme;
    bool mRemindAtme;
    bool mRemindBackground;
    bool mViewPhoto;
    QString mDraftBox;
};

#endif // TBSETTINGS_H
