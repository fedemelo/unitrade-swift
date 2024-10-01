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
    @State private var isFilterPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                VStack {
                    SearchandFilterBar(isFilterPresented: $isFilterPresented)
                    ScrollView {
                        CategoryScroll()
                        LazyVGrid(columns: columns, spacing: 32) {
                            ForEach(0 ... 9, id: \.self) { listing in
                                ListingItemView()                   }
                        }
                        .padding()
                    }
                }
            }
            
            if isFilterPresented {
                                FilterView(isPresented: $isFilterPresented)
                                    .transition(.move(edge: .bottom))
                                    .animation(.spring(), value: isFilterPresented)
            }
        }
    }
}

#Preview {
    ExplorerView()
}

