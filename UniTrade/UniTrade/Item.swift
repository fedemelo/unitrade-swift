//
//  Item.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
