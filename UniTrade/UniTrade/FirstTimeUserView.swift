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
    @State private var selectedCategories = Set<CategoryName>()
    @State private var selectedMajor: String = "Select Major"
    @State private var selectedSemester: String = "Select Semester"
    @Environment(\.colorScheme) var colorScheme
    
    let semesterOptions = ["1-2 semester", "3-4 semester", "5-6 semester", "7-8 semester", "9-10 semester", "+10 semesters"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 10) {
                    
                    Text("We want to know you better")
                        .font(Font.DesignSystem.headline800)
                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.primary600())
                        .multilineTextAlignment(.center)
                    
                    // Major selection
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Major")
                            .font(Font.DesignSystem.headline500)
                            .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.light300())
                        
                        Menu {
                            ForEach(loginVM.majors, id: \.self) { major in
                                Button(action: {
                                    selectedMajor = major.name
                                }) {
                                    Text(major.name)
                                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                        .font(Font.DesignSystem.headline300)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedMajor)
                                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(Font.DesignSystem.headline300)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.light300())
                            .padding(.horizontal, 20)
                    }
                    
                    // Semester selection
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Semester")
                            .font(Font.DesignSystem.headline500)
                            .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.light300())
                        
                        Menu {
                            ForEach(semesterOptions, id: \.self) { semester in
                                Button(action: {
                                    selectedSemester = semester
                                }) {
                                    Text(semester)
                                        .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                        .font(Font.DesignSystem.headline300)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedSemester)
                                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(Font.DesignSystem.headline300)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(colorScheme == .light ? Color.DesignSystem.primary900() : Color.DesignSystem.light300())
                            .padding(.horizontal, 20)
                    }
                    
                    Text("Choose the items you are interested in")
                        .font(Font.DesignSystem.bodyText300)
                    
                    // Category selection
                    VStack(spacing: 20) {
                        ForEach(Array(loginVM.categories.chunked(into: 2)), id: \.self) { rowCategories in
                            HStack(spacing: 10) {
                                Spacer()
                                
                                ForEach(rowCategories, id: \.self) { category in
                                    Button(action: {
                                        if selectedCategories.contains(category) {
                                            selectedCategories.remove(category)
                                        } else {
                                            selectedCategories.insert(category)
                                        }
                                    }) {
                                        HStack {
                                            if selectedCategories.contains(category) {
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
                                        .background(selectedCategories.contains(category) ? Color.DesignSystem.primary900() : colorScheme == .light ? Color.white : Color.DesignSystem.dark900())
                                        .foregroundColor(selectedCategories.contains(category) ?  Color.white : colorScheme == .light ? Color.DesignSystem.primary900() : Color.white)
                                        .cornerRadius(100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 100)
                                                .stroke(Color.DesignSystem.primary900(), lineWidth: 2)
                                        )
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        Button(action: {
                            loginVM.registerUser(categories: selectedCategories, major: selectedMajor, semester: selectedSemester)
                        }) {
                            Text("DISCOVER")
                                .font(Font.DesignSystem.headline400)
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
                
            
                if loginVM.showAlert {
                    VStack {
                        Spacer() // Pushes the banner to the bottom
                        
                        HStack {
                            Text("No internet connection. User information will be stored and uploaded when connection is available.")
                                .font(Font.DesignSystem.headline300)
                                .foregroundColor(.black)
                            Spacer()
                            Button(action: {
                                loginVM.showAlert = false
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .padding(.bottom, 10) // Adjust this to position closer or farther from the screen's bottom
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: loginVM.showAlert)
                        .zIndex(1) // Ensures banner is on top
                    }
                }
            }
            .onAppear {
                loginVM.showAlert = !loginVM.isConnected
            }
        }
    }
}
