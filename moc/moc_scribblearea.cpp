/****************************************************************************
** Meta object code from reading C++ file 'scribblearea.h'
**
** Created: Mon Oct 1 12:36:24 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../scribblearea.h"
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'scribblearea.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_ScribbleArea[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       3,   44, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: signature, parameters, type, tag, flags
      14,   13,   13,   13, 0x05,
      29,   13,   13,   13, 0x05,
      47,   13,   13,   13, 0x05,

 // methods: signature, parameters, type, tag, flags
      65,   13,   13,   13, 0x02,
      87,   78,   73,   13, 0x02,
     101,   78,   73,   13, 0x02,

 // properties: name, type, flags
     122,  115, 0x43495103,
     134,  128, (QMetaType::QReal << 24) | 0x00495103,
     143,   73, 0x01495103,

 // properties: notify_signal_id
       0,
       1,
       2,

       0        // eod
};

static const char qt_meta_stringdata_ScribbleArea[] = {
    "ScribbleArea\0\0colorChanged()\0"
    "penWidthChanged()\0modifiedChanged()\0"
    "clear()\0bool\0fileName\0open(QString)\0"
    "save(QString)\0QColor\0color\0qreal\0"
    "penWidth\0modified\0"
};

const QMetaObject ScribbleArea::staticMetaObject = {
    { &QDeclarativeItem::staticMetaObject, qt_meta_stringdata_ScribbleArea,
      qt_meta_data_ScribbleArea, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &ScribbleArea::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *ScribbleArea::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *ScribbleArea::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_ScribbleArea))
        return static_cast<void*>(const_cast< ScribbleArea*>(this));
    return QDeclarativeItem::qt_metacast(_clname);
}

int ScribbleArea::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDeclarativeItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: colorChanged(); break;
        case 1: penWidthChanged(); break;
        case 2: modifiedChanged(); break;
        case 3: clear(); break;
        case 4: { bool _r = open((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 5: { bool _r = save((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        default: ;
        }
        _id -= 6;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QColor*>(_v) = color(); break;
        case 1: *reinterpret_cast< qreal*>(_v) = penWidth(); break;
        case 2: *reinterpret_cast< bool*>(_v) = modified(); break;
        }
        _id -= 3;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setColor(*reinterpret_cast< QColor*>(_v)); break;
        case 1: setPenWidth(*reinterpret_cast< qreal*>(_v)); break;
        case 2: setModified(*reinterpret_cast< bool*>(_v)); break;
        }
        _id -= 3;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 3;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void ScribbleArea::colorChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void ScribbleArea::penWidthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void ScribbleArea::modifiedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}
QT_END_MOC_NAMESPACE
