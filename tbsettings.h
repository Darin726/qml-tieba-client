#ifndef TBSETTINGS_H
#define TBSETTINGS_H

#include <QObject>
#include <QUrl>

QT_BEGIN_NAMESPACE
class QSettings;
QT_END_NAMESPACE

class TBSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int remindFrequency READ remindFrequency WRITE setRemindFrequency NOTIFY remindFrequencyChanged)
    Q_PROPERTY(bool showImage READ showImage WRITE setShowImage NOTIFY showImageChanged)
    Q_PROPERTY(bool showAvatar READ showAvatar WRITE setShowAvatar NOTIFY showAvatarChanged)
    Q_PROPERTY(bool whiteTheme READ whiteTheme WRITE setWhiteTheme NOTIFY whiteThemeChanged)
    Q_PROPERTY(QUrl backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(int clientType READ clientType WRITE setClientType NOTIFY clientTypeChanged)
    Q_PROPERTY(int maxThreadCount READ maxThreadCount WRITE setMaxThreadCount NOTIFY maxThreadCountChanged)
    Q_PROPERTY(QString defaultId READ defaultId WRITE setDefaultId NOTIFY defaultIdChanged)
    Q_PROPERTY(bool openWithSystem READ openWithSystem WRITE setOpenWithSystem NOTIFY openWithSystemChanged )
    Q_PROPERTY(QString imagePath READ imagePath WRITE setImagePath NOTIFY imagePathChanged)
    Q_PROPERTY(bool splitScreenInput READ splitScreenInput WRITE setSplitScreenInput NOTIFY splitScreenInputChanged)
    Q_PROPERTY(bool remindNewFans READ remindNewFans WRITE setRemindNewFans NOTIFY remindNewFansChanged)
    Q_PROPERTY(bool remindReplyToMe READ remindReplyToMe WRITE setRemindReplyToMe NOTIFY remindReplyToMeChanged)
    Q_PROPERTY(bool remindAtMe READ remindAtMe WRITE setRemindAtMe NOTIFY remindAtMeChanged)
    Q_PROPERTY(QString signText READ signText WRITE setSignText NOTIFY signTextChanged)

    Q_PROPERTY(QString appVersion READ appVersion CONSTANT)
    Q_PROPERTY(QString host READ host)
    Q_PROPERTY(QString clientVersion READ clientVersion)
    Q_PROPERTY(QString from READ from)
    Q_PROPERTY(QString netType READ netType)
    Q_PROPERTY(QString imei READ imei)

public:
    explicit TBSettings(QObject *parent = 0);
    ~TBSettings();

    int remindFrequency() const;
    void setRemindFrequency(const int &remindFrequency);

    bool showImage() const;
    void setShowImage(const bool &showImage);

    bool showAvatar() const;
    void setShowAvatar(const bool &showAvatar);

    bool whiteTheme() const;
    void setWhiteTheme(const bool &whiteTheme);

    QUrl backgroundImage() const;
    void setBackgroundImage(const QUrl &backgroundImage);

    int fontSize() const;
    void setFontSize(const int &fontSize);

    int clientType() const;
    void setClientType(const int &clientType);

    int maxThreadCount() const;
    void setMaxThreadCount(const int &maxThreadCount);

    QString defaultId() const;
    void setDefaultId(const QString &defaultId);

    bool openWithSystem() const;
    void setOpenWithSystem(const bool &openWithSystem);

    QString imagePath() const;
    void setImagePath(const QString &imagePath);

    bool splitScreenInput() const;
    void setSplitScreenInput(const bool &splitScreenInput);

    bool remindNewFans() const;
    void setRemindNewFans(const bool &remindNewFans);

    bool remindReplyToMe() const;
    void setRemindReplyToMe(const bool &remindReplyToMe);

    bool remindAtMe() const;
    void setRemindAtMe(const bool &remindAtMe);

    QString signText() const;
    void setSignText(const QString &signText);

    QString host() const;
    QString clientVersion() const;
    QString from() const;
    QString netType() const;
    QString imei() const;

    QString appVersion() const;

signals:
    void remindFrequencyChanged();
    void showImageChanged();
    void showAvatarChanged();
    void whiteThemeChanged();
    void backgroundImageChanged();
    void fontSizeChanged();
    void clientTypeChanged();
    void maxThreadCountChanged();
    void defaultIdChanged();
    void openWithSystemChanged();
    void imagePathChanged();
    void splitScreenInputChanged();
    void remindNewFansChanged();
    void remindReplyToMeChanged();
    void remindAtMeChanged();
    void signTextChanged();

public slots:
    void saveSettings();
    void clear();
    void resetImagePath();

private:
    void loadSettings();

    QSettings *m_settings;
    int m_remindFrequency;
    bool m_showImage;
    bool m_showAvatar;
    bool m_whiteTheme;
    QUrl m_backgroundImage;
    int m_fontSize;
    int m_clientType;
    int m_maxThreadCount;
    QString m_defaultId;
    bool m_openWithSystem;
    bool m_splitScreenInput;
    bool m_remindNewFans;
    bool m_remindReplyToMe;
    bool m_remindAtMe;
    QString m_signText;

    QString m_appVersion;
    QString m_imagePath;
    QString m_host;
    QString m_clientVersion;
    QString m_from;
    QString m_netType;
    QString m_imei;
};

#endif // TBSETTINGS_H
