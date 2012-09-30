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

#ifndef TBNETWORKACCESSMANAGERFACTORY_H
#define TBNETWORKACCESSMANAGERFACTORY_H

#include <QDeclarativeNetworkAccessManagerFactory>
#include <QNetworkAccessManager>

class TBNetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
{
public:
    explicit TBNetworkAccessManagerFactory();
    virtual QNetworkAccessManager* create(QObject *parent);
};

class TBNetworkManager : public QNetworkAccessManager
{
    Q_OBJECT
public:
    explicit TBNetworkManager(QObject *parent=0);
protected:
    QNetworkReply *createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData);
};
#endif // TBNETWORKACCESSMANAGERFACTORY_H
