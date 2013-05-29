#ifndef QIAP_P_H
#define QIAP_P_H

#define INVALID_VALUE -1
#include <iapclient.h>

#include <QStringList>

class QIap;

/**
 * @class QIapPrivate
 *
 * @brief In App Purchase Private wrapper implementation
 *
 */

class QIapPrivate : public QObject
{
    Q_OBJECT

public:
    /**
     * @brief constructor
     *
     */
    explicit QIapPrivate(QIap* aPublicAPI = 0);

    /**
     * @brief destructor
     *
     */
    virtual ~QIapPrivate();

    void getProducts();
    int  purchaseProductByID(QString productId, IAPClient::ForceRestorationFlag restoration);

public:

    /**
     * List of product items as read from app's config file.
     */
    QStringList products;

    /**
     * Index in *products* list indicating which is the last product for which
     * info was requested from Ovi
     */
    int productsRequested;

    /**
     * Holds the requestId returned by the current In-Application Purchase call
     */
    int current_requestId;

    QString current_productId;
    QString productId;

    /**
     * In-Application Purchase API
     */
    IAPClient *iap_client;

    /**
     * List of availble products as retrieved from Ovi
     */
    QList<IAPClient::ProductDataHash> available_products;

    IAPClient::ProductDataList restorableProductItems;

private:
    bool isPurchased(int drmErrCode, QString& fileName);
    QString getProductId(const QString& path);
    bool readTicket(const QString&);
    void requestNextProduct();
    bool isProductActivated(QString product);
    static void saveTicket(const QString& purchaseTicket, QString& productID);
    static QString getTicketDir();
    static QString getTicketUri(const QString& productID);

private slots:

    /**
     * In-Application Purchase specific slots
     *
     * Slots matching the signals of the In-Application Purchase API, allowing
     * the application to receive callbacks
     */
    void productDataReceived( int requestId, QString status, IAPClient::ProductDataHash productData );
    void purchaseCompleted( int requestId, QString status, QString purchaseTicket );
    void purchaseFlowFinished( int requestId );
    void userAndDeviceDataReceived( int requestId, QString status, IAPClient::UserAndDeviceDataHash userdata );
    void restorableProductsReceived( int requestId, QString status,IAPClient::ProductDataList items );
    void restorationFlowFinished( int requestId );
    void restorationCompleted( int requestId, QString status, QString purchaseTicket );
    /**
     * Slot to handle user's tap on the Restore button on a catalog's product item.
     */
    void restoreProducts();

private:
    QIap* d;
    friend class QIap;
};

#endif // QIAP_P_H
