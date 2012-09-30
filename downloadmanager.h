#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QQueue>
#include <QUrl>
#include <QFile>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>

class DownloadManager : public QObject
{
    Q_OBJECT
    Q_ENUMS(State)

    Q_PROPERTY(State downloadState READ state NOTIFY stateChanged)
    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString currentFile READ currentFile)
    Q_PROPERTY(QString errorString READ errorString)

public:
    explicit DownloadManager(QObject *parent = 0);

    enum State {
        Unsent,
        Opened,
        Loading,
        Done,
        Finished
    };

    DownloadManager::State state() const;
    void setState(const State newState);

    qreal progress() const;
    void setProgress(const qreal newProgress);

    int error() const;
    void setError(const int newError);

    QString currentFile() const;

    QString errorString() const;

signals:
    void stateChanged();
    void progressChanged();
    void errorChanged();

public slots:
    void appendDownload(const QString &url, const QString &filename);
    bool existsRequest(const QString &url);
    bool existsFile(const QString &filename);
    void abortDownload(const bool isAll = true);

private slots:
    void startNextDownload();
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished();
    void downloadReadyRead();

private:
    QQueue<QUrl> downloadQueue;
    QQueue<QString> fileNameQueue;
    QFile output;
    QNetworkReply *currentDownload;
    QNetworkAccessManager manager;
    QString saveFileName(const QString &oriSaveUrl);

    State m_state;
    qreal m_progress;
    int m_error;
    QString m_errorString;
    QString m_currentFile;
};

#endif // DOWNLOADMANAGER_H
