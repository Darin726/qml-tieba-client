#include "utility.h"

#include <QSystemDeviceInfo>

#ifdef Q_OS_SYMBIAN
#include <mgfetch.h>                //for selecting picture
#include <apgtask.h>                //for launching browser
#include <apgcli.h>                 //..
#include <eikenv.h>                 //..
#include <NewFileServiceClient.h>   //for camera
#include <AiwServiceHandler.h>      //..
#include <AiwCommon.hrh>            //..
#include <AiwGenericParam.hrh>      //..
#include <aknglobalnote.h>          //for global notes
#include <avkon.hrh>                //..
#endif

#ifdef Q_OS_HARMATTAN
#include <MNotification>
#include <MRemoteAction>
#endif

using namespace QtMobility;

Utility::Utility(QDeclarativeEngine *engine, QObject *parent) :
    QObject(parent),
    m_engine(0)
{
    this->m_engine = engine;
#ifdef Q_OS_S60V5
    this->notifier = new ActiveEventNotifier(this);
    connect(notifier, SIGNAL(applicationActiveChanged(bool)), this, SLOT(applicationActiveChanged(bool)));
    qApp->installEventFilter(notifier);
#endif
}

Utility::~Utility()
{
}

void Utility::setCache(const QString &key, const QString &cache)
{
#ifdef Q_OS_UNIX
    QString path = QDesktopServices::storageLocation(QDesktopServices::DataLocation)+"/.userdata";
#else
    QString path = qApp->applicationDirPath() + "/.userdata";
#endif
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(path);

    QFile file(QString("%1/%2.dat").arg(path, key));
    if (file.open(QIODevice::WriteOnly)){
        QTextStream stream(&file);
        stream << cache;
        file.close();
    }
}

QString Utility::getCache(const QString &key)
{
#ifdef Q_OS_UNIX
    QString path = QDesktopServices::storageLocation(QDesktopServices::DataLocation)+"/.userdata";
#else
    QString path = qApp->applicationDirPath() + "/.userdata";
#endif
    QFile file(QString("%1/%2.dat").arg(path, key));
    QString res;
    if (file.open(QIODevice::ReadOnly)){
        QTextStream stream(&file);
        res = stream.readAll();
        file.close();
    }
    return res;
}

bool Utility::clearCache()
{
#ifdef Q_OS_UNIX
    QString path = QDesktopServices::storageLocation(QDesktopServices::DataLocation)+"/.userdata";
#else
    QString path = qApp->applicationDirPath() + "/.userdata";
#endif
    return deleteDir(path);
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
            if (!deleteDir(filePath))
            {
                error = true;
            }
        }
    }
    return !error;
}


int Utility::fileSize(const QString &fileName)
{
    QFileInfo info(fileName);
    return info.size();
}

bool Utility::removeFile(const QString &fileName)
{
    return QFile::remove(fileName);
}

void Utility::copyToClipbord(const QString &text)
{
    qApp->clipboard()->setText(text);
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
    QDesktopServices::openUrl(QUrl(url));
#endif
}

QString Utility::selectImage(int param)
{

#ifdef Q_OS_SYMBIAN
    QString result;
    switch (param){
    case 0:
        TRAPD(err, result = LaunchLibrary());
        break;
    case 1:
        result = QFileDialog::getOpenFileName(0, QString(), QString(), "Images (*.png *.gif *.jpg)");
        break;
    case 2:
        TRAPD(err1, result = CaptureImage());
        break;
    default:
        break;
    }
    return result;
#else
    Q_UNUSED(param);
    return QFileDialog::getOpenFileName(0, QString(), QString(), "Images (*.png *.gif *.jpg)");
#endif
}

QString Utility::selectFolder()
{
    return QFileDialog::getExistingDirectory();
}

void Utility::launchPlayer(const QString &url)
{
#ifdef Q_OS_SYMBIAN
    QString videoFilePath = QDir::tempPath() + "/video.ram";
    qDebug() << "launch player" << url << videoFilePath;
    QFile file(videoFilePath);
    if (file.exists()) file.remove();
    if (file.open(QIODevice::ReadWrite|QIODevice::Text)){
        QTextStream out(&file);
        out << url;
        file.close();
        QDesktopServices::openUrl(QUrl("file:///"+videoFilePath));
    }
#else
    QDesktopServices::openUrl(url);
#endif
}

