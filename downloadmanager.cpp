#include "downloadmanager.h"
#include <QDebug>
#include <QTimer>
#include <QFileInfo>
#include <QDir>
#include <QIODevice>

DownloadManager::DownloadManager(QObject *parent) :
    QObject(parent),
    m_progress(0),
    m_error(0)
{
    m_state = Unsent;
}

DownloadManager::State DownloadManager::state() const
{
    return m_state;
}
void DownloadManager::setState(const State newState)
{
    if (m_state != newState){
        m_state = newState;
        emit stateChanged();
    }
}

qreal DownloadManager::progress() const
{
    return m_progress;
}
void DownloadManager::setProgress(const qreal newProgress)
{
    m_progress = newProgress;
    emit progressChanged();
}

int DownloadManager::error() const
{
    return m_error;
}
void DownloadManager::setError(const int newError)
{
    if (m_error != newError){
        m_error = newError;
        emit errorChanged();
    }
}

QString DownloadManager::errorString() const
{
    return m_errorString;
}

QString DownloadManager::currentFile() const
{
    return m_currentFile;
}

void DownloadManager::appendDownload(const QString &url, const QString &filename)
{
    qDebug()<<url<<"  "<<filename;

    if (downloadQueue.isEmpty() && (m_state == Unsent||m_state == Finished))
        QTimer::singleShot(0, this, SLOT(startNextDownload()));

    downloadQueue.enqueue(QUrl::fromEncoded(url.toLocal8Bit()));
    fileNameQueue.enqueue(filename);
}

void DownloadManager::startNextDownload()
{
    if (downloadQueue.isEmpty()){
        setState(Finished);
        return;
    }
    QUrl url = downloadQueue.dequeue();
    QString filename = saveFileName(fileNameQueue.dequeue());
    m_currentFile = filename;

    output.setFileName(filename);
    if (!output.open(QIODevice::WriteOnly)){
        setError(-1);
        m_errorString = "Cannot open file...";
        setState(Done);
        startNextDownload();
        return;
    }

    setError(0);
    setState(Opened);

    QNetworkRequest request(url);
    currentDownload = manager.get(request);
    setState(Loading);

    connect(currentDownload, SIGNAL(downloadProgress(qint64,qint64)), SLOT(downloadProgress(qint64,qint64)));
    connect(currentDownload, SIGNAL(finished()), SLOT(downloadFinished()));
    connect(currentDownload, SIGNAL(readyRead()), SLOT(downloadReadyRead()));
}

QString DownloadManager::saveFileName(const QString &oriSaveUrl)
{
    QFileInfo info(oriSaveUrl);
    QString path = info.absolutePath();
    QString basename = info.completeBaseName();
    QString suffix = info.suffix();

    QDir dir;
    if (!dir.exists(path))
        dir.mkpath(path);
    if (basename.isEmpty())
        basename = "download";
    if (suffix.isEmpty())
        suffix = "dl";

    if (QFile::exists(path+"/"+basename+"."+suffix)){
        int i = 1;
        while (QFile::exists(path+"/"+basename+QString::number(i)+"."+suffix))
            i++;
        basename += QString::number(i);
    }
    return path+'/'+basename+"."+suffix;
}

void DownloadManager::downloadFinished()
{
    output.close();
    if(currentDownload->error()){
        QFile::remove(m_currentFile);
    }
    setError(currentDownload->error());
    m_errorString = currentDownload->errorString();
    setState(Done);
    currentDownload->deleteLater();
    startNextDownload();
}

void DownloadManager::downloadReadyRead()
{
    output.write(currentDownload->readAll());
}
void DownloadManager::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    setProgress(qreal(bytesReceived)/qreal(bytesTotal));
}

void DownloadManager::abortDownload(const bool isAll)
{
    if (isAll){
        fileNameQueue.clear();
        downloadQueue.clear();
    }
    if (m_state == Loading){
        currentDownload->abort();
    }
}

bool DownloadManager::existsRequest(const QString &url)
{
    return downloadQueue.contains(QUrl::fromEncoded(url.toLocal8Bit()));
}

bool DownloadManager::existsFile(const QString &filename)
{
    return QFile::exists(filename);
}
