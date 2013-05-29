#ifndef TBNETWORKACCESSMANAGERFACTORY_H
#define TBNETWORKACCESSMANAGERFACTORY_H

#include <QtDeclarative>
#include <QtNetwork>

class TBNetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
{
public:
    explicit TBNetworkAccessManagerFactory();
    virtual QNetworkAccessManager* create(QObject *parent);
};

class TBNetworkAccessManager : public QNetworkAccessManager
{
    Q_OBJECT
public:
    explicit TBNetworkAccessManager(QObject *parent=0);
protected:
    QNetworkReply *createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData);
};

#endif // TBNETWORKACCESSMANAGERFACTORY_H
