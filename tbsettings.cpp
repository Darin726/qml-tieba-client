#include "tbsettings.h"

#include <QApplication>
#include <QSettings>
#include <QDesktopServices>
#include <QSystemDeviceInfo>
#include <QSystemInfo>
#include <QDebug>

using namespace QtMobility;

TBSettings::TBSettings(QObject *parent) :
    QObject(parent),
    m_settings(NULL)
{
    m_settings = new QSettings(QSettings::IniFormat,
                               QSettings::UserScope,
                               "Yeatse",
                               "TBClient",
                               this);
    loadSettings();
}

TBSettings::~TBSettings()
{
    saveSettings();
}

void TBSettings::loadSettings()
{
    qDebug()<<"Loading settings...";
    if (m_settings){
        m_remindFrequency = m_settings->value("remindFrequency", 5*60*1000).toInt();
        m_showImage = m_settings->value("showImage", false).toBool();
        m_showAvatar = m_settings->value("showAvatar", true).toBool();
        m_whiteTheme = m_settings->value("whiteTheme", false).toBool();
        m_backgroundImage = m_settings->value("backgroundImage", "").toUrl();
        m_fontSize = m_settings->value("fontSize", 20).toInt();
        m_clientType = m_settings->value("clientType", 1).toInt();
        m_maxThreadCount = m_settings->value("maxThreadCount", 5).toInt();
        m_defaultId = m_settings->value("defaultId","").toString();
        m_openWithSystem = m_settings->value("openWithSystem", false).toBool();
        m_imagePath = m_settings->value("imagePath",
                                        QDesktopServices::storageLocation(QDesktopServices::PicturesLocation)).toString();
        m_remindNewFans = m_settings->value("remindNewFans", true).toBool();
        m_remindReplyToMe = m_settings->value("remindReplyToMe", true).toBool();
        m_remindAtMe = m_settings->value("remindAtMe", true).toBool();
        m_signText = m_settings->value("signText", "").toString();
//        m_imageQuality = m_settings->value("imageQuality", 1).toInt();
        m_showAbstract = m_settings->value("showAbstract", false).toBool();

        m_appVersion = qApp->applicationVersion().replace("\"","");
        m_host = "http://c.tieba.baidu.com";
        m_clientVersion = "2.5.0";
        m_from = "tieba";
        m_netType = "1";

        QSystemDeviceInfo deviceInfo;
        m_imei = deviceInfo.imei();
        m_imei = m_imei.replace("-","");
        QSystemInfo systemInfo;
        m_splitScreenInput = systemInfo.version(QSystemInfo::Firmware).split(".")[0].toInt() >= 113;
    }
}

void TBSettings::saveSettings()
{
    qDebug()<<"Saving settings...";
    if (m_settings){
        m_settings->setValue("remindFrequency", m_remindFrequency);
        m_settings->setValue("showImage", m_showImage);
        m_settings->setValue("showAvatar", m_showAvatar);
        m_settings->setValue("whiteTheme", m_whiteTheme);
        m_settings->setValue("backgroundImage", m_backgroundImage);
        m_settings->setValue("fontSize", m_fontSize);
        m_settings->setValue("clientType", m_clientType);
        m_settings->setValue("maxThreadCount", m_maxThreadCount);
        m_settings->setValue("defaultId", m_defaultId);
        m_settings->setValue("openWithSystem", m_openWithSystem);
        m_settings->setValue("imagePath", m_imagePath);
        m_settings->setValue("splitScreenInput", m_splitScreenInput);
        m_settings->setValue("remindNewFans", m_remindNewFans);
        m_settings->setValue("remindReplyToMe", m_remindReplyToMe);
        m_settings->setValue("remindAtMe", m_remindAtMe);
        m_settings->setValue("signText", m_signText);
        m_settings->setValue("showAbstract", m_showAbstract);
//        m_settings->setValue("imageQuality", m_imageQuality);
    }
}

void TBSettings::clear()
{
    if(m_settings){
        m_settings->clear();
    }
}

int TBSettings::remindFrequency() const
{
    return m_remindFrequency;
}
void TBSettings::setRemindFrequency(const int &remindFrequency)
{
    if (m_remindFrequency!=remindFrequency){
        m_remindFrequency = remindFrequency;
        emit remindFrequencyChanged();
    }
}

bool TBSettings::showImage() const
{
    return m_showImage;
}
void TBSettings::setShowImage(const bool &showImage)
{
    if (m_showImage!=showImage){
        m_showImage = showImage;
        emit showImageChanged();
    }
}

bool TBSettings::showAvatar() const
{
    return m_showAvatar;
}

void TBSettings::setShowAvatar(const bool &showAvatar)
{
    if (m_showAvatar!=showAvatar){
        m_showAvatar = showAvatar;
        emit showAvatarChanged();
    }
}

