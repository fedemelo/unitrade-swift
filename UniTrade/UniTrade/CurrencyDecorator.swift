//
//  CurrencyDecorator.swift
//  UniTrade
//
//  Created by Santiago Martinez on 15/10/24.
//


// CurrencyDecorator.swift
class CurrencyDecorator: PriceDecorator {
    override func getPrice() -> String {
        return "COP $\(wrapped.getPrice())"
    }
}
