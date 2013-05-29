#include "qiap.h"
#include "qiap_p.h"
#include "DRMFile.h"
#include <QApplication>
#include <QEventLoop>
#include <QMessageBox>
#include <QDesktopServices>
#include <QFile>
#include <QUrl>
#ifdef IN_APP_PURCHASE_DEBUG
#include <QDebug>
#endif
QIap::QIap(QObject *parent) :
    QObject(parent)
  , d_ptr(new QIapPrivate(this))
{
    busyIndicator = new QProgressDialog("", "", 1, 1, NULL);
    busyIndicator->setCancelButton(NULL);
    busyIndicator->setWindowModality(Qt::WindowModal);
}

QIap::~QIap()
{
    delete d_ptr;
}

void QIap::getProducts()
{
    Q_D(QIap);
    return d->getProducts();
}

QList<IAPClient::ProductDataHash>& QIap::availableProducts(){
    Q_D(QIap);
    return d->available_products;
}

int  QIap::purchaseProductByID(QString productId, IAPClient::ForceRestorationFlag restoration){
    Q_D(QIap);
    return d->purchaseProductByID(productId,restoration);
}

int  QIap::purchaseProductByName(QString productName, IAPClient::ForceRestorationFlag restoration){
        Q_D(QIap);
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> purchaseProductByName";
        #endif
        QEventLoop loop;
        connect(this,SIGNAL(getProductsCompleted()), &loop,SLOT(quit()));
        d->getProducts();
        loop.exec();
        IAPClient::ProductDataHash toCheck;

        QListIterator<IAPClient::ProductDataHash> i(d->available_products);
        while (i.hasNext()){
            toCheck = i.next();
            #ifdef IN_APP_PURCHASE_DEBUG
            qDebug() << toCheck.value("id").toString();            
            #endif
            if( QString::compare(toCheck.value("info").toString(), productName, Qt::CaseInsensitive) == 0 )
                return d->purchaseProductByID(toCheck.value("id").toString(),restoration);
        }
        return -1;
}

bool QIap::isPurchased(QString fileName){
    Q_D(QIap);

    DRMFile file;
    QString filepath = QApplication::applicationDirPath();
    filepath.append("/drm/data");
    filepath.append(fileName);

    int error = file.open(filepath);
    // if the device can access the encrypted file
    if(!error)
    {
        // process the file data
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "DRM open ok";
        #endif
        file.close();
    }
    // if the device cannot access the encrypted file
    else
    {
        file.close();
        // check the cause of the error
        #ifdef IN_APP_PURCHASE_DEBUG
        if(file.isDRMError(error)) {
            qDebug() << "DRM Error";
        }

        switch(error){
            case KErrNotFound : qDebug() << "File not found"; break;
            case KErrPathNotFound : qDebug() << "directory not found"; break;
            case KErrBadName : qDebug() << "Bad file name"; break;
            default : qDebug() << "DRMFile error code:"<< QString::number(error); break;
        }
        #endif
    }

    //return d->isPurchased(error, fileName);
    return d->isPurchased(error, filepath);
}

void QIap::restoreProducts(){
    Q_D(QIap);
    d->restoreProducts();
}

QByteArray QIap::getDRMFileContent(QString productID,QString fileName){

    QByteArray result;

    QString filepath = QApplication::applicationDirPath();
    filepath.append("/drm/data");
    filepath.append("/resourceid_"+productID+"/");
    filepath.append(fileName);

    uchar* buffer = NULL;

    DRMFile file;
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << ">>>>> Opening:"<<filepath;
    #endif
    int returnCode = file.open(filepath);

    // if the device can access the encrypted file
    if(!returnCode)  {
        // process the file data
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "DRM open ok";
        #endif
        int len = file.read(buffer);
        result = QString::fromAscii((char*)buffer,len).toUtf8();
    } else {
        // check the cause of the error
        if(file.isDRMError(returnCode)) {
            QMessageBox::critical(NULL,"DRM Error", "Error reading DRM file.\n\nError ("+QString::number(returnCode)+")" );
        }

        switch(returnCode){
            case KErrNotFound : QMessageBox::critical(NULL,"Error","Error ("+QString::number(returnCode)+")\n\nFile not found"); break;
            case KErrPathNotFound : QMessageBox::critical(NULL,"Error","Error ("+QString::number(returnCode)+")\n\nDirectory not found"); break;
            case KErrBadName : QMessageBox::critical(NULL,"Error","Error ("+QString::number(returnCode)+")\n\nBad file name"); break;
            default : QMessageBox::critical(NULL,"Error","Error ("+QString::number(returnCode)+")"); break;
        }
    }
    file.close();

    delete buffer;

    return result;
}
