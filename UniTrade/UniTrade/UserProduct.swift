//
//  UserProduct.swift
//  UniTrade
//
//  Created by Santiago Martinez on 4/11/24.
//


import Foundation

struct UserProduct: Identifiable {
    let id: String
    let title: String
    let price: Float
    let favoritesCategory: Int
    let favoritesForYou: Int
    let imageUrl: String
    let type: String?
    let saveCount: Int
}
