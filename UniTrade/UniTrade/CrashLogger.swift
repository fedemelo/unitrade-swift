import Foundation
import FirebaseDatabase

class CrashLogger {
    private let database = Database.database().reference()
    
    // Log crash info for a given OS version
    func logCrash(osVersion: String) {
        let crashRef = database.child("analytics/crashes/all/\(osVersion)")
        
        // Use a transaction to ensure atomic increment
        crashRef.runTransactionBlock { (currentData) -> TransactionResult in
            if var crashData = currentData.value as? [String: Any] {
                var crashes = crashData["crashes"] as? Int ?? 0
                crashes += 1
                crashData["crashes"] = crashes
                currentData.value = crashData
            } else {
                // Create new entry for this OS version
                currentData.value = ["OS": osVersion, "crashes": 1]
            }
            return TransactionResult.success(withValue: currentData)
        } andCompletionBlock: { error, _, _ in  // <-- FIXED argument label
            if let error = error {
                print("Error logging crash: \(error.localizedDescription)")
            } else {
                print("Crash logged successfully for \(osVersion)")
            }
        }
    }
}
