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
    
    func saveLastCalcTime(time: Date?) {
        setValue(uri: "StudyTime/\(User.shared.uid!)/\(Date().today)/lastCalcTime", value: time?.toString() ?? "")
    }
    
    func saveAverageHeartRate(date: Date, avg: Int) {
        setValue(uri: "HeartRate/\(User.shared.uid!)/\(Date().today)/avg", value: avg)
    }
    
    func saveHeartRate(at time: Int, min: Int, max: Int) {
        setValue(uri: "HeartRate/\(User.shared.uid!)/\(Date().today)/\(time)", value: ["min" : min, "max" : max])
    }
    
    func saveTask(date: Date, isToday: Bool, task: [Task]) {
        let day = isToday ? "today" : "yesterday"
        setValue(uri: "ToDo/\(User.shared.uid!)/\(day)/date", value: date.toString(dateFormat: "yyyy-MM-dd"))
        setValue(uri: "ToDo/\(User.shared.uid!)/\(day)/first/title", value: task[0].title)
        setValue(uri: "ToDo/\(User.shared.uid!)/\(day)/first/checked", value: task[0].completed)
        setValue(uri: "ToDo/\(User.shared.uid!)/\(day)/second/title", value: task[1].title)
        setValue(uri: "ToDo/\(User.shared.uid!)/\(day)/second/checked", value: task[1].completed)
    }
    
    
    // MARK: - Get Data from Database
    func getHeartRatesFrom(on date: Date, complete: @escaping (Error?, DataSnapshot) -> Void) {
        getValue(uri: "HeartRate/\(User.shared.uid!)/\(date.toString(dateFormat: "yyyy-MM-dd"))", complete: complete)
    }
    
    func getStudyTimeFrom(on date: Date, complete: @escaping (Error?, DataSnapshot) -> Void) {
        getValue(uri: "StudyTime/\(User.shared.uid!)/\(date.toString(dateFormat: "yyyy-MM-dd"))", complete: complete)
    }
    
    func getTask(isToday: Bool, complete: @escaping (Error?, DataSnapshot) -> Void) {
        let day = isToday ? "today" : "yesterday"
        getValue(uri: "ToDo/\(User.shared.uid!)/\(day)", complete: complete)
    }
    
    // MARK: - Default functions
    
    func setValue(uri: String, value: Any) {
        self.databaseRef.child(uri).setValue(value)
    }
    
    func getValue(uri: String, complete: @escaping (Error?, DataSnapshot) -> Void) {
        self.databaseRef.child(uri).getData(completion: complete)
    }
}
