//
//  User.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 2/10/24.
//


import SwiftUI
import FirebaseFirestore

struct User: Hashable, Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var categories: [String]
}
