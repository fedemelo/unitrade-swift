//
//  PriceDecorator.swift
//  UniTrade
//
//  Created by Santiago Martinez on 15/10/24.
//


class PriceDecorator: Price {
    let wrapped: Price

    init(wrapped: Price) {
        self.wrapped = wrapped
    }

    func getPrice() -> String {
        return wrapped.getPrice()
    }
}
