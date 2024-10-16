//
//  FormatDecorator.swift
//  UniTrade
//
//  Created by Santiago Martinez on 15/10/24.
//


class FormatDecorator: PriceDecorator {
    override func getPrice() -> String {
        let rawPrice = wrapped.getPrice()
        if let price = Double(rawPrice) {
            return String(format: "%.2f", price)  // Round to 2 decimal places
        }
        return rawPrice
    }
}
