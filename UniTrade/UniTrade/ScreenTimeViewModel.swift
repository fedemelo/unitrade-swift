import SwiftUI
import FirebaseAnalytics
import FirebaseFirestore

class ScreenTimeViewModel: ObservableObject {
    private var startTime: Date?
    private let db = Firestore.firestore()
    
    func startTrackingTime() {
        startTime = Date()
    }
    
    func stopAndRecordTime(for screenName: String) {
        guard let start = startTime else { return }
        let timeSpent = Date().timeIntervalSince(start)
        
        Analytics.logEvent("view_time", parameters: [
            "view_name": screenName,
            "time_spent": timeSpent
        ])
        
        let collectionRef = db.collection("analytics").document("screen_time").collection(screenName)
        let docRef = collectionRef.document("statistics")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentAvgTime = document.data()?["average_time"] as? Double ?? 0
                let visitCount = document.data()?["visit_count"] as? Int ?? 0
                
                let newAvgTime = ((currentAvgTime * Double(visitCount)) + timeSpent) / Double(visitCount + 1)
                
                docRef.updateData([
                    "average_time": newAvgTime,
                    "visit_count": visitCount + 1
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Successfully updated average screen time in Firestore")
                    }
                }
            } else {
                docRef.setData([
                    "average_time": timeSpent,
                    "visit_count": 1
                ], merge: true) { error in
                    if let error = error {
                        print("Error setting document: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        startTime = nil
    }
}
