/****************************************************************************
** Meta object code from reading C++ file 'httpuploader.h'
**
** Created: Sun Sep 30 18:04:04 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../httpuploader.h"
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'httpuploader.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_HttpPostField[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       3,   24, // properties
       1,   36, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      15,   14,   14,   14, 0x05,
      29,   14,   14,   14, 0x05,

 // properties: name, type, flags
      60,   52, 0x0a495103,
      75,   65, 0x00095c09,
      84,   80, 0x02495001,

 // properties: notify_signal_id
       0,
       0,
       1,

 // enums: name, flags, count, data
      65, 0x0,    3,   40,

 // enum data: key, value
      98, uint(HttpPostField::FieldInvalid),
     111, uint(HttpPostField::FieldValue),
     122, uint(HttpPostField::FieldFile),

       0        // eod
};

static const char qt_meta_stringdata_HttpPostField[] = {
    "HttpPostField\0\0nameChanged()\0"
    "contentLengthChanged()\0QString\0name\0"
    "FieldType\0type\0int\0contentLength\0"
    "FieldInvalid\0FieldValue\0FieldFile\0"
};

const QMetaObject HttpPostField::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_HttpPostField,
      qt_meta_data_HttpPostField, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &HttpPostField::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *HttpPostField::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *HttpPostField::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_HttpPostField))
        return static_cast<void*>(const_cast< HttpPostField*>(this));
    return QObject::qt_metacast(_clname);
}

int HttpPostField::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: nameChanged(); break;
        case 1: contentLengthChanged(); break;
        default: ;
        }
        _id -= 2;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = name(); break;
        case 1: *reinterpret_cast< FieldType*>(_v) = type(); break;
        case 2: *reinterpret_cast< int*>(_v) = contentLength(); break;
        }
        _id -= 3;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setName(*reinterpret_cast< QString*>(_v)); break;
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
void HttpPostField::nameChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void HttpPostField::contentLengthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}
static const uint qt_meta_data_HttpPostFieldValue[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       1,   19, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      20,   19,   19,   19, 0x05,

 // properties: name, type, flags
      43,   35, 0x0a495103,

 // properties: notify_signal_id
       0,

       0        // eod
};

static const char qt_meta_stringdata_HttpPostFieldValue[] = {
    "HttpPostFieldValue\0\0valueChanged()\0"
    "QString\0value\0"
};

const QMetaObject HttpPostFieldValue::staticMetaObject = {
    { &HttpPostField::staticMetaObject, qt_meta_stringdata_HttpPostFieldValue,
      qt_meta_data_HttpPostFieldValue, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &HttpPostFieldValue::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *HttpPostFieldValue::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *HttpPostFieldValue::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_HttpPostFieldValue))
        return static_cast<void*>(const_cast< HttpPostFieldValue*>(this));
    return HttpPostField::qt_metacast(_clname);
}

int HttpPostFieldValue::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = HttpPostField::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: valueChanged(); break;
        default: ;
        }
        _id -= 1;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = value(); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setValue(*reinterpret_cast< QString*>(_v)); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void HttpPostFieldValue::valueChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}
static const uint qt_meta_data_HttpPostFieldFile[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       2,   24, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      19,   18,   18,   18, 0x05,
      35,   18,   18,   18, 0x05,

 // properties: name, type, flags
      58,   53, 0x11495103,
      73,   65, 0x0a495103,

 // properties: notify_signal_id
       0,
       1,

       0        // eod
};

static const char qt_meta_stringdata_HttpPostFieldFile[] = {
    "HttpPostFieldFile\0\0sourceChanged()\0"
    "mimeTypeChanged()\0QUrl\0source\0QString\0"
    "mimeType\0"
};

const QMetaObject HttpPostFieldFile::staticMetaObject = {
    { &HttpPostField::staticMetaObject, qt_meta_stringdata_HttpPostFieldFile,
      qt_meta_data_HttpPostFieldFile, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &HttpPostFieldFile::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *HttpPostFieldFile::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *HttpPostFieldFile::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_HttpPostFieldFile))
        return static_cast<void*>(const_cast< HttpPostFieldFile*>(this));
    return HttpPostField::qt_metacast(_clname);
}

int HttpPostFieldFile::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = HttpPostField::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: sourceChanged(); break;
        case 1: mimeTypeChanged(); break;
        default: ;
        }
        _id -= 2;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QUrl*>(_v) = source(); break;
        case 1: *reinterpret_cast< QString*>(_v) = mimeType(); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setSource(*reinterpret_cast< QUrl*>(_v)); break;
        case 1: setMimeType(*reinterpret_cast< QString*>(_v)); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 2;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void HttpPostFieldFile::sourceChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void HttpPostFieldFile::mimeTypeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}
static const uint qt_meta_data_HttpUploader[] = {

 // content:
       5,       // revision
       0,       // classname
       1,   14, // classinfo
      14,   16, // methods
       7,   86, // properties
       1,  114, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // classinfo: key, value
      24,   13,

 // signals: signature, parameters, type, tag, flags
      41,   40,   40,   40, 0x05,
      54,   40,   40,   40, 0x05,
      72,   40,   40,   40, 0x05,
      87,   40,   40,   40, 0x05,

 // slots: signature, parameters, type, tag, flags
     103,   40,   40,   40, 0x0a,
     115,  111,   40,   40, 0x0a,
     126,   40,   40,   40, 0x0a,
     142,  133,   40,   40, 0x0a,
     160,   40,   40,   40, 0x0a,
     189,  168,   40,   40, 0x0a,
     243,  215,   40,   40, 0x0a,
     295,  276,   40,   40, 0x2a,
     320,   40,   40,   40, 0x08,
     358,  337,   40,   40, 0x08,

 // properties: name, type, flags
     111,  388, 0x11495103,
      13,  393, 0x00095009,
     439,  433, (QMetaType::QReal << 24) | 0x00495001,
     454,  448, 0x00495009,
     470,  466, 0x02495001,
     485,  477, 0x0a095001,
     497,  477, 0x0a095001,

 // properties: notify_signal_id
       0,
       0,
       1,
       2,
       3,
       0,
       0,

 // enums: name, flags, count, data
     448, 0x0,    5,  118,

 // enum data: key, value
     510, uint(HttpUploader::Unsent),
     517, uint(HttpUploader::Opened),
     524, uint(HttpUploader::Loading),
     532, uint(HttpUploader::Aborting),
     541, uint(HttpUploader::Done),

       0        // eod
};

static const char qt_meta_stringdata_HttpUploader[] = {
    "HttpUploader\0postFields\0DefaultProperty\0"
    "\0urlChanged()\0progressChanged()\0"
    "stateChanged()\0statusChanged()\0clear()\0"
    "url\0open(QUrl)\0send()\0fileName\0"
    "sendFile(QString)\0abort()\0"
    "fieldName,fieldValue\0addField(QString,QString)\0"
    "fieldName,fileName,mimeType\0"
    "addFile(QString,QString,QString)\0"
    "fieldName,fileName\0addFile(QString,QString)\0"
    "reply_finished()\0bytesSent,bytesTotal\0"
    "uploadProgress(qint64,qint64)\0QUrl\0"
    "QDeclarativeListProperty<HttpPostField>\0"
    "qreal\0progress\0State\0uploadState\0int\0"
    "status\0QString\0errorString\0responseText\0"
    "Unsent\0Opened\0Loading\0Aborting\0Done\0"
};

const QMetaObject HttpUploader::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_HttpUploader,
      qt_meta_data_HttpUploader, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &HttpUploader::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *HttpUploader::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *HttpUploader::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_HttpUploader))
        return static_cast<void*>(const_cast< HttpUploader*>(this));
    if (!strcmp(_clname, "QDeclarativeParserStatus"))
        return static_cast< QDeclarativeParserStatus*>(const_cast< HttpUploader*>(this));
    if (!strcmp(_clname, "com.trolltech.qml.QDeclarativeParserStatus"))
        return static_cast< QDeclarativeParserStatus*>(const_cast< HttpUploader*>(this));
    return QObject::qt_metacast(_clname);
}

int HttpUploader::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: urlChanged(); break;
        case 1: progressChanged(); break;
        case 2: stateChanged(); break;
        case 3: statusChanged(); break;
        case 4: clear(); break;
        case 5: open((*reinterpret_cast< const QUrl(*)>(_a[1]))); break;
        case 6: send(); break;
        case 7: sendFile((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 8: abort(); break;
        case 9: addField((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 10: addFile((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])),(*reinterpret_cast< const QString(*)>(_a[3]))); break;
        case 11: addFile((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 12: reply_finished(); break;
        case 13: uploadProgress((*reinterpret_cast< qint64(*)>(_a[1])),(*reinterpret_cast< qint64(*)>(_a[2]))); break;
        default: ;
        }
        _id -= 14;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QUrl*>(_v) = url(); break;
        case 1: *reinterpret_cast< QDeclarativeListProperty<HttpPostField>*>(_v) = postFields(); break;
        case 2: *reinterpret_cast< qreal*>(_v) = progress(); break;
        case 3: *reinterpret_cast< State*>(_v) = state(); break;
        case 4: *reinterpret_cast< int*>(_v) = status(); break;
        case 5: *reinterpret_cast< QString*>(_v) = errorString(); break;
        case 6: *reinterpret_cast< QString*>(_v) = responseText(); break;
        }
        _id -= 7;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setUrl(*reinterpret_cast< QUrl*>(_v)); break;
        }
        _id -= 7;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 7;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void HttpUploader::urlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void HttpUploader::progressChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void HttpUploader::stateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void HttpUploader::statusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}
QT_END_MOC_NAMESPACE
