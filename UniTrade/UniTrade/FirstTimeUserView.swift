import FirebaseAuth
import SwiftUI
import FirebaseFirestore

extension Array {
    // This method splits the array into smaller arrays of the given size
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}

struct FirstTimeUserView: View {
    @ObservedObject var loginVM: LoginViewModel
    @State private var multiSelection = Set<CategoryName>()
    @State private var isLoading = false 
    @Environment(\.colorScheme) var colorScheme
    
    let semesterOptions = ["1-2 semester", "3-4 semester", "5-6 semester", "7-8 semester", "9-10 semester", "+10 semesters"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                Text("We want to know you better")
                    .font(Font.DesignSystem.headline800)
                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() :
                                        Color.DesignSystem.primary600())
                    .multilineTextAlignment(.center)
                
                // Major selection
                VStack(alignment: .leading, spacing: 5) {
                    Text("Major")
                        .font(Font.DesignSystem.headline500)
                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() :
                                            Color.DesignSystem.light300())
                    
                    Menu {
                        ForEach(loginVM.majors, id: \.self) { major in
                            Button(action: {
                                userPreferences.preferredMajor = major.name
                            }) {
                                Text(major.name)
                                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                    .font(Font.DesignSystem.headline300)
                            }
                        }
                    } label: {
                        HStack {
                            Text(userPreferences.preferredMajor)
                                .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(Font.DesignSystem.headline300)
                            Image(systemName: "chevron.down")
                                .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() :
                                            Color.DesignSystem.light300())
                        .padding(.horizontal, 5)
                }
                
                // Semester selection
                VStack(alignment: .leading, spacing: 5) {
                    Text("Semester")
                        .font(Font.DesignSystem.headline500)
                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() :
                                            Color.DesignSystem.light300())
                    
                    Menu {
                        ForEach(semesterOptions, id: \.self) { semester in
                            Button(action: {
                                userPreferences.preferredSemester = semester
                            }) {
                                Text(semester)
                                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                    .font(Font.DesignSystem.headline300)
                            }
                        }
                    } label: {
                        HStack {
                            Text(userPreferences.preferredSemester)
                                .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(Font.DesignSystem.headline300)
                            Image(systemName: "chevron.down")
                                .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() :
                                            Color.DesignSystem.light300())
                        .padding(.horizontal, 5)
                }
                
                Text("Choose the items you are interested in")
                    .font(Font.DesignSystem.bodyText300)
                
                VStack(spacing: 20) {
                    ForEach(Array(loginVM.categories.chunked(into: 2)), id: \.self) { rowCategories in
                        HStack(spacing: 10) {
                            Spacer()
                            
                            ForEach(rowCategories, id: \.self) { category in
                                Button(action: {
                                    if userPreferences.preferredCategories.contains(category) {
                                        userPreferences.preferredCategories.remove(category)
                                    } else {
                                        userPreferences.preferredCategories.insert(category)
                                    }
                                }) {
                                    HStack {
                                        if userPreferences.preferredCategories.contains(category) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                                .font(.system(size: 10))
                                        }
                                    }) {
                                        HStack {
                                            if multiSelection.contains(category) {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 10))
                                            }
                                            
                                            Text(category.name)
                                                .font(Font.DesignSystem.heading200)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .frame(minWidth: 100)
                                        .background(userPreferences.preferredCategories.contains(category) ? Color.DesignSystem.primary900() : colorScheme == .light ? Color.white : Color.DesignSystem.dark900())
                                        .foregroundColor(userPreferences.preferredCategories.contains(category) ?  Color.white  : colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                        .cornerRadius(100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 100)
                                                .stroke(Color.DesignSystem.primary900(), lineWidth: 2)
                                        )
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Button(action: {
                        if loginVM.isConnected {
                            isLoading = true
                            loginVM.registerUser(categories: userPreferences.preferredCategories, major: userPreferences.preferredMajor, semester: userPreferences.preferredSemester) {
                                // Callback after registration completes
                                isLoading = false
                                loginVM.showBanner = true // Show the banner after "Discover" is clicked
                            }
                        } else {
                            loginVM.showBanner = true // Show offline banner if not connected
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("DISCOVER")
                                .font(Font.DesignSystem.headline400)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.DesignSystem.primary900())
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .padding()
                }
                .padding(.horizontal)
            }
            
            // Warning banner at the bottom
            if loginVM.showBanner && !loginVM.isConnected {
                ZStack {
                    HStack {
                        Text("No internet connection. User information will be stored and uploaded when connection is available.")
                            .font(Font.DesignSystem.headline500)
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // X button to close the banner
                        Button(action: {
                            loginVM.showBanner = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                .background(Color.red)
                .transition(.move(edge: .bottom))
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            loginVM.fetchMajors()
        }
        .animation(.easeInOut, value: loginVM.showBanner && !loginVM.isConnected) // Animation for banner
    }
}