bool TBSettings::whiteTheme() const
{
    return m_whiteTheme;
}
void TBSettings::setWhiteTheme(const bool &whiteTheme)
{
    if (m_whiteTheme!=whiteTheme){
        m_whiteTheme = whiteTheme;
        emit whiteThemeChanged();
    }
}

QUrl TBSettings::backgroundImage() const
{
    return m_backgroundImage;
}
void TBSettings::setBackgroundImage(const QUrl &backgroundImage)
{
    if (m_backgroundImage!=backgroundImage){
        m_backgroundImage = backgroundImage;
        emit backgroundImageChanged();
    }
}

int TBSettings::fontSize() const
{
    return m_fontSize;
}
void TBSettings::setFontSize(const int &fontSize)
{
    if (m_fontSize!=fontSize){
        m_fontSize = fontSize;
        emit fontSizeChanged();
    }
}

int TBSettings::clientType() const
{
    return m_clientType;
}
void TBSettings::setClientType(const int &clientType)
{
    if (m_clientType!=clientType){
        m_clientType = clientType;
        emit clientTypeChanged();
    }
}

int TBSettings::maxThreadCount() const
{
    return m_maxThreadCount;
}
void TBSettings::setMaxThreadCount(const int &maxThreadCount)
{
    if (m_maxThreadCount!=maxThreadCount){
        m_maxThreadCount = maxThreadCount;
        emit maxThreadCountChanged();
    }
}

QString TBSettings::defaultId() const
{
    return m_defaultId;
}
void TBSettings::setDefaultId(const QString &defaultId)
{
    if(m_defaultId!=defaultId){
        m_defaultId = defaultId;
        emit defaultIdChanged();
    }
}

bool TBSettings::openWithSystem() const
{
    return m_openWithSystem;
}
void TBSettings::setOpenWithSystem(const bool &openWithSystem)
{
    if (m_openWithSystem!=openWithSystem){
        m_openWithSystem = openWithSystem;
        emit openWithSystemChanged();
    }
}

QString TBSettings::imagePath() const
{
    return m_imagePath;
}
void TBSettings::setImagePath(const QString &imagePath)
{
    if (m_imagePath != imagePath){
        m_imagePath = imagePath;
        emit imagePathChanged();
    }
}
void TBSettings::resetImagePath()
{
    setImagePath(QDesktopServices::storageLocation(QDesktopServices::QDesktopServices::PicturesLocation));
}

bool TBSettings::splitScreenInput() const
{
    return m_splitScreenInput;
}
void TBSettings::setSplitScreenInput(const bool &splitScreenInput)
{
    if (m_splitScreenInput != splitScreenInput){
        m_splitScreenInput = splitScreenInput;
        emit splitScreenInputChanged();
    }
}

bool TBSettings::remindNewFans() const
{
    return m_remindNewFans;
}
void TBSettings::setRemindNewFans(const bool &remindNewFans)
{
    if (m_remindNewFans != remindNewFans){
        m_remindNewFans = remindNewFans;
        emit remindNewFansChanged();
    }
}

bool TBSettings::remindReplyToMe() const
{
    return m_remindReplyToMe;
}
void TBSettings::setRemindReplyToMe(const bool &remindReplyToMe)
{
    if (m_remindReplyToMe != remindReplyToMe){
        m_remindReplyToMe = remindReplyToMe;
        emit remindReplyToMeChanged();
    }
}

bool TBSettings::remindAtMe() const
{
    return m_remindAtMe;
}
void TBSettings::setRemindAtMe(const bool &remindAtMe)
{
    if (m_remindAtMe != remindAtMe){
        m_remindAtMe = remindAtMe;
        emit remindAtMeChanged();
    }
}

QString TBSettings::signText() const
{
    return m_signText;
}
void TBSettings::setSignText(const QString &signText)
{
    if (m_signText != signText){
        m_signText = signText;
        emit signTextChanged();
    }
}

bool TBSettings::showAbstract() const
{
    return m_showAbstract;
}
void TBSettings::setShowAbstract(const bool &showAbstract)
{
    if (m_showAbstract != showAbstract){
        m_showAbstract = showAbstract;
        emit showAbstractChanged();
    }
}

/*
int TBSettings::imageQuality() const
{
    return m_imageQuality;
}
void TBSettings::setImageQuality(const int &imageQuality)
{
    if (m_imageQuality != imageQuality){
        m_imageQuality = imageQuality;
        emit imageQualityChanged();
    }
}
*/

QString TBSettings::appVersion() const
{
    return m_appVersion;
}

QString TBSettings::host() const
{
    return m_host;
}

QString TBSettings::clientVersion() const
{
    return m_clientVersion;
}
QString TBSettings::from() const
{
    return m_from;
}
QString TBSettings::imei() const
{
    return m_imei;
}
QString TBSettings::netType() const
{
    return m_netType;
}
