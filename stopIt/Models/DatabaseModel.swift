import Foundation
import Firebase

class DatabaseModel {
    static let shared = DatabaseModel()
    
    let databaseRef: DatabaseReference
    
    private init() {
        databaseRef = Database.database(url: "https://front-9d303-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }
    
    // MARK: - Save To Database
    func saveTotalStudyTime(time: Int) {
        setValue(uri: "StudyTime/\(User.shared.uid!)/\(Date().today)/studyTime", value: time)
    }
    
    func saveStudyStartTime(startTime: Date) {
        setValue(uri: "StudyTime/\(User.shared.uid!)/\(Date().today)/startTime", value: startTime.toString())
    }
    
    func saveStudyEndTime(endTime: Date?) {
        setValue(uri: "StudyTime/\(User.shared.uid!)/\(Date().today)/endTime", value: endTime?.toString() ?? "")
    }
    
    func saveRestTime(restTime: Int) {
        setValue(uri: "StudyTime/\(User.shared.uid!)/\(Date().today)/restTime", value: restTime)
    }
    
    func saveRest(start startTime: Date, end endTime: Date?) {
        setValue(uri: "StudyTime/\(User.shared.uid!)/\(Date().today)/rests/\(startTime.toString())", value: endTime?.toString() ?? "")
    }
    
    func saveAverageHeartRate(date: Date, avg: Int) {
        setValue(uri: "HeartRate/\(User.shared.uid!)/\(Date().today)/avg", value: avg)
    }
    
    func saveHeartRate(at time: Int, min: Int, max: Int) {
        setValue(uri: "HeartRate/\(User.shared.uid!)/\(Date().today)/\(time)", value: ["min" : min, "max" : max])
    }
    
    // MARK: - Get Data from Database
    func getHeartRatesFrom(on date: Date, complete: @escaping (Error?, DataSnapshot) -> Void) {
        getValue(uri: "HeartRate/\(User.shared.uid!)/\(date.toString(dateFormat: "yyyy-MM-dd"))", complete: complete)
    }
    
    func getStudyTimeFrom(on date: Date, complete: @escaping (Error?, DataSnapshot) -> Void) {
        getValue(uri: "StudyTime/\(User.shared.uid!)/\(date.toString(dateFormat: "yyyy-MM-dd"))", complete: complete)
    }
    
    // MARK: - Default functions
    
    func setValue(uri: String, value: Any) {
        self.databaseRef.child(uri).setValue(value)
    }
    
    func getValue(uri: String, complete: @escaping (Error?, DataSnapshot) -> Void) {
        self.databaseRef.child(uri).getData(completion: complete)
    }
}
