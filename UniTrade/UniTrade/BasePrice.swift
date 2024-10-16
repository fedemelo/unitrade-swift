//
//  BasePrice.swift
//  UniTrade
//
//  Created by Santiago Martinez on 15/10/24.
//


class BasePrice: Price {
    private let price: Double

    init(price: Double) {
        self.price = price
    }

    func getPrice() -> String {
        return "\(price)"
    }
}
