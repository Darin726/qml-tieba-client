#include "qiap_p.h"
#include "qiap.h"
#include <QDirIterator>
#include <QTimer>
#include <QApplication>
#include <QMessageBox>
#ifdef IN_APP_PURCHASE_DEBUG
#include <QDebug>
#endif

#define TICKETFOLDERNAME "tickets"
Q_DECLARE_METATYPE(IAPClient::ProductDataList)  //to be able to transfer data this type with Qt::QueuedConnection

QIapPrivate::QIapPrivate(QIap* aPublicAPI):
    d(aPublicAPI)
   ,productsRequested(0)
   ,current_requestId(INVALID_VALUE)
{
#ifdef IN_APP_PURCHASE
    // required so that IAPClient::ProductData can be queued in the signal
    qRegisterMetaType<IAPClient::ProductDataHash>("IAPClient::ProductDataHash");
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. Catalog constuctor";
    #endif
    iap_client = new IAPClient(this);

    connect(iap_client, SIGNAL(purchaseCompleted( int , QString, QString)), this, SLOT(purchaseCompleted( int , QString, QString)),Qt::QueuedConnection);
    connect(iap_client, SIGNAL(purchaseFlowFinished(int)), this, SLOT(purchaseFlowFinished(int)), Qt::QueuedConnection);
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << ".:: Catalog constuctor";
    #endif
#endif

}

QIapPrivate::~QIapPrivate()
{
    delete iap_client;
}

