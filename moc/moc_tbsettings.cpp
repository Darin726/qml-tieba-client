/****************************************************************************
** Meta object code from reading C++ file 'tbsettings.h'
**
** Created: Mon Oct 1 12:36:23 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../tbsettings.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'tbsettings.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_TBSettings[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      19,   14, // methods
      22,  109, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      16,       // signalCount

 // signals: signature, parameters, type, tag, flags
      12,   11,   11,   11, 0x05,
      37,   11,   11,   11, 0x05,
      56,   11,   11,   11, 0x05,
      76,   11,   11,   11, 0x05,
      96,   11,   11,   11, 0x05,
     121,   11,   11,   11, 0x05,
     139,   11,   11,   11, 0x05,
     159,   11,   11,   11, 0x05,
     183,   11,   11,   11, 0x05,
     202,   11,   11,   11, 0x05,
     226,   11,   11,   11, 0x05,
     245,   11,   11,   11, 0x05,
     271,   11,   11,   11, 0x05,
     294,   11,   11,   11, 0x05,
     319,   11,   11,   11, 0x05,
     339,   11,   11,   11, 0x05,

 // slots: signature, parameters, type, tag, flags
     357,   11,   11,   11, 0x0a,
     372,   11,   11,   11, 0x0a,
     380,   11,   11,   11, 0x0a,

 // properties: name, type, flags
     401,  397, 0x02495103,
     422,  417, 0x01495103,
     432,  417, 0x01495103,
     443,  417, 0x01495103,
     459,  454, 0x11495103,
     475,  397, 0x02495103,
     484,  397, 0x02495103,
     495,  397, 0x02495103,
     518,  510, 0x0a495103,
     528,  417, 0x01495103,
     543,  510, 0x0a495103,
     553,  417, 0x01495103,
     570,  417, 0x01495103,
     584,  417, 0x01495103,
     600,  417, 0x01495103,
     611,  510, 0x0a495103,
     620,  510, 0x0a095401,
     631,  510, 0x0a095001,
     636,  510, 0x0a095001,
     650,  510, 0x0a095001,
     655,  510, 0x0a095001,
     663,  510, 0x0a095001,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,
       4,
       5,
       6,
       7,
       8,
       9,
      10,
      11,
      12,
      13,
      14,
      15,
       0,
       0,
       0,
       0,
       0,
       0,

       0        // eod
};

static const char qt_meta_stringdata_TBSettings[] = {
    "TBSettings\0\0remindFrequencyChanged()\0"
    "showImageChanged()\0showAvatarChanged()\0"
    "whiteThemeChanged()\0backgroundImageChanged()\0"
    "fontSizeChanged()\0clientTypeChanged()\0"
    "maxThreadCountChanged()\0defaultIdChanged()\0"
    "openWithSystemChanged()\0imagePathChanged()\0"
    "splitScreenInputChanged()\0"
    "remindNewFansChanged()\0remindReplyToMeChanged()\0"
    "remindAtMeChanged()\0signTextChanged()\0"
    "saveSettings()\0clear()\0resetImagePath()\0"
    "int\0remindFrequency\0bool\0showImage\0"
    "showAvatar\0whiteTheme\0QUrl\0backgroundImage\0"
    "fontSize\0clientType\0maxThreadCount\0"
    "QString\0defaultId\0openWithSystem\0"
    "imagePath\0splitScreenInput\0remindNewFans\0"
    "remindReplyToMe\0remindAtMe\0signText\0"
    "appVersion\0host\0clientVersion\0from\0"
    "netType\0imei\0"
};

const QMetaObject TBSettings::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_TBSettings,
      qt_meta_data_TBSettings, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &TBSettings::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *TBSettings::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *TBSettings::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_TBSettings))
        return static_cast<void*>(const_cast< TBSettings*>(this));
    return QObject::qt_metacast(_clname);
}

int TBSettings::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: remindFrequencyChanged(); break;
        case 1: showImageChanged(); break;
        case 2: showAvatarChanged(); break;
        case 3: whiteThemeChanged(); break;
        case 4: backgroundImageChanged(); break;
        case 5: fontSizeChanged(); break;
        case 6: clientTypeChanged(); break;
        case 7: maxThreadCountChanged(); break;
        case 8: defaultIdChanged(); break;
        case 9: openWithSystemChanged(); break;
        case 10: imagePathChanged(); break;
        case 11: splitScreenInputChanged(); break;
        case 12: remindNewFansChanged(); break;
        case 13: remindReplyToMeChanged(); break;
        case 14: remindAtMeChanged(); break;
        case 15: signTextChanged(); break;
        case 16: saveSettings(); break;
        case 17: clear(); break;
        case 18: resetImagePath(); break;
        default: ;
        }
        _id -= 19;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = remindFrequency(); break;
        case 1: *reinterpret_cast< bool*>(_v) = showImage(); break;
        case 2: *reinterpret_cast< bool*>(_v) = showAvatar(); break;
        case 3: *reinterpret_cast< bool*>(_v) = whiteTheme(); break;
        case 4: *reinterpret_cast< QUrl*>(_v) = backgroundImage(); break;
        case 5: *reinterpret_cast< int*>(_v) = fontSize(); break;
        case 6: *reinterpret_cast< int*>(_v) = clientType(); break;
        case 7: *reinterpret_cast< int*>(_v) = maxThreadCount(); break;
        case 8: *reinterpret_cast< QString*>(_v) = defaultId(); break;
        case 9: *reinterpret_cast< bool*>(_v) = openWithSystem(); break;
        case 10: *reinterpret_cast< QString*>(_v) = imagePath(); break;
        case 11: *reinterpret_cast< bool*>(_v) = splitScreenInput(); break;
        case 12: *reinterpret_cast< bool*>(_v) = remindNewFans(); break;
        case 13: *reinterpret_cast< bool*>(_v) = remindReplyToMe(); break;
        case 14: *reinterpret_cast< bool*>(_v) = remindAtMe(); break;
        case 15: *reinterpret_cast< QString*>(_v) = signText(); break;
        case 16: *reinterpret_cast< QString*>(_v) = appVersion(); break;
        case 17: *reinterpret_cast< QString*>(_v) = host(); break;
        case 18: *reinterpret_cast< QString*>(_v) = clientVersion(); break;
        case 19: *reinterpret_cast< QString*>(_v) = from(); break;
        case 20: *reinterpret_cast< QString*>(_v) = netType(); break;
        case 21: *reinterpret_cast< QString*>(_v) = imei(); break;
        }
        _id -= 22;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setRemindFrequency(*reinterpret_cast< int*>(_v)); break;
        case 1: setShowImage(*reinterpret_cast< bool*>(_v)); break;
        case 2: setShowAvatar(*reinterpret_cast< bool*>(_v)); break;
        case 3: setWhiteTheme(*reinterpret_cast< bool*>(_v)); break;
        case 4: setBackgroundImage(*reinterpret_cast< QUrl*>(_v)); break;
        case 5: setFontSize(*reinterpret_cast< int*>(_v)); break;
        case 6: setClientType(*reinterpret_cast< int*>(_v)); break;
        case 7: setMaxThreadCount(*reinterpret_cast< int*>(_v)); break;
        case 8: setDefaultId(*reinterpret_cast< QString*>(_v)); break;
        case 9: setOpenWithSystem(*reinterpret_cast< bool*>(_v)); break;
        case 10: setImagePath(*reinterpret_cast< QString*>(_v)); break;
        case 11: setSplitScreenInput(*reinterpret_cast< bool*>(_v)); break;
        case 12: setRemindNewFans(*reinterpret_cast< bool*>(_v)); break;
        case 13: setRemindReplyToMe(*reinterpret_cast< bool*>(_v)); break;
        case 14: setRemindAtMe(*reinterpret_cast< bool*>(_v)); break;
        case 15: setSignText(*reinterpret_cast< QString*>(_v)); break;
        }
        _id -= 22;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 22;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 22;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 22;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 22;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 22;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 22;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void TBSettings::remindFrequencyChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void TBSettings::showImageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void TBSettings::showAvatarChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void TBSettings::whiteThemeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void TBSettings::backgroundImageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, 0);
}

// SIGNAL 5
void TBSettings::fontSizeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, 0);
}

// SIGNAL 6
void TBSettings::clientTypeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, 0);
}

// SIGNAL 7
void TBSettings::maxThreadCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, 0);
}

// SIGNAL 8
void TBSettings::defaultIdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, 0);
}

// SIGNAL 9
void TBSettings::openWithSystemChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, 0);
}

// SIGNAL 10
void TBSettings::imagePathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, 0);
}

// SIGNAL 11
void TBSettings::splitScreenInputChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, 0);
}

// SIGNAL 12
void TBSettings::remindNewFansChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 12, 0);
}

// SIGNAL 13
void TBSettings::remindReplyToMeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 13, 0);
}

// SIGNAL 14
void TBSettings::remindAtMeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 14, 0);
}

// SIGNAL 15
void TBSettings::signTextChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 15, 0);
}
QT_END_MOC_NAMESPACE
