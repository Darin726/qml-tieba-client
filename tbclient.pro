folder_01.source = qml/tbclient
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

VERSION = 0.7.3
VERSTR = '\\"$${VERSION}\\"'
DEFINES += VER=\"$${VERSTR}\"

CONFIG += qt-components mobility
MOBILITY += systeminfo
QT += network webkit

symbian {
    TARGET = tbclient
    TARGET.UID3 = 0x2006622A
    TARGET.CAPABILITY += NetworkServices SwEvent LocalServices ReadDeviceData

    TARGET.EPOCHEAPSIZE = 0x20000 0x4000000 #64MB

    LIBS += -lapgrfx -leikcore -lcone -lapmime -lavkon -lMgFetch -lbafl

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo

    DEPLOYMENT += my_deployment

    MMP_RULES += "OPTION gcce -march=armv6"
    MMP_RULES += "OPTION gcce -mfpu=vfp"
    MMP_RULES += "OPTION gcce -mfloat-abi=softfp"
    MMP_RULES += "OPTION gcce -marm"
}

SOURCES += main.cpp \
    utility.cpp \
    tbsettings.cpp \
    tbnetworkaccessmanagerfactory.cpp \
    scribblearea.cpp \
    httpuploader.cpp \
    downloadmanager.cpp \
    customwebview.cpp

HEADERS += \
    utility.h \
    tbsettings.h \
    tbnetworkaccessmanagerfactory.h \
    scribblearea.h \
    httpuploader.h \
    downloadmanager.h \
    customwebview.h

RESOURCES += source.qrc

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
