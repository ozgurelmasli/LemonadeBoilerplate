//
//  Product.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 27.11.2021.
//


enum ProductType: Identifiable {
    case subscription
    
    var id: String {
        return "subscription"
    }
}
protocol Product: AnyObject {
    /// Idenitifier for this product
    var identifier: String { get }
    /// Product Type
    /// Example : Subscription , GEMs , or any other custom product
    var productType: ProductType { get }
}
extension Product {
    /// Product Identifier Builder
    func buildProductIdentifier() -> String {
        return (Bundle.main.bundleIdentifier ?? "") + productType.id + identifier
    }
}
