#ifndef UTILITY_H
#define UTILITY_H

#include <QObject>
#include <QDesktopServices>
#include <QProcess>
#include <QDeclarativeEngine>
#include <QSize>

class Utility : public QObject
{
    Q_OBJECT
public:
    explicit Utility(QObject *parent = 0);
    ~Utility();

    void setEngine(QDeclarativeEngine *engine);

#ifdef Q_OS_SYMBIAN
    void LaunchBrowserL(const TDesC& aUrl, TUid& aUid);
#endif
    
signals:
    void processError(int error);

public slots:
    void openURLDefault(const QString &url);
    void openFileDefault(const QString &url);
    void launchPlayer(const QString &url);
    void startApp(const QString &program);
    bool removeFile(const QString &url);
    QString resizeImage(const QString &url, const QSize &toSize);

    QString decodeGBKHex(const QByteArray &hexdata);
    QString choosePhoto();
    QString savePixmap(QString url, QString path = QDesktopServices::storageLocation(QDesktopServices::PicturesLocation));

    void clearNetworkCache();
    void setCache(const QString &type, const QString &cache);
    QString getCache(const QString &type);
    bool clearCache();

private:
    QDeclarativeEngine *m_engine;
    bool deleteDir(const QString &dirName);

private slots:
    void error(QProcess::ProcessError error);
};

#endif // UTILITY_H
