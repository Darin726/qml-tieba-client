#ifndef QIAP_H
#define QIAP_H

#include <QObject>
#include <QList>
#include <QProgressDialog>
#include <iapclient.h>

class QIapPrivate;

/**
 * @class QIap
 *
 * @brief In App Purchase wrapper implementation for local stored content
 *
 */

class QIap : public QObject
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(QIap)
    Q_CLASSINFO("Author", "Sebastiano Galazzo")
    Q_CLASSINFO("Email", "sebastiano.galazzo@gmail.com")

public:
    /**
     * @brief Constructor
     *
     * @param parent
     */
    explicit QIap(QObject *parent = 0);

    /**
     * @brief Destructor
     */
    virtual ~QIap();

    /**
     * @brief List of available IAP products on OVI Store
     */
    QList<IAPClient::ProductDataHash>& availableProducts();

    /**
     * @brief Purchase a product by In-app ID
     * @param productId
     * @param restoration
     */
    Q_INVOKABLE int  purchaseProductByID(QString productId, IAPClient::ForceRestorationFlag restoration=IAPClient::ForcedAutomaticRestoration);

    /**
     * @brief Purchase a product by product name ( info field )
     * @param productName
     * @param restoration
     */
    Q_INVOKABLE int  purchaseProductByName(QString productName, IAPClient::ForceRestorationFlag restoration=IAPClient::ForcedAutomaticRestoration);

    /**
     * @brief
     * @param fileName
     * @return true if file is purchased
     */
    Q_INVOKABLE bool isPurchased(QString fileName);

    /**
     * @brief Get DRM file content if the device can access the encrypted file
     *
     * @param productID
     * @param fileName
     *
     */    
    Q_INVOKABLE QByteArray getDRMFileContent(QString productID,QString fileName);

signals:
    void purchaseCompleted(QString status, QString productID);
    void purchaseFlowFinished( int requestId );
    void getProductsCompleted();
    void restoreProductsCompleted();
    void itemRestored(QString  productID);

public slots:
    /**
      * @brief Get available IAP products on OVI Store
      */
    void getProducts();

    /**
      * @brief Retrieve previously purchased products
      */
    void restoreProducts();

protected:

    /**
     * @variable Private implementation of the API
     */
    QIapPrivate* const d_ptr;

private:
    QProgressDialog* busyIndicator;
};

#endif // QIAP_H
