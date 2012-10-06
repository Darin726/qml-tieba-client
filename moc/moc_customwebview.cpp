/****************************************************************************
** Meta object code from reading C++ file 'customwebview.h'
**
** Created: Mon Oct 1 12:36:26 2012
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../customwebview.h"
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'customwebview.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_QDeclarativeWebPage[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

       0        // eod
};

static const char qt_meta_stringdata_QDeclarativeWebPage[] = {
    "QDeclarativeWebPage\0"
};

const QMetaObject QDeclarativeWebPage::staticMetaObject = {
    { &QWebPage::staticMetaObject, qt_meta_stringdata_QDeclarativeWebPage,
      qt_meta_data_QDeclarativeWebPage, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &QDeclarativeWebPage::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *QDeclarativeWebPage::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *QDeclarativeWebPage::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_QDeclarativeWebPage))
        return static_cast<void*>(const_cast< QDeclarativeWebPage*>(this));
    return QWebPage::qt_metacast(_clname);
}

int QDeclarativeWebPage::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWebPage::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
static const uint qt_meta_data_GraphicsWebView[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      31,   17,   16,   16, 0x05,

       0        // eod
};

static const char qt_meta_stringdata_GraphicsWebView[] = {
    "GraphicsWebView\0\0clickX,clickY\0"
    "doubleClick(int,int)\0"
};

const QMetaObject GraphicsWebView::staticMetaObject = {
    { &QGraphicsWebView::staticMetaObject, qt_meta_stringdata_GraphicsWebView,
      qt_meta_data_GraphicsWebView, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &GraphicsWebView::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *GraphicsWebView::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *GraphicsWebView::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_GraphicsWebView))
        return static_cast<void*>(const_cast< GraphicsWebView*>(this));
    return QGraphicsWebView::qt_metacast(_clname);
}

int GraphicsWebView::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QGraphicsWebView::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: doubleClick((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}

// SIGNAL 0
void GraphicsWebView::doubleClick(int _t1, int _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
static const uint qt_meta_data_QDeclarativeWebView[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      34,   14, // methods
      21,  184, // properties
       1,  268, // enums/sets
       0,    0, // constructors
       0,       // flags
      22,       // signalCount

 // signals: signature, parameters, type, tag, flags
      21,   20,   20,   20, 0x05,
      45,   20,   20,   20, 0x05,
      70,   20,   20,   20, 0x05,
      83,   20,   20,   20, 0x05,
     101,   20,   20,   20, 0x05,
     123,   20,   20,   20, 0x05,
     145,   20,   20,   20, 0x05,
     159,   20,   20,   20, 0x05,
     179,   20,   20,   20, 0x05,
     193,   20,   20,   20, 0x05,
     216,   20,   20,   20, 0x05,
     244,   20,   20,   20, 0x05,
     269,   20,   20,   20, 0x05,
     295,   20,   20,   20, 0x05,
     322,   20,   20,   20, 0x05,
     345,   20,   20,   20, 0x05,
     359,   20,   20,   20, 0x05,
     374,   20,   20,   20, 0x05,
     401,  387,   20,   20, 0x05,
     443,  422,   20,   20, 0x05,
     473,  465,   20,   20, 0x05,
     493,  488,   20,   20, 0x05,

 // slots: signature, parameters, type, tag, flags
     520,   20,  511,   20, 0x0a,
     548,   20,   20,   20, 0x08,
     566,  564,   20,   20, 0x08,
     589,  586,   20,   20, 0x08,
     610,   20,   20,   20, 0x08,
     633,   20,   20,   20, 0x08,
     655,   20,   20,   20, 0x08,
     672,   20,   20,   20, 0x08,
     688,   20,   20,   20, 0x08,
     743,  719,   20,   20, 0x08,
     800,  795,  774,   20, 0x08,

 // methods: signature, parameters, type, tag, flags
     865,  843,  838,   20, 0x02,

 // properties: name, type, flags
     902,  894, 0x0a495001,
     916,  908, 0x41495001,
     921,  894, 0x0a495001,
     932,  894, 0x0a495103,
     941,  937, 0x02495103,
     955,  937, 0x02495103,
     970,  937, 0x02495103,
     991,  986, 0x11495103,
    1001,  995, (QMetaType::QReal << 24) | 0x00495001,
    1017, 1010, 0x00495009,
    1033, 1024, 0x00095409,
    1040, 1024, 0x00095409,
    1045, 1024, 0x00095409,
    1053, 1024, 0x00095409,
    1083, 1058, 0x00095409,
    1126, 1092, 0x00095409,
    1173, 1150, 0x0049510b,
    1210, 1192, 0x0049510b,
    1226,  838, 0x01495103,
    1249, 1243, 0x15495001,
    1262,  995, (QMetaType::QReal << 24) | 0x00495103,

 // properties: notify_signal_id
       5,
       6,
       7,
       8,
       9,
       0,
       1,
       2,
       3,
       4,
       0,
       0,
       0,
       0,
       0,
       0,
      10,
      11,
      12,
      13,
      14,

 // enums: name, flags, count, data
    1010, 0x0,    4,  272,

 // enum data: key, value
    1276, uint(QDeclarativeWebView::Null),
    1281, uint(QDeclarativeWebView::Ready),
    1287, uint(QDeclarativeWebView::Loading),
    1295, uint(QDeclarativeWebView::Error),

       0        // eod
};

static const char qt_meta_stringdata_QDeclarativeWebView[] = {
    "QDeclarativeWebView\0\0preferredWidthChanged()\0"
    "preferredHeightChanged()\0urlChanged()\0"
    "progressChanged()\0statusChanged(Status)\0"
    "titleChanged(QString)\0iconChanged()\0"
    "statusTextChanged()\0htmlChanged()\0"
    "pressGrabTimeChanged()\0"
    "newWindowComponentChanged()\0"
    "newWindowParentChanged()\0"
    "renderingEnabledChanged()\0"
    "contentsSizeChanged(QSize)\0"
    "contentsScaleChanged()\0loadStarted()\0"
    "loadFinished()\0loadFailed()\0clickX,clickY\0"
    "doubleClick(int,int)\0zoom,centerX,centerY\0"
    "zoomTo(qreal,int,int)\0message\0"
    "alert(QString)\0link\0linkClicked(QUrl)\0"
    "QVariant\0evaluateJavaScript(QString)\0"
    "doLoadStarted()\0p\0doLoadProgress(int)\0"
    "ok\0doLoadFinished(bool)\0setStatusText(QString)\0"
    "windowObjectCleared()\0pageUrlChanged()\0"
    "initialLayout()\0updateDeclarativeWebViewSize()\0"
    "newGeometry,oldGeometry\0"
    "geometryChanged(QRectF,QRectF)\0"
    "QDeclarativeWebView*\0type\0"
    "createWindow(QWebPage::WebWindowType)\0"
    "bool\0clickX,clickY,maxzoom\0"
    "heuristicZoom(int,int,qreal)\0QString\0"
    "title\0QPixmap\0icon\0statusText\0html\0"
    "int\0pressGrabTime\0preferredWidth\0"
    "preferredHeight\0QUrl\0url\0qreal\0progress\0"
    "Status\0status\0QAction*\0reload\0back\0"
    "forward\0stop\0QDeclarativeWebSettings*\0"
    "settings\0QDeclarativeListProperty<QObject>\0"
    "javaScriptWindowObjects\0QDeclarativeComponent*\0"
    "newWindowComponent\0QDeclarativeItem*\0"
    "newWindowParent\0renderingEnabled\0QSize\0"
    "contentsSize\0contentsScale\0Null\0Ready\0"
    "Loading\0Error\0"
};

const QMetaObject QDeclarativeWebView::staticMetaObject = {
    { &QDeclarativeItem::staticMetaObject, qt_meta_stringdata_QDeclarativeWebView,
      qt_meta_data_QDeclarativeWebView, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &QDeclarativeWebView::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *QDeclarativeWebView::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *QDeclarativeWebView::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_QDeclarativeWebView))
        return static_cast<void*>(const_cast< QDeclarativeWebView*>(this));
    return QDeclarativeItem::qt_metacast(_clname);
}

int QDeclarativeWebView::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDeclarativeItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: preferredWidthChanged(); break;
        case 1: preferredHeightChanged(); break;
        case 2: urlChanged(); break;
        case 3: progressChanged(); break;
        case 4: statusChanged((*reinterpret_cast< Status(*)>(_a[1]))); break;
        case 5: titleChanged((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: iconChanged(); break;
        case 7: statusTextChanged(); break;
        case 8: htmlChanged(); break;
        case 9: pressGrabTimeChanged(); break;
        case 10: newWindowComponentChanged(); break;
        case 11: newWindowParentChanged(); break;
        case 12: renderingEnabledChanged(); break;
        case 13: contentsSizeChanged((*reinterpret_cast< const QSize(*)>(_a[1]))); break;
        case 14: contentsScaleChanged(); break;
        case 15: loadStarted(); break;
        case 16: loadFinished(); break;
        case 17: loadFailed(); break;
        case 18: doubleClick((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 19: zoomTo((*reinterpret_cast< qreal(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 20: alert((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 21: linkClicked((*reinterpret_cast< const QUrl(*)>(_a[1]))); break;
        case 22: { QVariant _r = evaluateJavaScript((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 23: doLoadStarted(); break;
        case 24: doLoadProgress((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 25: doLoadFinished((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 26: setStatusText((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 27: windowObjectCleared(); break;
        case 28: pageUrlChanged(); break;
        case 29: initialLayout(); break;
        case 30: updateDeclarativeWebViewSize(); break;
        case 31: geometryChanged((*reinterpret_cast< const QRectF(*)>(_a[1])),(*reinterpret_cast< const QRectF(*)>(_a[2]))); break;
        case 32: { QDeclarativeWebView* _r = createWindow((*reinterpret_cast< QWebPage::WebWindowType(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QDeclarativeWebView**>(_a[0]) = _r; }  break;
        case 33: { bool _r = heuristicZoom((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< qreal(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        default: ;
        }
        _id -= 34;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = title(); break;
        case 1: *reinterpret_cast< QPixmap*>(_v) = icon(); break;
        case 2: *reinterpret_cast< QString*>(_v) = statusText(); break;
        case 3: *reinterpret_cast< QString*>(_v) = html(); break;
        case 4: *reinterpret_cast< int*>(_v) = pressGrabTime(); break;
        case 5: *reinterpret_cast< int*>(_v) = preferredWidth(); break;
        case 6: *reinterpret_cast< int*>(_v) = preferredHeight(); break;
        case 7: *reinterpret_cast< QUrl*>(_v) = url(); break;
        case 8: *reinterpret_cast< qreal*>(_v) = progress(); break;
        case 9: *reinterpret_cast< Status*>(_v) = status(); break;
        case 10: *reinterpret_cast< QAction**>(_v) = reloadAction(); break;
        case 11: *reinterpret_cast< QAction**>(_v) = backAction(); break;
        case 12: *reinterpret_cast< QAction**>(_v) = forwardAction(); break;
        case 13: *reinterpret_cast< QAction**>(_v) = stopAction(); break;
        case 14: *reinterpret_cast< QDeclarativeWebSettings**>(_v) = settingsObject(); break;
        case 15: *reinterpret_cast< QDeclarativeListProperty<QObject>*>(_v) = javaScriptWindowObjects(); break;
        case 16: *reinterpret_cast< QDeclarativeComponent**>(_v) = newWindowComponent(); break;
        case 17: *reinterpret_cast< QDeclarativeItem**>(_v) = newWindowParent(); break;
        case 18: *reinterpret_cast< bool*>(_v) = renderingEnabled(); break;
        case 19: *reinterpret_cast< QSize*>(_v) = contentsSize(); break;
        case 20: *reinterpret_cast< qreal*>(_v) = contentsScale(); break;
        }
        _id -= 21;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 3: setHtml(*reinterpret_cast< QString*>(_v)); break;
        case 4: setPressGrabTime(*reinterpret_cast< int*>(_v)); break;
        case 5: setPreferredWidth(*reinterpret_cast< int*>(_v)); break;
        case 6: setPreferredHeight(*reinterpret_cast< int*>(_v)); break;
        case 7: setUrl(*reinterpret_cast< QUrl*>(_v)); break;
        case 16: setNewWindowComponent(*reinterpret_cast< QDeclarativeComponent**>(_v)); break;
        case 17: setNewWindowParent(*reinterpret_cast< QDeclarativeItem**>(_v)); break;
        case 18: setRenderingEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 20: setContentsScale(*reinterpret_cast< qreal*>(_v)); break;
        }
        _id -= 21;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 21;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 21;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 21;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 21;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 21;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 21;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void QDeclarativeWebView::preferredWidthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void QDeclarativeWebView::preferredHeightChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void QDeclarativeWebView::urlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void QDeclarativeWebView::progressChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void QDeclarativeWebView::statusChanged(Status _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}

// SIGNAL 5
void QDeclarativeWebView::titleChanged(const QString & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void QDeclarativeWebView::iconChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, 0);
}

// SIGNAL 7
void QDeclarativeWebView::statusTextChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, 0);
}

// SIGNAL 8
void QDeclarativeWebView::htmlChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, 0);
}

// SIGNAL 9
void QDeclarativeWebView::pressGrabTimeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, 0);
}

// SIGNAL 10
void QDeclarativeWebView::newWindowComponentChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, 0);
}

// SIGNAL 11
void QDeclarativeWebView::newWindowParentChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, 0);
}

// SIGNAL 12
void QDeclarativeWebView::renderingEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 12, 0);
}

// SIGNAL 13
void QDeclarativeWebView::contentsSizeChanged(const QSize & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 13, _a);
}

// SIGNAL 14
void QDeclarativeWebView::contentsScaleChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 14, 0);
}

// SIGNAL 15
void QDeclarativeWebView::loadStarted()
{
    QMetaObject::activate(this, &staticMetaObject, 15, 0);
}

// SIGNAL 16
void QDeclarativeWebView::loadFinished()
{
    QMetaObject::activate(this, &staticMetaObject, 16, 0);
}

// SIGNAL 17
void QDeclarativeWebView::loadFailed()
{
    QMetaObject::activate(this, &staticMetaObject, 17, 0);
}

// SIGNAL 18
void QDeclarativeWebView::doubleClick(int _t1, int _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 18, _a);
}

// SIGNAL 19
void QDeclarativeWebView::zoomTo(qreal _t1, int _t2, int _t3)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 19, _a);
}

// SIGNAL 20
void QDeclarativeWebView::alert(const QString & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 20, _a);
}

// SIGNAL 21
void QDeclarativeWebView::linkClicked(const QUrl & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 21, _a);
}
static const uint qt_meta_data_QDeclarativeWebViewAttached[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       1,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // properties: name, type, flags
      36,   28, 0x0a095103,

       0        // eod
};

static const char qt_meta_stringdata_QDeclarativeWebViewAttached[] = {
    "QDeclarativeWebViewAttached\0QString\0"
    "windowObjectName\0"
};

const QMetaObject QDeclarativeWebViewAttached::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_QDeclarativeWebViewAttached,
      qt_meta_data_QDeclarativeWebViewAttached, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &QDeclarativeWebViewAttached::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *QDeclarativeWebViewAttached::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *QDeclarativeWebViewAttached::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_QDeclarativeWebViewAttached))
        return static_cast<void*>(const_cast< QDeclarativeWebViewAttached*>(this));
    return QObject::qt_metacast(_clname);
}

int QDeclarativeWebViewAttached::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    
#ifndef QT_NO_PROPERTIES
     if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = windowObjectName(); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setWindowObjectName(*reinterpret_cast< QString*>(_v)); break;
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
static const uint qt_meta_data_QDeclarativeWebSettings[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
      25,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // properties: name, type, flags
      32,   24, 0x0a095103,
      51,   24, 0x0a095103,
      67,   24, 0x0a095103,
      83,   24, 0x0a095103,
     103,   24, 0x0a095103,
     121,   24, 0x0a095103,
     143,  139, 0x02095103,
     159,  139, 0x02095103,
     182,  139, 0x02095103,
     198,  139, 0x02095103,
     224,  219, 0x01095103,
     239,  219, 0x01095103,
     257,  219, 0x01095103,
     269,  219, 0x01095103,
     284,  219, 0x01095103,
     307,  219, 0x01095103,
     332,  219, 0x01095103,
     361,  219, 0x01095103,
     384,  219, 0x01095103,
     410,  219, 0x01095103,
     423,  219, 0x01095103,
     447,  219, 0x01095103,
     477,  219, 0x01095103,
     511,  219, 0x01095103,
     539,  219, 0x01095103,

       0        // eod
};

static const char qt_meta_stringdata_QDeclarativeWebSettings[] = {
    "QDeclarativeWebSettings\0QString\0"
    "standardFontFamily\0fixedFontFamily\0"
    "serifFontFamily\0sansSerifFontFamily\0"
    "cursiveFontFamily\0fantasyFontFamily\0"
    "int\0minimumFontSize\0minimumLogicalFontSize\0"
    "defaultFontSize\0defaultFixedFontSize\0"
    "bool\0autoLoadImages\0javascriptEnabled\0"
    "javaEnabled\0pluginsEnabled\0"
    "privateBrowsingEnabled\0javascriptCanOpenWindows\0"
    "javascriptCanAccessClipboard\0"
    "developerExtrasEnabled\0linksIncludedInFocusChain\0"
    "zoomTextOnly\0printElementBackgrounds\0"
    "offlineStorageDatabaseEnabled\0"
    "offlineWebApplicationCacheEnabled\0"
    "localStorageDatabaseEnabled\0"
    "localContentCanAccessRemoteUrls\0"
};

const QMetaObject QDeclarativeWebSettings::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_QDeclarativeWebSettings,
      qt_meta_data_QDeclarativeWebSettings, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &QDeclarativeWebSettings::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *QDeclarativeWebSettings::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *QDeclarativeWebSettings::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_QDeclarativeWebSettings))
        return static_cast<void*>(const_cast< QDeclarativeWebSettings*>(this));
    return QObject::qt_metacast(_clname);
}

int QDeclarativeWebSettings::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    
#ifndef QT_NO_PROPERTIES
     if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = standardFontFamily(); break;
        case 1: *reinterpret_cast< QString*>(_v) = fixedFontFamily(); break;
        case 2: *reinterpret_cast< QString*>(_v) = serifFontFamily(); break;
        case 3: *reinterpret_cast< QString*>(_v) = sansSerifFontFamily(); break;
        case 4: *reinterpret_cast< QString*>(_v) = cursiveFontFamily(); break;
        case 5: *reinterpret_cast< QString*>(_v) = fantasyFontFamily(); break;
        case 6: *reinterpret_cast< int*>(_v) = minimumFontSize(); break;
        case 7: *reinterpret_cast< int*>(_v) = minimumLogicalFontSize(); break;
        case 8: *reinterpret_cast< int*>(_v) = defaultFontSize(); break;
        case 9: *reinterpret_cast< int*>(_v) = defaultFixedFontSize(); break;
        case 10: *reinterpret_cast< bool*>(_v) = autoLoadImages(); break;
        case 11: *reinterpret_cast< bool*>(_v) = javascriptEnabled(); break;
        case 12: *reinterpret_cast< bool*>(_v) = javaEnabled(); break;
        case 13: *reinterpret_cast< bool*>(_v) = pluginsEnabled(); break;
        case 14: *reinterpret_cast< bool*>(_v) = privateBrowsingEnabled(); break;
        case 15: *reinterpret_cast< bool*>(_v) = javascriptCanOpenWindows(); break;
        case 16: *reinterpret_cast< bool*>(_v) = javascriptCanAccessClipboard(); break;
        case 17: *reinterpret_cast< bool*>(_v) = developerExtrasEnabled(); break;
        case 18: *reinterpret_cast< bool*>(_v) = linksIncludedInFocusChain(); break;
        case 19: *reinterpret_cast< bool*>(_v) = zoomTextOnly(); break;
        case 20: *reinterpret_cast< bool*>(_v) = printElementBackgrounds(); break;
        case 21: *reinterpret_cast< bool*>(_v) = offlineStorageDatabaseEnabled(); break;
        case 22: *reinterpret_cast< bool*>(_v) = offlineWebApplicationCacheEnabled(); break;
        case 23: *reinterpret_cast< bool*>(_v) = localStorageDatabaseEnabled(); break;
        case 24: *reinterpret_cast< bool*>(_v) = localContentCanAccessRemoteUrls(); break;
        }
        _id -= 25;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setStandardFontFamily(*reinterpret_cast< QString*>(_v)); break;
        case 1: setFixedFontFamily(*reinterpret_cast< QString*>(_v)); break;
        case 2: setSerifFontFamily(*reinterpret_cast< QString*>(_v)); break;
        case 3: setSansSerifFontFamily(*reinterpret_cast< QString*>(_v)); break;
        case 4: setCursiveFontFamily(*reinterpret_cast< QString*>(_v)); break;
        case 5: setFantasyFontFamily(*reinterpret_cast< QString*>(_v)); break;
        case 6: setMinimumFontSize(*reinterpret_cast< int*>(_v)); break;
        case 7: setMinimumLogicalFontSize(*reinterpret_cast< int*>(_v)); break;
        case 8: setDefaultFontSize(*reinterpret_cast< int*>(_v)); break;
        case 9: setDefaultFixedFontSize(*reinterpret_cast< int*>(_v)); break;
        case 10: setAutoLoadImages(*reinterpret_cast< bool*>(_v)); break;
        case 11: setJavascriptEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 12: setJavaEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 13: setPluginsEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 14: setPrivateBrowsingEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 15: setJavascriptCanOpenWindows(*reinterpret_cast< bool*>(_v)); break;
        case 16: setJavascriptCanAccessClipboard(*reinterpret_cast< bool*>(_v)); break;
        case 17: setDeveloperExtrasEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 18: setLinksIncludedInFocusChain(*reinterpret_cast< bool*>(_v)); break;
        case 19: setZoomTextOnly(*reinterpret_cast< bool*>(_v)); break;
        case 20: setPrintElementBackgrounds(*reinterpret_cast< bool*>(_v)); break;
        case 21: setOfflineStorageDatabaseEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 22: setOfflineWebApplicationCacheEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 23: setLocalStorageDatabaseEnabled(*reinterpret_cast< bool*>(_v)); break;
        case 24: setLocalContentCanAccessRemoteUrls(*reinterpret_cast< bool*>(_v)); break;
        }
        _id -= 25;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 25;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 25;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 25;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 25;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 25;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 25;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}
QT_END_MOC_NAMESPACE
