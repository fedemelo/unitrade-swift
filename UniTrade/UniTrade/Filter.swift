//
//  Filter.swift
//  UniTrade
//
//  Created by Santiago Martinez on 13/10/24.
//

import Foundation

struct Filter {
    var minPrice: Double?
    var maxPrice: Double?
    var sortOption: String?
    var isAscending: Bool = true

    var isActive: Bool {
        return minPrice != nil || maxPrice != nil || sortOption != nil
    }
}
