TEMPLATE = app
TARGET = tbclient

VERSION = 1.6.2
DEFINES += VER=\\\"$$VERSION\\\"

QT += network webkit

CONFIG += mobility
MOBILITY += location systeminfo

INCLUDEPATH += src

HEADERS += \
    src/tbsettings.h \
    src/utility.h \
    src/tbnetworkaccessmanagerfactory.h \
    src/httpuploader.h \
    src/scribbleArea.h \
    src/customwebview.h \
    src/downloader.h

SOURCES += main.cpp \
    src/tbsettings.cpp \
    src/utility.cpp \
    src/tbnetworkaccessmanagerfactory.cpp \
    src/httpuploader.cpp \
    src/scribbleArea.cpp \
    src/customwebview.cpp \
    src/downloader.cpp \
#    qml/tbclient/*.qml \
#    qml/tbclient/Component/*.qml \
#    qml/tbclient/Delegate/*.qml \
#    qml/tbclient/Dialog/*.qml \
#    qml/tbclient/NearbyPageComp/*.qml \
#    qml/js/*.js

TRANSLATIONS += i18n/tbclient_zh.ts
RESOURCES += tbclient.qrc

folder_symbian3.source = qml/tbclient
folder_symbian3.target = qml

folder_symbian1.source = qml/symbian1
folder_symbian1.target = qml

folder_harmattan.source = qml/meego
folder_harmattan.target = qml

folder_emoticon.source = qml/emo
folder_emoticon.target = qml

folder_js.source = qml/js
folder_js.target = qml

DEPLOYMENTFOLDERS = folder_js folder_emoticon

simulator {
    DEPLOYMENTFOLDERS += folder_symbian3 folder_symbian1 folder_harmattan
}

contains(MEEGO_EDITION,harmattan){
    DEFINES += Q_OS_HARMATTAN
    DEPLOYMENTFOLDERS += folder_harmattan

    QT += dbus
    CONFIG += qdeclarative-boostable meegotouch
    MOBILITY += gallery
}

symbian {
#    DEFINES += Q_OS_S60V5

    contains(DEFINES, Q_OS_S60V5){
        DEPLOYMENTFOLDERS += folder_symbian1
        TARGET.UID3 = 0x2006CBED
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/epoc32/include/middleware
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/include/Qt
        HEADERS += src/qdeclarativepositionsource.h
        SOURCES += src/qdeclarativepositionsource.cpp
    } else {
        # Enables In-App Purchase API
        DEFINES += IN_APP_PURCHASE
        DEFINES += IN_APP_PURCHASE_DEBUG

        # Enables test mode for IAP
        #DEFINES += IA_PURCHASE_TEST_MODE
        contains(DEFINES, IN_APP_PURCHASE) {
            include(./qiap/in-app-purchase.pri)
        }

        DEPLOYMENTFOLDERS += folder_symbian3
        TARGET.UID3 = 0x2006622A
        CONFIG += qt-components
        MMP_RULES += "OPTION gcce -march=armv6 -mfpu=vfp -mfloat-abi=softfp -marm"
    }

    CONFIG += localize_deployment

    TARGET.CAPABILITY += \
        NetworkServices \
        SwEvent \
        LocalServices \
        ReadUserData \
        WriteUserData \
        ReadDeviceData \
        WriteDeviceData \
        Location \
        UserEnvironment
    TARGET.EPOCHEAPSIZE = 0x40000 0x4000000

    LIBS += \
        -lMgFetch -lbafl \#for Selecting Picture
        -lapgrfx -leikcore -lcone -lapmime \ #for Launching Browser
        -lServiceHandler -lnewservice \# and -lbafl for Camera
        -laknnotify -leiksrv \#for global notes

    DEFINES += QVIBRA

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment

    # Symbian have a different syntax
    DEFINES -= VER=\\\"$$VERSION\\\"
    DEFINES += VER=\"$$VERSION\"
}

OTHER_FILES += i18n/tbclient_*.ts \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

contains(DEFINES, QVIBRA): include(./QVibra/vibra.pri)

include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
