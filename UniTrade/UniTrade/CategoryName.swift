//
//  CategoryName.swift
//  UniTrade
//
//  Created by Mariana on 14/10/24.
//

import Foundation

struct CategoryName: Identifiable, Hashable, Decodable {
    var id: UUID = UUID()
    let name: String
}
