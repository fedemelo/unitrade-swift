//
//  Category.swift
//  UniTrade
//
//  Created by Santiago Martinez on 30/09/24.
//


import Foundation

struct Category: Identifiable,Equatable {
    let id = UUID()
    let name: String
    let itemCount: Int
    let systemImage: String
}