void QIapPrivate::getProducts() {
    QString filepath = QApplication::applicationDirPath();
    filepath.append("/drm/data");

    QFile file(filepath);
    file.open(QFile::ReadOnly);

    QDirIterator dirit(filepath, QDir::Dirs, QDirIterator::NoIteratorFlags);
    while(dirit.hasNext())
    {
        QString dir = dirit.next();
        if(dir.contains("resourceid_", Qt::CaseInsensitive))
        {
            // breakdown the !:/private/<SID>/drm/data/resourceid_<productID>/
            // extract the product to which this file belongs
            QString product;
            QStringList elem = dir.split("_", QString::SkipEmptyParts);
            elem=elem[1].split("/", QString::SkipEmptyParts);
            product = elem[0].trimmed();
            if(!product.isEmpty())
            {
                if(!isProductActivated(product))
                {
                    products.append(product);
                    #ifdef IN_APP_PURCHASE_DEBUG
                    qDebug() << "++ ProductID " << product << " to be puchased.";
                    #endif
                } else {
                    #ifdef IN_APP_PURCHASE_DEBUG
                    qDebug() << "++ ProductID " << product << " is activated.";
                    #endif
                }
            }
        }
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "Products list count: " << products.count();
    #endif
    if(products.count()>0) {
        // connect IAP API's signals to app's slots
        connect(iap_client, SIGNAL(productDataReceived( int, QString, IAPClient::ProductDataHash)), this, SLOT(productDataReceived(int, QString, IAPClient::ProductDataHash)), Qt::QueuedConnection);       
        // request product data from Ovi for the products
        requestNextProduct();
    }

    connect(iap_client, SIGNAL(restorableProductsReceived( int, QString, IAPClient::ProductDataList)), this, SLOT(restorableProductsReceived( int, QString, IAPClient::ProductDataList)));
    connect(iap_client, SIGNAL(restorationCompleted(int, QString, QString)), this, SLOT(restorationCompleted(int, QString, QString)),Qt::QueuedConnection);
}

bool QIapPrivate::isPurchased(int drmErrCode, QString& fileName)
{
    QString drmPath(QApplication::applicationDirPath());
    drmPath.append("/drm");
    if(fileName.startsWith(drmPath))
    {
        QString productID = getProductId(fileName);
        return (drmErrCode == KErrNone && readTicket(productID));
    }
    else
    {
        return true;
    }
}

QString QIapPrivate::getProductId(const QString& path)
{
    // breakdown the !:/private/<SID>/drm/data/resourceid_<productID>/file.ext
    // extract the product to which this file belongs
    QStringList elem = path.split("_", QString::SkipEmptyParts);
    elem=elem[1].split("/", QString::SkipEmptyParts);
    return (elem[0]);
}

bool QIapPrivate::readTicket(const QString& productID)
{
    return (QFile(getTicketUri(productID)).exists());
}

QString QIapPrivate::getTicketUri(const QString& productID)
{
    QString fname(QApplication::applicationDirPath());
    fname.append("/");
    fname.append(TICKETFOLDERNAME);
    fname.append("/");
    fname.append(productID);
    fname.append(".ticket");
    return fname;
}

/*
 *
 *
 *
 */
void QIapPrivate::productDataReceived( int /*requestId*/, QString status, IAPClient::ProductDataHash productData )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. productDataReceived";
    #endif
    //Q_ASSERT(requestId == current_requestId);

    if(QString::compare(status, "OK", Qt::CaseInsensitive)==0)
    {
        available_products.append(productData);
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "Product ID:" <<productData.value("id").toString();
        qDebug() << "Product Info:" <<productData.value("info").toString();
        qDebug() << "Product Price:"<<productData.value("price").toString();
        qDebug() << "Product Shortdescription:"<<productData.value("shortdescription").toString();
        qDebug() << "Product Description:"<<productData.value("description").toString();
        qDebug() << "Product Result:"<<productData.value("result").toString();
        //IAPClient::DrmType drm = data.value("drmtype").toInt();
        #endif
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    else // what are all the possible status messages?
    {
        // the product is not available for one reason or another?
        // probably you can ignore this
        // or report it to your server for analysis
        qDebug() << "Requested product could not be retrived: " << status;
    }
    #endif
    // if we don't have any more products ...
    if(productsRequested == products.count())
    {
        //ui.progressBar->setVisible(false);
        emit d->getProductsCompleted();
        // have we got any product data?
        if(!available_products.count())
        {
            QMessageBox message;
            message.setText(tr("No products available. Please try again later!"));
            message.exec();
        }
    }
    else
    {
        // let's look for the next product's data
        requestNextProduct();
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << ".:: productDataReceived";
    #endif
}

/*
 *
 *
 *
 */
void QIapPrivate::requestNextProduct()
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. requestNextProduct";
    #endif
    if(productsRequested < products.count())
    {
        QString prod = products[productsRequested++];
        current_requestId = iap_client->getProductData(prod);
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "+ Request for product" << prod << " returned id: " << current_requestId;
        #endif
        //ui.progressBar->setValue(productsRequested-1);
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    else
        qDebug() << "productsRequested:"<<QString::number(productsRequested);    
    #endif

    #ifdef IN_APP_PURCHASE_DEBUG
    if(productsRequested == products.count() - 1){
        qDebug() << "Loaded "<< QString::number(productsRequested)<< " products";
    }

    qDebug() << ".:: requestNextProduct";
    #endif
}

int  QIapPrivate::purchaseProductByID(QString productId, IAPClient::ForceRestorationFlag restoration){
    current_productId = productId;
    this->productId = productId;
    return (current_requestId=iap_client->purchaseProduct(productId, restoration));
}

/*
 *
 *
 *
 */
void QIapPrivate::purchaseCompleted( int requestId, QString status, QString purchaseTicket )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. purchaseCompleted with status: " << status;
    //qDebug() << "::. purchaseCompleted purchaseTicket: " << purchaseTicket;
    #endif

    if(requestId != current_requestId) return;
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. purchaseCompleted requestId == current_requestId: " << QString::number(current_requestId);
    #endif
    if(QString::compare(status, "OK", Qt::CaseInsensitive)==0 || QString::compare(status, "RestorableProduct", Qt::CaseInsensitive)==0)
    {
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "Saving ticket";
        #endif
        saveTicket(purchaseTicket, this->productId);
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "::. purchaseCompleted current_productId: " << this->productId;
        #endif
        // In-Application Purchase API will take care of downloading the DRM license
        // the files covered by this license will become accessible
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    else
    {
        // some error
        // error message already displayed by In-Application Purchase UI, may also be reflected in app's UI.
    }
    #endif
    if( d ) emit d->purchaseCompleted(status, current_productId);
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << ".:: purchaseCompleted";
    #endif
}

/*
 *
 *
 *
 */
void QIapPrivate::purchaseFlowFinished( int requestId )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. purchaseFlowFinished";
    #endif
    // now the user is back in app's UI
    if( d ) emit d->purchaseFlowFinished(requestId);
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << ".:: purchaseFlowFinished";
    #endif
}

/*
 *
 *
 *
 */
void QIapPrivate::userAndDeviceDataReceived( int /*requestId*/, QString /*status*/,
                                            IAPClient::UserAndDeviceDataHash /*userdata*/ )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. userAndDeviceDataReceived";

    qDebug() << ".:: userAndDeviceDataReceived";
    #endif
}


