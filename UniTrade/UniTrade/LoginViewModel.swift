//
//  LoginViewModel.swift
//  UniTrade
//
//  Created by Mariana Ruiz Giraldo on 2/10/24.
//


import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Network
import Combine

final class LoginViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var firstTimeUser = false
    @Published var registeredUser : FirebaseAuth.User?
    @Published var categories: [CategoryName] = []
    @Published var isConnected: Bool = true
    @Published var showBanner: Bool = false
    @Published var majors: [MajorName] = []
    @Published var didCheckFirstTimeUser: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    init() {
        fetchCategories()
        fetchMajors()
        setupNetworkMonitor()
        isFirstTimeUser()
    }
    
    private func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                if self.isConnected {
                    self.retryQueuedRegistration()
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func retryQueuedRegistration() {
        // Retrieve each piece of data individually
        if let categories = UserDefaults.standard.array(forKey: "userCategories") as? [String],
           let major = UserDefaults.standard.string(forKey: "userMajor"),
           let semester = UserDefaults.standard.string(forKey: "userSemester") {
            
            let categoryNames = Set(categories.map { CategoryName(name: $0) })
            
            // Attempt registration and clear data if successful
            attemptRegisterUser(categories: categoryNames, major: major, semester: semester)
            
            // Clear offline data after successful registration
            UserDefaults.standard.removeObject(forKey: "userCategories")
            UserDefaults.standard.removeObject(forKey: "userMajor")
            UserDefaults.standard.removeObject(forKey: "userSemester")
        }
    }
    
    func fetchCategories() {
        let docRef = db.collection("categories").document("all")
        docRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error fetching categories: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = document, document.exists {
                        if let categoryNames = document.data()?["names"] as? [String] {
                            self.categories = categoryNames.map { CategoryName(name: $0) }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
    
    func fetchMajors() {
        let docRef = db.collection("categories").document("majors")
        docRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error fetching majors: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = document, document.exists {
                        if let majorNames = document.data()?["names"] as? [String] {
                            self.majors = majorNames.map { MajorName(name: $0) }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }


var user: FirebaseAuth.User? {
    didSet {
        objectWillChange.send()
    }
}

var provider = OAuthProvider(providerID: "microsoft.com")

func signIn() {
    self.provider.customParameters = ["prompt": "select_account"]
    self.provider.getCredentialWith(nil) { credential, error in
        if error != nil {
            print("An error occurred getting credentials")
            return
        }
        if let credential = credential {
            FirebaseAuthManager.shared.auth.signIn(with: credential) { result, error in
                if error != nil {
                    print("An error occurred signing in")
                    return
                }
                self.registeredUser = FirebaseAuthManager.shared.auth.currentUser
                if let user = self.registeredUser {
                    self.logSignInStats(for: user)
                }
            }
        }
    }
}

    func signOut() {
        do {
            try FirebaseAuthManager.shared.auth.signOut()
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            registeredUser = nil
            user = nil
        } catch {
            print("Error signing out")
        }
    }

    func logSignInStats(for user: FirebaseAuth.User) {
        let currentDate = Date()
        let calendar = Calendar.current

        // Obtener la hora y el día de la semana
        let hour = calendar.component(.hour, from: currentDate)  // 0 to 23
        let weekday = calendar.component(.weekday, from: currentDate) - 1  // 0 to 6 (0 = Sunday)

        // Referencia al documento "time_engagement" en la colección "analytics"
        let statsRef = db.collection("analytics").document("time_engagement")

        // Campo que representa el contador para la hora actual y día de la semana
        let fieldPath = "day_\(weekday).hour_\(hour)"

        // Incrementar el contador de inicio de sesión para la hora y día actuales
        statsRef.updateData([fieldPath: FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating sign-in stats: \(error)")
            } else {
                print("Successfully updated sign-in stats")
            }
        }
    }

    func isFirstTimeUser() {
        guard !didCheckFirstTimeUser else { return }
        print("Checking if user is first time")
        let key = self.registeredUser?.uid
        if key != nil {
            let docRef = self.db.collection("users").document(key!)
            docRef.getDocument { document, _ in
                if let document = document, document.exists {
                    print("User already exists")
                    self.firstTimeUser = false
                } else {
                    self.firstTimeUser = true
                }
            }
        } else {
            print("No key was found for user")
            
        }
        didCheckFirstTimeUser = true
    }

    func registerUser(categories: Set<CategoryName>, major: String, semester: String) {
        if !isConnected {
            queueOfflineRegistration(categories: categories, major: major, semester: semester)
            return
        }
        attemptRegisterUser(categories: categories, major: major, semester: semester)
    }

    private func attemptRegisterUser(categories: Set<CategoryName>, major: String, semester: String) {
        if let user = registeredUser, firstTimeUser {
            let docRef = db.collection("users").document(user.uid)
            
            docRef.getDocument { document, error in
                if let error = error as NSError? {
                    print("Error while getting document \(error)")
                } else if document != nil {
                    do {
                        let categoryNames = categories.map(\.name)
                        let userModel = User(name: user.displayName!, email: user.email!, categories: categoryNames, major: major, semester: semester)
                        try docRef.setData(from: userModel)
                        
                        self.savePreferencesToUserDefaults(categories: categoryNames, major: major, semester: semester)
                        self.firstTimeUser = false
                    } catch {
                        print("Error while encoding registered User \(error)")
                    }
                }
            }
        }
    }
    
    private func savePreferencesToUserDefaults(categories: [String], major: String, semester: String) {
        UserDefaults.standard.set(categories, forKey: "userCategories")
        UserDefaults.standard.set(major, forKey: "userMajor")
        UserDefaults.standard.set(semester, forKey: "userSemester")
        UserDefaults.standard.synchronize()
    }
    
    private func queueOfflineRegistration(categories: Set<CategoryName>, major: String, semester: String) {
        // Serialize the data to store it
        let categoryNames = categories.map(\.name)
        UserDefaults.standard.set(categoryNames, forKey: "userCategories")
        UserDefaults.standard.set(major, forKey: "userMajor")
        UserDefaults.standard.set(semester, forKey: "userSemester")
        UserDefaults.standard.synchronize()
    }
}
