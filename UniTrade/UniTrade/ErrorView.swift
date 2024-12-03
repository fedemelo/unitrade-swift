//
//  ErrorView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 4/11/24.
//


import SwiftUI

struct ErrorView: View {
    let message: String
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}
