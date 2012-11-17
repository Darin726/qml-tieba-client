#include "utility.h"
#include <QTextCodec>
#include <QDir>
#include <QTextStream>
#include <QNetworkDiskCache>
#include <QNetworkAccessManager>
#include <QCoreApplication>

#ifdef Q_OS_SYMBIAN
#include <apgtask.h>
#include <apgcli.h>
#include <eikenv.h>
#include <mgfetch.h>
#endif

Utility::Utility(QDeclarativeEngine *engine, QObject *parent) :
    QObject(parent)
{
    this->m_engine = engine;
}

Utility::~Utility()
{
}

QString Utility::decodeGBKHex(const QByteArray &hexdata)
{
    return QTextCodec::codecForName("GBK")->toUnicode(QByteArray::fromHex(hexdata));
}

void Utility::launchPlayer(const QString &url)
{
    qDebug() << "launch player" << url;
    QString videoFilePath = QDir::tempPath() + "/video.ram";
    qDebug() << videoFilePath;
    QFile file(videoFilePath);
    if (file.exists()) file.remove();
    if (file.open(QIODevice::ReadWrite | QIODevice::Text)){
        QTextStream out(&file);
        out << url;
        file.close();
    }
    QDesktopServices::openUrl(QUrl("file:///"+videoFilePath));
}

QString Utility::choosePhoto()
{
#ifdef Q_OS_SYMBIAN
    HBufC* result = NULL;
    CDesCArrayFlat* fileArray = new(ELeave)CDesCArrayFlat(3);
    CDesCArrayFlat* aMineType = new(ELeave)CDesCArrayFlat(1);
    aMineType->AppendL(_L("image/jpeg"));
    aMineType->AppendL(_L("image/png"));
    if (MGFetch::RunL(*fileArray, EImageFile, EFalse, _L("select"), _L("title"), aMineType)){
        result = fileArray->MdcaPoint(0).Alloc();
        QString res((QChar*)result->Des().Ptr(), result->Length());
        return res;
    } else
        return "";
#else
    qDebug()<<"Can not select photo";
    return "";
#endif
}

void Utility::openFileDefault(const QString &url)
{
    QDesktopServices::openUrl(QUrl(url));
}

void Utility::openURLDefault(const QString &url)
{
#ifdef Q_OS_SYMBIAN
    const TInt KWmlBrowserUid = 0x10008D39;
    TPtrC myUrl (reinterpret_cast<const TText*>(url.constData()),url.length());
    //QDesktopServices::openUrl(QUrl(url));
    RApaLsSession lsSession;
    // create a session with apparc server.
    User::LeaveIfError(lsSession.Connect());
    CleanupClosePushL(lsSession);
    TDataType mimeDatatype(_L8("application/x-web-browse"));
    TUid handlerUID;
    // get the default application uid for application/x-web-browse
    lsSession.AppForDataType(mimeDatatype,handlerUID);
    // there may not be a mime-type handler defined, especially on S60 3.x
    // in such case we default to the built-in browser
    if (handlerUID.iUid == 0 || handlerUID.iUid == -1)
            handlerUID.iUid = KWmlBrowserUid;
    // Finally launch default browser
    LaunchBrowserL(myUrl, handlerUID);
    qDebug() << "Launching with UID:" << handlerUID.iUid;
    // Cleanup
    CleanupStack::PopAndDestroy(&lsSession);
#else
    qDebug() << "Can not launch URL:" << url;
#endif
}

// ----------------------------------------------------
// CBrowserAppUi::LaunchBrowserL(const TDesC& aUrl)
// Used for launching the default browser with provided url.
// ----------------------------------------------------
//
#ifdef Q_OS_SYMBIAN
void Utility::LaunchBrowserL(const TDesC& aUrl, TUid& aUid)
{
        TApaTaskList taskList( CEikonEnv::Static()->WsSession() );
        TApaTask task = taskList.FindApp( aUid );
        if ( task.Exists() )
        {
                HBufC8* param = HBufC8::NewLC( aUrl.Length() + 2);
                //"4 " is to Start/Continue the browser specifying a URL
                param->Des().Append(_L("4 "));
                param->Des().Append(aUrl);
                task.SendMessage( TUid::Uid( 0 ), *param ); // Uid is not used
                CleanupStack::PopAndDestroy(param);
        }
        else
        {
                HBufC16* param = HBufC16::NewLC( aUrl.Length() + 2);
                //"4 " is to Start/Continue the browser specifying a URL
                param->Des().Append(_L("4 "));
                param->Des().Append(aUrl);
                RApaLsSession appArcSession;
                // connect to AppArc server
                User::LeaveIfError(appArcSession.Connect());
                TThreadId id;
                appArcSession.StartDocument( *param, aUid, id );
                appArcSession.Close();
                CleanupStack::PopAndDestroy(param);
        }
}
#endif