QString Utility::decodeGBKHex(const QByteArray &hexdata)
{
    QTextCodec* codec = QTextCodec::codecForName("GBK");
    QByteArray text = QByteArray::fromHex(hexdata);
    return codec->toUnicode(text);
}

QColor Utility::selectColor(const QColor &defaultColor)
{
    QColor result = QColorDialog::getColor();
    if (result.isValid()){
        return result;
    } else {
        return defaultColor;
    }
}

QString Utility::createThumbnail(const QString &imageurl, const QSize &toSize)
{
    QImage image;
    if (imageurl.startsWith("http://", Qt::CaseInsensitive)){
        QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
        QIODevice *pData = diskCache->data(imageurl);
        if (pData != 0){
            image.load(pData, 0);
            pData->deleteLater();
        }
    } else {
        image.load(imageurl, 0);
    }

    if (!image.isNull()){
#ifdef Q_OS_UNIX
        QString path = QDesktopServices::storageLocation(QDesktopServices::HomeLocation)+"/.thumbnails/"+qAppName();
#else
        QString path = qApp->applicationDirPath() + "/.thumbnail";
#endif
        QDir dir(path);
        if (!dir.exists()) dir.mkpath(path);

        QString basename = QFileInfo(imageurl).baseName()
                + QString("_%1_%2").arg(QString::number(toSize.width()), QString::number(toSize.height()));

        if (QFile::exists(path + "/" + basename + ".png")){
            int i = 1;
            while (QFile::exists(path + "/" + basename + QString::number(i) + ".png")) {
                i ++;
            }
            basename += QString::number(i);
        }
        QString result = path + "/" + basename + ".png";
        QImage resultImage = image.scaled(toSize);
        if (!resultImage.isNull() && resultImage.save(result, "PNG")){
            return result;
        }
    }

    return QString();
}

bool Utility::saveCache(const QString &remoteUrl, const QString &localPath)
{
    QIODevice *data = m_engine->networkAccessManager()->cache()->data(remoteUrl);
    if (data){
        QString path = QFileInfo(localPath).absolutePath();
        QDir dir(path);
        if (!dir.exists()) dir.mkpath(path);

        QFile file(localPath);
        if (file.open(QIODevice::WriteOnly)){
            file.write(data->readAll());
            file.close();
            data->deleteLater();
            return true;
        }
    }
    return false;
}

int Utility::cacheSize()
{
    QNetworkDiskCache *diskCache = dynamic_cast<QNetworkDiskCache *>(m_engine->networkAccessManager()->cache());
    if (diskCache){
        return diskCache->cacheSize();
    } else {
        return 0;
    }
}

void Utility::clearNetworkCache()
{
    m_engine->networkAccessManager()->cache()->clear();
}

void Utility::showGlobalNote(const QString &message)
{
#ifdef Q_OS_SYMBIAN
    bool silent;
#ifdef Q_OS_S60V5
    QSystemDeviceInfo deviceInfo;
    silent = deviceInfo.currentProfile() == QSystemDeviceInfo::SilentProfile;
#else
    QSystemDeviceInfo::ProfileDetails details;
    silent = details.voiceRingtoneVolume() == 0;
#endif

    TPtrC aMessage (reinterpret_cast<const TText*>(message.constData()), message.length());
    CAknGlobalNote* note = CAknGlobalNote::NewLC();
    if (silent){
        note->SetTone(0);
    } else {
        note->SetTone(EAvkonSIDReadialCompleteTone);
    }
    note->ShowNoteL(EAknGlobalInformationNote, aMessage);
    CleanupStack::PopAndDestroy(note);
#elif defined(Q_OS_HARMATTAN)
    clearGlobalNotes();
    MNotification notification(MNotification::ImReceivedEvent, tr("TBClient"), message);
    notification.setIdentifier("notify");
    MRemoteAction action("com.tbclient", "/com/tbclient", "com.tbclient", "notify");
    notification.setAction(action);
    notification.publish();
#else
    qDebug() << message;
#endif
}

