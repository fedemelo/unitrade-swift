//
//  CurrencyFormatter.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 15/10/24.
//

import Foundation

struct CurrencyFormatter {
    static func formatPrice(_ price: Float, currencySymbol: String = "COP $", localeIdentifier: String = "es_CO") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = currencySymbol
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        
        return numberFormatter.string(from: NSNumber(value: price)) ?? "\(currencySymbol) 0"
    }
}
