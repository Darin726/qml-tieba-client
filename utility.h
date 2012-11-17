#ifndef UTILITY_H
#define UTILITY_H

#include <QObject>
#include <QDesktopServices>
#include <QtDeclarative>

class Utility : public QObject
{
    Q_OBJECT
public:
    explicit Utility(QDeclarativeEngine *engine, QObject *parent = 0);
    ~Utility();

    Q_INVOKABLE void openURLDefault(const QString &url);
    Q_INVOKABLE void openFileDefault(const QString &url);
    Q_INVOKABLE void launchPlayer(const QString &url);

    Q_INVOKABLE bool removeFile(const QString &url);
    Q_INVOKABLE QString resizeImage(const QString &url, const QSize &toSize);

    Q_INVOKABLE QString decodeGBKHex(const QByteArray &hexdata);
    Q_INVOKABLE QString choosePhoto();
    Q_INVOKABLE QString savePixmap(QString url, QString path = QDesktopServices::storageLocation(QDesktopServices::PicturesLocation));
    Q_INVOKABLE QString saveThumbnail(const QString &url, const QSize &toSize);

    Q_INVOKABLE int cacheSize();
    Q_INVOKABLE void clearNetworkCache();
    Q_INVOKABLE void setCache(const QString &type, const QString &cache);
    Q_INVOKABLE QString getCache(const QString &type);
    Q_INVOKABLE bool clearCache();

#ifdef Q_OS_SYMBIAN
    void LaunchBrowserL(const TDesC& aUrl, TUid& aUid);
#endif

private:
    QDeclarativeEngine *m_engine;
    bool deleteDir(const QString &dirName);
};

#endif // UTILITY_H