#ifdef Q_OS_HARMATTAN
void Utility::clearGlobalNotes()
{
    QList<MNotification*> activeNotifications = MNotification::notifications();
    QMutableListIterator<MNotification*> i(activeNotifications);
    while (i.hasNext()) {
        MNotification *notification = i.next();
        if (notification->summary() == tr("TBClient"))
            notification->remove();
    }
}
#endif


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

QString Utility::CaptureImage()
{
    CNewFileServiceClient* fileClient = NewFileServiceFactory::NewClientL();
    CleanupStack::PushL(fileClient);

    CDesCArray* fileNames = new (ELeave) CDesCArrayFlat(1);
    CleanupStack::PushL(fileNames);

    CAiwGenericParamList* paramList = CAiwGenericParamList::NewLC();

    TAiwVariant variant(EFalse);
    TAiwGenericParam param1(EGenericParamMMSSizeLimit, variant);
    paramList->AppendL( param1 );

    TSize resolution = TSize(1600, 1200);
    TPckgBuf<TSize> buffer( resolution );
    TAiwVariant resolutionVariant( buffer );
    TAiwGenericParam param( EGenericParamResolution, resolutionVariant );
    paramList->AppendL( param );

    const TUid KUidCamera = { 0x101F857A }; // Camera UID for S60 5th edition

    TBool result = fileClient->NewFileL( KUidCamera, *fileNames, paramList,
                               ENewFileServiceImage, EFalse );

    QString ret;

    if (result) {
        TPtrC fileName=fileNames->MdcaPoint(0);
        ret = QString((QChar*) fileName.Ptr(), fileName.Length());
    }

    CleanupStack::PopAndDestroy(3);

    return ret;
}

QString Utility::LaunchLibrary()
{
    HBufC* result = NULL;
    CDesCArrayFlat* fileArray = new(ELeave)CDesCArrayFlat(3);
    CDesCArrayFlat* aMineType = new(ELeave)CDesCArrayFlat(1);
    aMineType->AppendL(_L("image/jpeg"));
    aMineType->AppendL(_L("image/png"));
    if (MGFetch::RunL(*fileArray, EImageFile, EFalse, _L("select"), _L("select image"), aMineType)){
        result = fileArray->MdcaPoint(0).Alloc();
        QString res((QChar*)result->Des().Ptr(), result->Length());
        return res;
    } else
        return QString();
}

#endif


#ifdef Q_OS_S60V5
ActiveEventNotifier::ActiveEventNotifier(QObject *parent) : QObject(parent)
{
}
bool ActiveEventNotifier::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::ApplicationActivate){
        emit applicationActiveChanged(true);
        return true;
    } else if (event->type() == QEvent::ApplicationDeactivate){
        emit applicationActiveChanged(false);
        return true;
    } else {
        return QObject::eventFilter(obj, event);
    }
}

void Utility::applicationActiveChanged(bool isActive){
    this->m_applicationActive = isActive;
    emit applicationActiveChanged();
}
#endif


#ifdef Q_OS_HARMATTAN
BackgroundProvider::BackgroundProvider(QDeclarativeImageProvider::ImageType type)
    : QDeclarativeImageProvider(type)
{
}

QPixmap BackgroundProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(requestedSize);
    QImage result;
    bool inverted = id.endsWith("-inverted");
    QString src = inverted ? id.left(id.size()-9) : id;
    if (result.load(src)){
        size->setWidth(result.width());
        size->setHeight(result.height());
        result = result.scaled(QSize(480, 854), Qt::KeepAspectRatioByExpanding);
    }
    result = result.copy(0, 0, 480, 854);
    QPainter p(&result);
    QColor c = inverted ? QColor(0, 0, 0, 108) : QColor(224, 225, 226, 80);
    p.fillRect(result.rect(), c);
    return QPixmap::fromImage(result);
}
#endif
