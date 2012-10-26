/*  copyright 2011 -  cnnbboy@gmail.com (blog.cnnbboy.net)

    This file is part of Name.

    Name is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Name is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Name. If not, see <http://www.gnu.org/licenses/>.
*/

#include "tbnetworkaccessmanagerfactory.h"
#include <QDesktopServices>

TBNetworkManager::TBNetworkManager(QObject *parent) :
    QNetworkAccessManager(parent)
{
}

QNetworkReply *TBNetworkManager::createRequest(Operation op,
                                                   const QNetworkRequest &request,
                                                   QIODevice *outgoingData)
{
    QNetworkReply *reply = QNetworkAccessManager::createRequest(op, request, outgoingData);
    return reply;
}


TBNetworkAccessManagerFactory::TBNetworkAccessManagerFactory() :
    QDeclarativeNetworkAccessManagerFactory()
{
}

QNetworkAccessManager* TBNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager* manager = new TBNetworkManager(parent);
    QNetworkDiskCache* diskCache = new QNetworkDiskCache(parent);

    QString dataPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
    diskCache->setCacheDirectory(dataPath);
    diskCache->setMaximumCacheSize(2*1024*1024);
    manager->setCache(diskCache);
    return manager;
}