QString Utility::savePixmap(QString url, QString path)
{
    QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
    QIODevice * pData = diskCache->data(url);
    if (pData != 0){
        QImage image;
        image.load(pData, 0);
        QDir dir(path);
        if (!dir.exists()) dir.mkpath(path);

        QString imageName = path + "/" + QFileInfo(url).baseName() + ".png";

        bool res = true;
        if (!image.isNull())
            res = image.save(imageName, "PNG");
        delete(pData);

        if (res)
            return imageName;
        else
            return "";
    }
    return "";
}

void Utility::clearNetworkCache()
{
    qDebug() << "clearing cache";
    QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
    diskCache->clear();
}

int Utility::cacheSize()
{
    QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
    return diskCache->cacheSize();
}

void Utility::setCache(const QString &type, const QString &cache)
{
    QDir dir;
    dir.mkpath(".tbclient");
    QFile file(QString(".tbclient/%1.dat").arg(type));
    if (file.open(QIODevice::WriteOnly)){
        QTextStream stream(&file);
        stream << cache;
        file.close();
    }
}

QString Utility::getCache(const QString &type)
{
    QFile file(QString(".tbclient/%1.dat").arg(type));
    QString res;
    if (file.open(QIODevice::ReadOnly)){
        QTextStream stream(&file);
        res = stream.readAll();
        file.close();
    }
    return res;
}

bool Utility::clearCache(){
    return deleteDir(".tbclient");
}

bool Utility::deleteDir(const QString &dirName)
{
    QDir directory(dirName);
    if (!directory.exists())
    {
        return true;
    }
    QStringList files = directory.entryList(QDir::AllEntries | QDir::NoDotAndDotDot | QDir::Hidden);
    QList<QString>::iterator f = files.begin();
    bool error = false;
    for (; f != files.end(); ++f)
    {
        QString filePath = QDir::convertSeparators(directory.path() + '/' + (*f));
        QFileInfo fi(filePath);
        if (fi.isFile() || fi.isSymLink())
        {
            QFile::setPermissions(filePath, QFile::WriteOwner);
            if (!QFile::remove(filePath))
            {
                qDebug() << "Global::deleteDir 1" << filePath << "faild";
                error = true;
            }
        }
        else if (fi.isDir())
        {
            if (!deleteDir(filePath));
            {
                error = true;
            }
        }
    }
    return !error;
}

bool Utility::removeFile(const QString &url)
{
    return QFile::remove(url);
}

QString Utility::resizeImage(const QString &url, const QSize &toSize)
{
    QImage image(url);
    if (!image.isNull()){
        QString path = qApp->applicationDirPath() + "/.thumbnail";
        QDir dir(path);
        if (!dir.exists()) dir.mkpath(path);

        QString basename = QFileInfo(url).baseName() + QString("_%1_%2").arg(QString::number(toSize.width()), QString::number(toSize.height()));
        if (QFile::exists(path + "/" + basename + ".png")){
            int i = 1;
            while (QFile::exists(path + "/" + basename + QString::number(i) + ".png"))
                i ++;
            basename += QString::number(i);
        }
        QString res = path + "/" + basename + ".png";

        QImage resImg = image.scaled(toSize);
        if (!resImg.isNull() && resImg.save(res, "PNG"))
            return res;
    }
    return "";
}

QString Utility::saveThumbnail(const QString &url, const QSize &toSize)
{
    QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
    QIODevice * pData = diskCache->data(url);
    if (pData != 0){
        QString path = qApp->applicationDirPath() + "/.thumbnail";
        QDir dir(path);
        if (!dir.exists()) dir.mkpath(path);

        QString basename = QFileInfo(url).baseName() + QString("_%1_%2").arg(QString::number(toSize.width()), QString::number(toSize.height()));
        if (QFile::exists(path + "/" + basename + ".png")){
            int i = 1;
            while (QFile::exists(path + "/" + basename + QString::number(i) + ".png"))
                i ++;
            basename += QString::number(i);
        }
        QString res = path + "/" + basename + ".png";

        QImage image;
        image.load(pData, 0);
        QImage resImg = image.scaled(toSize);
        delete(pData);
        if (!resImg.isNull() && resImg.save(res, "PNG"))
            return res;
    }
    return "";
}

