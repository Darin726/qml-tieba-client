/****************************************************************************
** Meta object code from reading C++ file 'downloadmanager.h'
**
** Created: Sun Sep 30 18:04:00 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../downloadmanager.h"
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'downloadmanager.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_DownloadManager[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       5,   74, // properties
       1,   94, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: signature, parameters, type, tag, flags
      17,   16,   16,   16, 0x05,
      32,   16,   16,   16, 0x05,
      50,   16,   16,   16, 0x05,

 // slots: signature, parameters, type, tag, flags
      78,   65,   16,   16, 0x0a,
     119,  115,  110,   16, 0x0a,
     151,  142,  110,   16, 0x0a,
     177,  171,   16,   16, 0x0a,
     197,   16,   16,   16, 0x2a,
     213,   16,   16,   16, 0x08,
     258,  233,   16,   16, 0x08,
     290,   16,   16,   16, 0x08,
     309,   16,   16,   16, 0x08,

 // properties: name, type, flags
     335,  329, 0x00495009,
     355,  349, (QMetaType::QReal << 24) | 0x00495001,
     368,  364, 0x02495001,
     382,  374, 0x0a095001,
     394,  374, 0x0a095001,

 // properties: notify_signal_id
       0,
       1,
       2,
       0,
       0,

 // enums: name, flags, count, data
     329, 0x0,    5,   98,

 // enum data: key, value
     406, uint(DownloadManager::Unsent),
     413, uint(DownloadManager::Opened),
     420, uint(DownloadManager::Loading),
     428, uint(DownloadManager::Done),
     433, uint(DownloadManager::Finished),

       0        // eod
};

static const char qt_meta_stringdata_DownloadManager[] = {
    "DownloadManager\0\0stateChanged()\0"
    "progressChanged()\0errorChanged()\0"
    "url,filename\0appendDownload(QString,QString)\0"
    "bool\0url\0existsRequest(QString)\0"
    "filename\0existsFile(QString)\0isAll\0"
    "abortDownload(bool)\0abortDownload()\0"
    "startNextDownload()\0bytesReceived,bytesTotal\0"
    "downloadProgress(qint64,qint64)\0"
    "downloadFinished()\0downloadReadyRead()\0"
    "State\0downloadState\0qreal\0progress\0"
    "int\0error\0QString\0currentFile\0errorString\0"
    "Unsent\0Opened\0Loading\0Done\0Finished\0"
};

const QMetaObject DownloadManager::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_DownloadManager,
      qt_meta_data_DownloadManager, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &DownloadManager::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *DownloadManager::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *DownloadManager::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_DownloadManager))
        return static_cast<void*>(const_cast< DownloadManager*>(this));
    return QObject::qt_metacast(_clname);
}

int DownloadManager::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: stateChanged(); break;
        case 1: progressChanged(); break;
        case 2: errorChanged(); break;
        case 3: appendDownload((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 4: { bool _r = existsRequest((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 5: { bool _r = existsFile((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 6: abortDownload((*reinterpret_cast< const bool(*)>(_a[1]))); break;
        case 7: abortDownload(); break;
        case 8: startNextDownload(); break;
        case 9: downloadProgress((*reinterpret_cast< qint64(*)>(_a[1])),(*reinterpret_cast< qint64(*)>(_a[2]))); break;
        case 10: downloadFinished(); break;
        case 11: downloadReadyRead(); break;
        default: ;
        }
        _id -= 12;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< State*>(_v) = state(); break;
        case 1: *reinterpret_cast< qreal*>(_v) = progress(); break;
        case 2: *reinterpret_cast< int*>(_v) = error(); break;
        case 3: *reinterpret_cast< QString*>(_v) = currentFile(); break;
        case 4: *reinterpret_cast< QString*>(_v) = errorString(); break;
        }
        _id -= 5;
    } else if (_c == QMetaObject::WriteProperty) {
        _id -= 5;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 5;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void DownloadManager::stateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void DownloadManager::progressChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void DownloadManager::errorChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}
QT_END_MOC_NAMESPACE
