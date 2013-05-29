
message(In-App Purchase API enabled)

CONFIG += mobility
CONFIG += inapppurchase

QT     += core gui declarative

DEPENDPATH += ./qiap

SOURCES += qiap/drmfile_p.cpp
SOURCES +=
SOURCES += qiap/drmfile.cpp
SOURCES += qiap/qiap.cpp
SOURCES += qiap/qiap_p.cpp

HEADERS += qiap/drmfile_p.h
HEADERS +=
HEADERS += qiap/drmfile.h
HEADERS += qiap/qiap.h
HEADERS += qiap/qiap_p.h

LIBS += -lcaf  -lcafutils -lapmime

# IAP configuration
addConfigFiles.sources = ./iap/IAP_VARIANTID.txt
addConfigFiles.path = .
DEPLOYMENT += addConfigFiles

addDrm.sources = ./iap/data
addDrm.path = ./drm
DEPLOYMENT += addDrm

# For testing In-App Purchase without Nokia Store
contains(DEFINES, IA_PURCHASE_TEST_MODE) {
    message(In-App Purchase API in TEST_MODE)
    addConfigFiles.sources = ./iap/TEST_MODE.txt
    addConfigFiles.path = .
    DEPLOYMENT += addConfigFiles
}

debug: {
    MMP_RULES -= "PAGED"
    MMP_RULES += "UNPAGED"
}
