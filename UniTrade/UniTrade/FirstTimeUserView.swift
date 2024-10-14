import FirebaseAuth
import SwiftUI

struct FirstTimeUserView: View {
    @ObservedObject var loginVM: LoginViewModel
    @State private var multiSelection = Set<CategoryName>()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack {
                    Text("We want to know you better")
                        .font(Font.DesignSystem.headline800)
                        .foregroundColor(Color.DesignSystem.primary900())
                        .padding(16)
                }
                
                Text("Choose the items you are interested in")
                    .font(Font.DesignSystem.bodyText300)
                
                Spacer()
                
                // Flexible grid for category buttons
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(loginVM.categories, id: \.self) { category in
                            Button(action: {
                                if multiSelection.contains(category) {
                                    multiSelection.remove(category)
                                } else {
                                    multiSelection.insert(category)
                                }
                            }) {
                                Text(category.name)
                                    .font(Font.DesignSystem.heading200)
                                    .padding()
                                    .frame(minWidth: 100)
                                    .background(multiSelection.contains(category) ? Color.DesignSystem.primary900() : colorScheme == .light ? Color.white : Color.DesignSystem.dark900())
                                    .foregroundColor(multiSelection.contains(category) ?  Color.white  : colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                    .cornerRadius(100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(Color.DesignSystem.primary900(), lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Discover button
                Button(action: {
                    loginVM.registerUser(categories: multiSelection)
                }) {
                    Text("DISCOVER")
                        .font(Font.DesignSystem.headline400)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.DesignSystem.primary900())
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
                .padding()
            }
        }
    }
}

struct FirstTimeUserView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeUserView(loginVM: LoginViewModel())
    }
}
