#include <QtGui/QApplication>
#include <QSplashScreen>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

#include "downloadmanager.h"
#include "httpuploader.h"
#include "scribblearea.h"
#include "tbsettings.h"
#include "utility.h"
#include "tbnetworkaccessmanagerfactory.h"
#include "customwebview.h"

#ifdef Q_OS_SYMBIAN
#include <QSymbianEvent>
#include <w32std.h>
#include <avkon.hrh>
#endif

class MyApplication : public QApplication
{
public:
    MyApplication( int argc, char** argv ) : QApplication( argc, argv ) {}
#ifdef Q_OS_SYMBIAN
protected:
    bool symbianEventFilter( const QSymbianEvent* event ) {
        if (event->type() == QSymbianEvent::WindowServerEvent){
            if (event->windowServerEvent()->Type() == KAknUidValueEndKeyCloseEvent )
                return true;
        }
        return QApplication::symbianEventFilter(event);
    }

#endif
};

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<MyApplication> app(new MyApplication(argc, argv));

    QPixmap p(":/gfx/splash.png");
    QSplashScreen *splash = new QSplashScreen(p);
    splash->show();
    splash->raise();
    app->processEvents();

    app->setOrganizationName(QString("Yeatse"));
    app->setApplicationName(QString("tbclient"));
    app->setApplicationVersion(VER);

    qmlRegisterUncreatableType<HttpPostField>("HttpUp", 1, 0, "HttpPostField", "Can't touch this");
    qmlRegisterType<HttpPostFieldValue>("HttpUp", 1, 0, "HttpPostFieldValue");
    qmlRegisterType<HttpPostFieldFile>("HttpUp", 1, 0, "HttpPostFieldFile");
    qmlRegisterType<HttpUploader>("HttpUp", 1, 0, "HttpUploader");

    qmlRegisterType<ScribbleArea>("Scribble", 1, 0, "ScribbleArea");

    qmlRegisterType<QDeclarativeWebSettings>();
    qmlRegisterType<QDeclarativeWebView>("CustomWebKit", 1, 0, "WebView");

    QmlApplicationViewer viewer;

    viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);

    TBSettings settings;    
    TBNetworkAccessManagerFactory factory;
    DownloadManager manager;
    Utility utility(viewer.engine());

    viewer.engine()->setNetworkAccessManagerFactory(&factory);
    viewer.rootContext()->setContextProperty("utility", &utility);
    viewer.rootContext()->setContextProperty("manager", &manager);
    viewer.rootContext()->setContextProperty("tbsettings", &settings);

    viewer.setMainQmlFile(QLatin1String("qml/tbclient/main.qml"));
    viewer.showExpanded();

    splash->finish(&viewer);
    splash->~QSplashScreen();
    return app->exec();
}
