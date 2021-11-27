//
//  IAPHelper.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 25.11.2021.
//

import StoreKit



protocol IAPHelperActionDelegate: AnyObject {
    func cantMakePayment()
    func didPurchaseCompleted()
    func didPurchaseFailed( _ error: IAPHelperActionError)
    func didRestorePurchaseCompleted()
    func didRestorePurchaseFailed()
}

protocol IAPHelperDataSource: AnyObject {
    func didProductLoaded( _ products: [SKProduct])
    func didProductLoadedErrorOccurred( _ error: IAPHelperDataSourceError)
}

class IAPHelper: NSObject {
    
    private var provider : RequestProvider<IAPService>?
    private var productRequest: SKProductsRequest?
    
    weak var actionDelegate: IAPHelperActionDelegate?
    weak var dataSource: IAPHelperDataSource?
    
    override init() {
        super.init()
        provider = .init()
    }
    deinit {
        provider = nil
        actionDelegate = nil
        dataSource = nil
    }
    
    private func canMakePayments() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func getProducts(products: [Product]) {
        productRequest?.cancel()
        let productIdentifiers = Set(products.map { $0.buildProductIdentifier() })
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func purchase(product: SKProduct) {
        if !canMakePayments() {
            actionDelegate?.cantMakePayment()
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        dataSource?.didProductLoaded(response.products)
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        dataSource?.didProductLoadedErrorOccurred(.PRODUCTS_NOT_FOUND)
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                purchaseCompleted(transaction: transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                errorOccured(transaction: transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
extension IAPHelper {
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        // You can check use state Premium or Not ?
        // You can send deeplink for opening premium page
        // If return true app store payment will start , return false won't start any payment process
        return true
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        actionDelegate?.didRestorePurchaseCompleted()
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        actionDelegate?.didRestorePurchaseFailed()
    }
    
    private func purchaseCompleted(transaction: SKPaymentTransaction) {
        if let _ = transaction.transactionIdentifier {
            // Request
            actionDelegate?.didPurchaseCompleted()
        }
    }
    private func errorOccured(transaction: SKPaymentTransaction) {
        guard let err = transaction.error as NSError?  else { return }
        let error: SKError = SKError(_nsError: err)
        /*
        switch error {
        }
        */
        // You can validate your error type or send custom error directly
        actionDelegate?.didPurchaseFailed(.PURCHASE_FAILED)
    }
}
