#include "tbsettings.h"
#include <QApplication>
#include <QDesktopServices>
#include <QSystemInfo>
#include <QSystemDeviceInfo>
#include <QDebug>
#include <QWebSettings>
#include <QUrl>

using namespace QtMobility;

TBSettings::TBSettings(QObject *parent) :
    QObject(parent),
    mSettings(0)
{
    QSystemInfo systemInfo;
    QString firmware = systemInfo.version(QSystemInfo::Firmware);
    mSplitScreenInput = firmware.split(".")[0].toInt() >= 113;

    QSystemDeviceInfo deviceInfo;
    mImei = deviceInfo.imei();
    mImei = mImei.replace("-", "");

    mClientVersion = "3.3.1";
    mSettings = new QSettings(this);
    load();
}

TBSettings::~TBSettings()
{
    save();
}

void TBSettings::load()
{
    if (mSettings){
        mUserId = mSettings->value("userId", "").toString();
        mClientId = mSettings->value("clientId", "").toString();
        mWhiteTheme = mSettings->value("whiteTheme", false).toBool();
        mShowImage = mSettings->value("showImage", true).toBool();
        mShowAvatar = mSettings->value("showAvatar", true).toBool();
        mFontSize = mSettings->value("fontSize", 0).toInt();
        mBackgroundImage = mSettings->value("backgroundImage", "").toString();
        mClientType = mSettings->value("clientType", 1).toInt();
        mShowAbstract = mSettings->value("showAbstract", true).toBool();
        mMaxThreadCount = mSettings->value("maxThreadCount", 4).toInt();
        mShareLocation = mSettings->value("shareLocation", false).toBool();
        mSignText = mSettings->value("signText", "").toString();
        mSavePath = mSettings->value("savePath", QDesktopServices::storageLocation(QDesktopServices::PicturesLocation)).toString();
        mRemindFrequency = mSettings->value("remind/frequency", 5).toInt();
        mRemindFans = mSettings->value("remind/fans", true).toBool();
        mRemindReplyme = mSettings->value("remind/replyme", true).toBool();
        mRemindAtme = mSettings->value("remind/atme", true).toBool();
        mRemindBackground = mSettings->value("remind/background", true).toBool();
        mViewPhoto = mSettings->value("viewPhoto", false).toBool();
        mDraftBox = mSettings->value("draftBox", "").toString();
    }
    setUserStyle();
}

void TBSettings::save()
{
    if (mSettings){
        mSettings->setValue("userId", mUserId);
        mSettings->setValue("clientId", mClientId);
        mSettings->setValue("whiteTheme", mWhiteTheme);
        mSettings->setValue("showAvatar", mShowAvatar);
        mSettings->setValue("showImage", mShowImage);
        mSettings->setValue("fontSize", mFontSize);
        mSettings->setValue("backgroundImage", mBackgroundImage);
        mSettings->setValue("clientType", mClientType);
        mSettings->setValue("showAbstract", mShowAbstract);
        mSettings->setValue("maxThreadCount", mMaxThreadCount);
        mSettings->setValue("shareLocation", mShareLocation);
        mSettings->setValue("signText", mSignText);
        mSettings->setValue("savePath", mSavePath);
        mSettings->setValue("remind/frequency", mRemindFrequency);
        mSettings->setValue("remind/fans", mRemindFans);
        mSettings->setValue("remind/replyme", mRemindReplyme);
        mSettings->setValue("remind/atme", mRemindAtme);
        mSettings->setValue("remind/background", mRemindBackground);
        mSettings->setValue("viewPhoto", mViewPhoto);
        mSettings->setValue("draftBox", mDraftBox);
    }
}


void TBSettings::clear()
{
    if (mSettings){
        mSettings->clear();
        load();
    }
}

QString TBSettings::appVersion() const
{
    return qApp->applicationVersion();
}

bool TBSettings::splitScreenInput() const
{
    return mSplitScreenInput;
}

QString TBSettings::userId() const
{
    return mUserId;
}
void TBSettings::setUserId(const QString &userId)
{
    if (userId != mUserId){
        mUserId = userId;
        emit userIdChanged();
    }
}

QString TBSettings::clientId() const
{
    return mClientId;
}
void TBSettings::setClientId(const QString &clientId)
{
    if (clientId != mClientId){
        mClientId = clientId;
        emit clientIdChanged();
    }
}

bool TBSettings::whiteTheme() const
{
    return mWhiteTheme;
}
void TBSettings::setWhiteTheme(const bool &whiteTheme)
{
    if (whiteTheme != mWhiteTheme){
        mWhiteTheme = whiteTheme;
        setUserStyle();
        emit whiteThemeChanged();
    }
}

bool TBSettings::showImage() const
{
    return mShowImage;
}
void TBSettings::setShowImage(const bool &showImage)
{
    if (mShowImage != showImage){
        mShowImage = showImage;
        emit showImageChanged();
    }
}

