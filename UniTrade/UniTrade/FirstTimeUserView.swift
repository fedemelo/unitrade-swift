//
//  FirstTimeUserView.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 2/10/24.
//


import FirebaseAuth
import SwiftUI

struct CategoryName: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
}

struct FirstTimeUserView: View {
    @ObservedObject var loginVM: LoginViewModel
    let categories = [
        CategoryName(name: "Food"),
        CategoryName(name: "Electronics"),
        CategoryName(name: "Books"),
    ]
    
    @State private var multiSelection = Set<CategoryName>()
    
    var body: some View {
        NavigationView{
            VStack {
                
                VStack {
                    Text("We want to know you better")
                        .font(Font.DesignSystem.headline800)
                        .foregroundColor(Color.DesignSystem.primary900())
                    
                }
                Text("Choose the items you are interested in").font(Font.DesignSystem.bodyText300)
                Spacer()
                List(categories, id: \.self, selection: $multiSelection) { cat in
                    Text(cat.name)
                }.toolbar{EditButton()}
                Spacer()
                Button("Done") {
                    loginVM.registerUser(categories:multiSelection)
                    
                }
            }
        }
        
        
    }}


struct FirstTimeUserView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeUserView( loginVM: LoginViewModel())
    }
}
