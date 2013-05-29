#include "qdeclarativepositionsource.h"
#include <QDebug>

QDeclarativePositionSource::QDeclarativePositionSource(QObject *parent) :
    QObject(parent),
    m_active(false)
{
    source = QGeoPositionInfoSource::createDefaultSource(this);
    if (source != 0){
        connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated()));
        connect(source, SIGNAL(updateTimeout()), this, SLOT(positionUpdated()));
    }
}

QDeclarativePositionSource::~QDeclarativePositionSource()
{
}

void QDeclarativePositionSource::update()
{
    if (source != 0){
        m_active = true;
        emit activeChanged();
        source->requestUpdate();
    }
}

bool QDeclarativePositionSource::valid() const
{
    if (source != 0){
        return source->lastKnownPosition().coordinate().isValid();
    }
    return false;
}

double QDeclarativePositionSource::latitude() const
{
    if (source != 0){
        return source->lastKnownPosition().coordinate().latitude();
    }
    return 0;
}

double QDeclarativePositionSource::longitude() const
{
    if (source != 0){
        return source->lastKnownPosition().coordinate().longitude();
    }
    return 0;
}

void QDeclarativePositionSource::positionUpdated()
{
    m_active = false;
    emit positionChanged();
    emit activeChanged();
}
