/****************************************************************************
** Meta object code from reading C++ file 'utility.h'
**
** Created: Mon Oct 1 12:36:24 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../utility.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'utility.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Utility[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      14,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      15,    9,    8,    8, 0x05,

 // slots: signature, parameters, type, tag, flags
      37,   33,    8,    8, 0x0a,
      61,   33,    8,    8, 0x0a,
      86,   33,    8,    8, 0x0a,
     116,  108,    8,    8, 0x0a,
     150,  142,  134,    8, 0x0a,
     175,    8,  134,    8, 0x0a,
     198,  189,  134,    8, 0x0a,
     226,   33,  134,    8, 0x2a,
     246,    8,    8,    8, 0x0a,
     277,  266,    8,    8, 0x0a,
     308,  303,  134,    8, 0x0a,
     331,    8,  326,    8, 0x0a,
     344,    9,    8,    8, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_Utility[] = {
    "Utility\0\0error\0processError(int)\0url\0"
    "openURLDefault(QString)\0"
    "openFileDefault(QString)\0launchPlayer(QString)\0"
    "program\0startApp(QString)\0QString\0"
    "hexdata\0decodeGBKHex(QByteArray)\0"
    "choosePhoto()\0url,path\0"
    "savePixmap(QString,QString)\0"
    "savePixmap(QString)\0clearNetworkCache()\0"
    "type,cache\0setCache(QString,QString)\0"
    "type\0getCache(QString)\0bool\0clearCache()\0"
    "error(QProcess::ProcessError)\0"
};

const QMetaObject Utility::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Utility,
      qt_meta_data_Utility, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Utility::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Utility::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Utility::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Utility))
        return static_cast<void*>(const_cast< Utility*>(this));
    return QObject::qt_metacast(_clname);
}

int Utility::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: processError((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: openURLDefault((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: openFileDefault((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 3: launchPlayer((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 4: startApp((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: { QString _r = decodeGBKHex((*reinterpret_cast< const QByteArray(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 6: { QString _r = choosePhoto();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 7: { QString _r = savePixmap((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 8: { QString _r = savePixmap((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 9: clearNetworkCache(); break;
        case 10: setCache((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 11: { QString _r = getCache((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 12: { bool _r = clearCache();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 13: error((*reinterpret_cast< QProcess::ProcessError(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 14;
    }
    return _id;
}

// SIGNAL 0
void Utility::processError(int _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
