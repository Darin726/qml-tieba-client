#include "tbnetworkaccessmanagerfactory.h"
#include <QDesktopServices>

TBNetworkAccessManagerFactory::TBNetworkAccessManagerFactory() :
    QDeclarativeNetworkAccessManagerFactory()
{
}

QNetworkAccessManager* TBNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager* manager = new TBNetworkAccessManager(parent);

    QNetworkDiskCache* diskCache = new QNetworkDiskCache(parent);
    QString dataPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);

    QDir dir(dataPath);
    if (!dir.exists()) dir.mkpath(dir.absolutePath());

    diskCache->setCacheDirectory(dataPath);
    diskCache->setMaximumCacheSize(3*1024*1024);
    manager->setCache(diskCache);

    return manager;
}

TBNetworkAccessManager::TBNetworkAccessManager(QObject *parent) :
    QNetworkAccessManager(parent)
{
}

QNetworkReply *TBNetworkAccessManager::createRequest(Operation op,
                                                   const QNetworkRequest &request,
                                                   QIODevice *outgoingData)
{
    QNetworkRequest req(request);
    req.setRawHeader("User-Agent", "Dalvik/1.6.0 (Linux; U; Android 4.1.2; GT-I9100 Build/JZO54K)");
    req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    QNetworkReply *reply = QNetworkAccessManager::createRequest(op, req, outgoingData);
    return reply;
}
