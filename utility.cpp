#include "utility.h"
#include <QDebug>
#include <QTextCodec>
#include <QDir>
#include <QTextStream>
#include <QNetworkDiskCache>
#include <QNetworkAccessManager>
#include <QImage>

#ifdef Q_OS_SYMBIAN
#include <apgtask.h>
#include <apgcli.h>
#include <eikenv.h>
#include <mgfetch.h>
#endif

Utility::Utility(QObject *parent) :
    QObject(parent)
{
}

Utility::~Utility()
{
    //clearNetworkCache();
}


void Utility::startApp(const QString &program)
{
    QProcess *process = new QProcess(this);
    connect(process, SIGNAL(error(QProcess::ProcessError)), this, SLOT(error(QProcess::ProcessError)));
    process->start(program);
}

void Utility::error(QProcess::ProcessError error)
{
    emit processError(static_cast<int>(error));
}

QString Utility::decodeGBKHex(const QByteArray &hexdata)
{
    return QTextCodec::codecForName("GBK")->toUnicode(QByteArray::fromHex(hexdata));
}

void Utility::launchPlayer(const QString &url)
{
    qDebug() << "launch player" << url;
    QString videoFilePath = QDir::tempPath() + "/video.ram";
    QFile file(videoFilePath);
    if (file.exists()) file.remove();
    if (file.open(QIODevice::ReadWrite | QIODevice::Text)){
        QTextStream out(&file);
        out << url;
        file.close();
    }
    QDesktopServices::openUrl(QUrl("file:///"+videoFilePath));
}

QString Utility::scaleImage(const QString &fileName, const QSize &size)
{
    QFile file(fileName);
    if (file.size() > 2*1024*1024){
        QImage img(fileName);
        if (!img.isNull()){
            QImage res = img.scaled(size, Qt::KeepAspectRatio);
            QString path = QDir::tempPath() + "/tmp.png";
            if (res.save(path))
                return path;
        }
    }
    return "";
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

void Utility::setEngine(QDeclarativeEngine *engine)
{
    m_engine = engine;
}

void Utility::clearNetworkCache()
{
    qDebug() << "clearing cache";
    QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
    diskCache->clear();
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
/*
    if(!directory.rmdir(QDir::convertSeparators(directory.path())))
    {
        qDebug() << "Global::deleteDir 3" << directory.path()  << "faild";
        error = true;
    }
*/
    return !error;
}
