#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QSplashScreen>
#include "qmlapplicationviewer.h"
#include "tbsettings.h"
#include "utility.h"
#include "tbnetworkaccessmanagerfactory.h"
#include "httpuploader.h"
#include "scribblearea.h"
#include "customwebview.h"
#include "downloader.h"

#ifdef Q_OS_S60V5
#include "qdeclarativepositionsource.h"
#endif

#ifdef QVIBRA
#include <QVibra/qvibra.h>
#endif

#ifdef IN_APP_PURCHASE
#include "qiap/qiap.h"
#endif

#ifdef Q_OS_HARMATTAN
#include <QDBusConnection>
#endif

#ifdef Q_OS_SYMBIAN
#include <QSymbianEvent>
#include <w32std.h>
#include <avkon.hrh>

class MyApplication : public QApplication
{
public:
    MyApplication( int argc, char** argv ) : QApplication( argc, argv ) {}
protected:
    bool symbianEventFilter( const QSymbianEvent* event ) {
        if (event->type() == QSymbianEvent::WindowServerEvent){
            if (event->windowServerEvent()->Type() == KAknUidValueEndKeyCloseEvent )
                return true;
        }
        return QApplication::symbianEventFilter(event);
    }
};

#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef Q_OS_SYMBIAN
    QScopedPointer<QApplication> app(new MyApplication(argc, argv));
#ifdef Q_OS_S60V5
    QSplashScreen *splash = new QSplashScreen(QPixmap("qml/symbian1/gfx/splash.png"));
#else
    QSplashScreen *splash = new QSplashScreen(QPixmap("qml/tbclient/gfx/splash.png"));
#endif
    splash->show();
    splash->raise();
#else
    QScopedPointer<QApplication> app(createApplication(argc, argv));
#endif

    QString locale = QLocale::system().name();
    QTranslator translator;
    if (translator.load(QString("tbclient_")+locale, ":/i18n/"))
        app->installTranslator(&translator);

    app->setOrganizationName("Yeatse");
    app->setApplicationName("tbclient");

#ifdef Q_OS_S60V5
    app->setApplicationVersion("1.6.2");
#else
    app->setApplicationVersion(VER);
#endif

    QmlApplicationViewer viewer;

    viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);

    qmlRegisterUncreatableType<HttpPostField>("HttpUp", 1, 0, "HttpPostField", "Can't touch this");
    qmlRegisterType<HttpPostFieldValue>("HttpUp", 1, 0, "HttpPostFieldValue");
    qmlRegisterType<HttpPostFieldFile>("HttpUp", 1, 0, "HttpPostFieldFile");
    qmlRegisterType<HttpUploader>("HttpUp", 1, 0, "HttpUploader");

    qmlRegisterType<ScribbleArea>("Scribble", 1, 0, "ScribbleArea");

    qmlRegisterType<QDeclarativeWebSettings>();
    qmlRegisterType<QDeclarativeWebView>("CustomWebKit", 1, 0, "WebView");

#ifdef Q_OS_S60V5
    qmlRegisterType<QDeclarativePositionSource>("LocationAPI", 1, 0, "PositionSource");
#elif defined(Q_WS_SIMULATOR)
    qmlRegisterType<QObject>("LocationAPI", 1, 0, "PositionSource");
#endif

#ifdef QVIBRA
    qmlRegisterType<QVibra>("Vibra", 1, 0, "Vibra");
#elif defined(Q_WS_SIMULATOR)
    qmlRegisterType<QObject>("Vibra", 1, 0, "Vibra");
#endif

#ifdef IN_APP_PURCHASE
    qmlRegisterType<QIap>("IAP", 1, 0, "QIap");
#endif

#ifdef Q_OS_HARMATTAN
    viewer.engine()->addImageProvider(QLatin1String("background"), new BackgroundProvider);

    new TBClientIf(&viewer);
    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.registerService("com.tbclient");
    bus.registerObject("/com/tbclient", app.data());
#endif

    TBSettings tbsettings;
    Utility utility(viewer.engine());
    TBNetworkAccessManagerFactory factory;
    Downloader downloader;

    viewer.engine()->setNetworkAccessManagerFactory(&factory);
    QDeclarativeContext* context = viewer.rootContext();
    context->setContextProperty("tbsettings", &tbsettings);
    context->setContextProperty("utility", &utility);
    context->setContextProperty("downloader", &downloader);

#ifdef Q_OS_SYMBIAN
#ifdef Q_OS_S60V5
    viewer.setMainQmlFile(QLatin1String("qml/symbian1/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/tbclient/main.qml"));
#endif
#elif defined(Q_OS_HARMATTAN)
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/symbian1/main.qml"));
#endif
    viewer.showExpanded();

#ifdef Q_OS_SYMBIAN
    splash->finish(&viewer);
    splash->deleteLater();
#endif

    return app->exec();
}
