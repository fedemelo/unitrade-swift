//
//  MajorName.swift
//  UniTrade
//
//  Created by Mariana on 4/11/24.
//


import Foundation

struct MajorName: Identifiable, Hashable, Decodable {
    var id: UUID = UUID()
    let name: String
}
