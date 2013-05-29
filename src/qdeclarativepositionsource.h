#ifndef QDECLARATIVEPOSITIONSOURCE_H
#define QDECLARATIVEPOSITIONSOURCE_H

#include <QObject>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>

using namespace QtMobility;

class QDeclarativePositionSource : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool valid READ valid NOTIFY positionChanged)
    Q_PROPERTY(double latitude READ latitude NOTIFY positionChanged)
    Q_PROPERTY(double longitude READ longitude NOTIFY positionChanged)
    Q_PROPERTY(bool active READ active NOTIFY activeChanged)

public:
    explicit QDeclarativePositionSource(QObject *parent = 0);
    ~QDeclarativePositionSource();

    Q_INVOKABLE void update();

    bool valid() const;
    double latitude() const;
    double longitude() const;
    bool active() const { return m_active; }

signals:
    void positionChanged();
    void activeChanged();

private slots:
    void positionUpdated();

private:
    QGeoPositionInfoSource *source;
    bool m_active;
};

#endif // QDECLARATIVEPOSITIONSOURCE_H
