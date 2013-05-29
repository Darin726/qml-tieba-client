#ifndef UTILITY_H
#define UTILITY_H

#include <QObject>
#include <QDesktopServices>
#include <QtDeclarative>

#ifdef Q_OS_S60V5
// to notify application's focus change
class ActiveEventNotifier : public QObject
{
    Q_OBJECT
public:
    explicit ActiveEventNotifier(QObject *parent = 0);
protected:
    bool eventFilter(QObject *, QEvent *);
signals:
    void applicationActiveChanged(bool);
};
#endif

class Utility : public QObject
{
    Q_OBJECT
#ifdef Q_OS_S60V5
    Q_PROPERTY(bool applicationActive READ applicationActive NOTIFY applicationActiveChanged)
public:
    bool applicationActive() const { return m_applicationActive; }
signals:
    void applicationActiveChanged();
private:
    bool m_applicationActive;
    ActiveEventNotifier* notifier;
private slots:
    void applicationActiveChanged(bool);
#endif

public:
    explicit Utility(QDeclarativeEngine *engine = 0, QObject *parent = 0);
    ~Utility();

    // handle offline cache
    Q_INVOKABLE void setCache(const QString &key, const QString &cache);
    Q_INVOKABLE QString getCache(const QString &key);
    Q_INVOKABLE bool clearCache();

    // open url with default browser
    Q_INVOKABLE void openURLDefault(const QString &url);

    // launch player
    Q_INVOKABLE void launchPlayer(const QString &url);

    Q_INVOKABLE int fileSize(const QString &fileName);
    Q_INVOKABLE bool removeFile(const QString &fileName);

    //symbian: 0 ---- library, 1 ---- folder, 2 ------ camera
    //else: just from folder
    //return empty string if canceled
    Q_INVOKABLE QString selectImage(int param = 0);

    //return empty string if canceled
    Q_INVOKABLE QString selectFolder();

    //select color
    //return default color if canceled
    Q_INVOKABLE QColor selectColor(const QColor &defaultColor);

    Q_INVOKABLE void copyToClipbord(const QString &text);

    //transform a GBK-encoded hex data into unicode
    Q_INVOKABLE QString decodeGBKHex(const QByteArray &hexdata);

    //symbian: system's global note
    //harmattan: add a notification to feed screen
    Q_INVOKABLE void showGlobalNote(const QString &message);

#ifdef Q_OS_HARMATTAN
    Q_INVOKABLE void clearGlobalNotes();
#endif

    //imageurl can both from local and remote
    //save a thumbnail with toSize into a dir
    //on symbian, dir should be !:/private/{UID}/.thumbnail
    //on unix, dir should be /home/user/.thumbnails/tbclient
    Q_INVOKABLE QString createThumbnail(const QString &imageurl, const QSize &toSize);

    //save a file from network cache into localUrl
    Q_INVOKABLE bool saveCache(const QString &remoteUrl, const QString &localPath);

    //return network cache as bytes
    Q_INVOKABLE int cacheSize();

    //clear network cache;
    Q_INVOKABLE void clearNetworkCache();

    bool deleteDir(const QString &dirName);

#ifdef Q_OS_SYMBIAN
    // open a browser with aUrl and aUid;
    void LaunchBrowserL(const TDesC& aUrl, TUid& aUid);
    // return empty string if canceled;
    // else return captured image url;
    QString CaptureImage();
    // return empty string if canceled;
    // else return selected image url;
    QString LaunchLibrary();
#endif

private:
    QDeclarativeEngine *m_engine;
};

#ifdef Q_OS_HARMATTAN
// to provide a subtransparent background image
class BackgroundProvider : public QDeclarativeImageProvider
{
public:
    BackgroundProvider(QDeclarativeImageProvider::ImageType type = QDeclarativeImageProvider::Pixmap);
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

// to handle the touch events on feed screen
// when clicked the feed item, just take the app to top
#include <QDBusAbstractAdaptor>

class TBClientIf : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "com.tbclient")
public:
    explicit TBClientIf(QDeclarativeView* view) : QDBusAbstractAdaptor(qApp), m_view(view){}
public slots:
    void notify(){ m_view->activateWindow(); }
private:
    QDeclarativeView* m_view;
};

#endif

#endif // UTILITY_H
