//
//  ExplorerView.swift
//  UniTrade
//
//  Created by Santiago Martinez on 28/09/24.
//

import SwiftUI

struct ExplorerView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(0 ... 11, id: \.self) { listing in
                        ListingItemView()                   }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ExplorerView()
}