bool TBSettings::showAvatar() const
{
    return mShowAvatar;
}
void TBSettings::setShowAvatar(const bool &showAvatar)
{
    if (mShowAvatar != showAvatar){
        mShowAvatar = showAvatar;
        emit showAvatarChanged();
    }
}

int TBSettings::fontSize() const
{
    return mFontSize;
}
void TBSettings::setFontSize(const int &fontSize)
{
    if (mFontSize != fontSize){
        mFontSize = fontSize;
        emit fontSizeChanged();
    }
}

QString TBSettings::backgroundImage() const
{
    return mBackgroundImage;
}
void TBSettings::setBackgroundImage(const QString &backgroundImage)
{
    if (mBackgroundImage != backgroundImage){
        mBackgroundImage = backgroundImage;
        emit backgroundImageChanged();
    }
}

int TBSettings::clientType() const
{
    return mClientType;
}
void TBSettings::setClientType(const int &clientType)
{
    if (mClientType != clientType){
        mClientType = clientType;
        emit clientTypeChanged();
    }
}

QString TBSettings::clientVersion() const
{
    return mClientVersion;
}

QString TBSettings::imei() const
{
    return mImei;
}

bool TBSettings::showAbstract() const
{
    return mShowAbstract;
}
void TBSettings::setShowAbstract(const bool &showAbstract)
{
    if (mShowAbstract != showAbstract){
        mShowAbstract = showAbstract;
        emit showAbstractChanged();
    }
}

int TBSettings::maxThreadCount() const
{
    return mMaxThreadCount;
}
void TBSettings::setMaxThreadCount(const int &maxThreadCount)
{
    if (mMaxThreadCount!=maxThreadCount){
        mMaxThreadCount = maxThreadCount;
        emit maxThreadCountChanged();
    }
}

bool TBSettings::shareLocation() const
{
    return mShareLocation;
}
void TBSettings::setShareLocation(const bool &shareLocation)
{
    if (mShareLocation != shareLocation){
        mShareLocation = shareLocation;
        emit shareLocationChanged();
    }
}

QString TBSettings::signText() const
{
    return mSignText;
}
void TBSettings::setSignText(const QString &signText)
{
    if (mSignText != signText){
        mSignText = signText;
        emit signTextChanged();
    }
}

QString TBSettings::savePath() const
{
    return mSavePath;
}
void TBSettings::setSavePath(const QString &savePath)
{
    if (mSavePath != savePath){
        mSavePath = savePath;
        emit savePathChanged();
    }
}

void TBSettings::setUserStyle()
{
#ifdef Q_OS_HARMATTAN
    if (mWhiteTheme){
        QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("/opt/"+qAppName()+"/qml/js/default_theme.css"));
    } else {
        QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("/opt/"+qAppName()+"/qml/js/night_theme.css"));
    }
#else
    if (mWhiteTheme){
        QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("qml/js/default_theme.css"));
    } else {
        QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("qml/js/night_theme.css"));
    }
#endif
}


int TBSettings::remindFrequency() const
{
    return mRemindFrequency;
}
void TBSettings::setRemindFrequency(const int &remindFrequency)
{
    if (mRemindFrequency != remindFrequency){
        mRemindFrequency = remindFrequency;
        emit remindFrequencyChanged();
    }
}

bool TBSettings::remindFans() const
{
    return mRemindFans;
}
void TBSettings::setRemindFans(const bool &remindFans)
{
    if (mRemindFans != remindFans){
        mRemindFans = remindFans;
        emit remindFansChanged();
    }
}

bool TBSettings::remindReplyme() const
{
    return mRemindReplyme;
}
void TBSettings::setRemindReplyme(const bool &remindReplyme)
{
    if (mRemindReplyme != remindReplyme){
        mRemindReplyme = remindReplyme;
        emit remindReplymeChanged();
    }
}

bool TBSettings::remindAtme() const
{
    return mRemindAtme;
}
void TBSettings::setRemindAtme(const bool &remindAtme)
{
    if (mRemindAtme != remindAtme){
        mRemindAtme = remindAtme;
        emit remindAtmeChanged();
    }
}

bool TBSettings::remindBackground() const
{
    return mRemindBackground;
}
void TBSettings::setRemindBackground(const bool &remindBackground)
{
    if (mRemindBackground != remindBackground){
        mRemindBackground = remindBackground;
        emit remindBackgroundChanged();
    }
}

bool TBSettings::viewPhoto() const
{
    return mViewPhoto;
}
void TBSettings::setViewPhoto(const bool &viewPhoto)
{
    mViewPhoto = viewPhoto;
}

QString TBSettings::draftBox() const
{
    return mDraftBox;
}
void TBSettings::setDraftBox(const QString &draftBox)
{
    mDraftBox = draftBox;
}