void QIapPrivate::restoreProducts()
{
    current_requestId = iap_client->getRestorableProducts();
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "restoreProducts():"<< QString::number(current_requestId);
    #endif
    if(current_requestId < 0) return;

    //lock ui
    d->busyIndicator->setLabelText("Ripristino in corso...");
    d->busyIndicator->show();

    restorableProductItems.clear();
}

/*
 *
 *
 *
 */
void QIapPrivate::restorableProductsReceived( int requestId, QString status, IAPClient::ProductDataList items )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. restorableProductsReceived with status: " << status;
    #endif
    if(requestId != current_requestId){
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << "::. restorableProductsReceived failed ";
        #endif
        return;
    }

    current_requestId = INVALID_VALUE;

    if(!items.empty()){
        restorableProductItems.append(items);
        current_productId = restorableProductItems.takeFirst().value("id").toString();
        current_requestId = iap_client->restoreProduct(current_productId);
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    else {
        qDebug() << "restorableProductsReceived: items.empty()";
    }
    #endif

    if(current_requestId == INVALID_VALUE){
        #ifdef IN_APP_PURCHASE_DEBUG
        qDebug() << ">>>>>>>>> : Restoring failed for product " << QString::number(requestId);
        #endif
    }

    d->busyIndicator->close();
}

/*
 *
 *
 *
 */
void QIapPrivate::restorationCompleted( int requestId, QString status, QString purchaseTicket )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. restorationCompleted with status: " << status << " [ current product id: " << current_productId << "]";
    #endif
    purchaseCompleted(requestId, status, purchaseTicket);

    emit d->itemRestored(current_productId);

    if(restorableProductItems.empty()){
        d->busyIndicator->close();
        emit d->restoreProductsCompleted();        
    } else {
        current_productId = restorableProductItems.takeFirst().value("id").toString();
        current_requestId = iap_client->restoreProduct(current_productId);
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << ".:: restorationCompleted";
    #endif
}

/*
 *
 *
 *
 */
void QIapPrivate::restorationFlowFinished( int /*requestId*/ )
{
    #ifdef IN_APP_PURCHASE_DEBUG
    qDebug() << "::. restorationFlowFinished";

    qDebug() << ".:: restorationFlowFinished";
    #endif
}


/*
 * Returns true if the product files can be accessed or false if the purchase/restore is needed
 */
bool QIapPrivate::isProductActivated(QString product)
{
    // ToDo: construct path, find first file and attempt to open it
    // return false if open request fails with DRM access code
    return false;
}

void QIapPrivate::saveTicket(const QString& purchaseTicket, QString& productID)
{
    if (purchaseTicket.isEmpty() || productID.isEmpty()) return;

    QString privatedir(getTicketDir());
    if (!QDir(privatedir).exists())
        QDir().mkdir(privatedir);

    QFile file(getTicketUri(productID));
    if (file.open(QIODevice::WriteOnly)){
        QDataStream out(&file);
        out << purchaseTicket;
        file.close();
    }
    #ifdef IN_APP_PURCHASE_DEBUG
    else
    {
        qDebug() << "testModeSaveTicket >>> Cannot open file for writing: ";
    }
    #endif

    productID = "";
}

QString QIapPrivate::getTicketDir()
{
    QString fname(QApplication::applicationDirPath());
    fname.append("/");
    fname.append(TICKETFOLDERNAME);
    return fname;
}
