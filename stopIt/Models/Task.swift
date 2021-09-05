//
//  Task.swift
//  Front
//
//  Created by 오인경 on 2021/08/27.
//

import Foundation

struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var completed: Bool
}

let emptyTask = [
    Task(title: "", completed: false),
    Task(title: "", completed: false)
]

class TaskModel {
    var tasks: [Task] = [
        Task(title: "", completed: false),
        Task(title: "", completed: false)
      ] // 최대 2개로 고정
    var isToday: Bool
    
    static let today = TaskModel(isToday: true)
    static let yesterday = TaskModel(isToday: false)
    
    private init(isToday: Bool) {
        self.isToday = isToday
    }
    
    // 앱 닫을 때 호출
    func saveToDB() {
        // TODO
        // 디비에 저장
        let date = isToday ? Date.getToday() : Date.getYesterday()
        DatabaseModel.shared.saveTask(date: date, isToday: self.isToday, task: self.tasks)
    }
    
    // 디비 초기화 후 언제든 호출 가능
    func loadFromDB(complete: @escaping () -> Void) {
        // TODO
        // 디비에서 불러와서 complete함수 호출 (필요없으면 complete 지워도 됨)
        DatabaseModel.shared.getTask(isToday: isToday) { error, data in
            guard data.exists() else {
                self.saveToDB()
                complete()
                return
            }
            
            let task = data.value as! NSDictionary
            let first = task["first"] as! NSDictionary
            let second = task["second"] as! NSDictionary
            
            let firstTitle = first["title"] as! String
            let firstCompleted = first["checked"] as! Bool
            let secondTitle = second["title"] as! String
            let secondCompleted = second["checked"] as! Bool
            
            
            self.tasks = []
            self.tasks.append(Task(title: firstTitle, completed: firstCompleted))
            self.tasks.append(Task(title: secondTitle, completed: secondCompleted))
            
            complete()
        }
    }
    
    /// 디비 초기화 부분. 앱 켜질때 호출 해야함.
    static func setDB(complete: @escaping () -> Void) {
        DatabaseModel.shared.getTask(isToday: true) { error , data in
            guard error == nil else {
                print("Error in TaskModel.setDB(): \(error!.localizedDescription)")
                return
            }
            
            guard data.exists() else {
                print("Error in TaskModel.setDB(): No Data")
                complete()
                return
            }
            
            let todayTask = data.value as! NSDictionary
            let date = todayTask["date"] as! String
            
            // 오늘이 아니고 어제이면 -> 어제걸로 변경
            if date == Date.getYesterday().toString(dateFormat: "yyyy-MM-dd") {
                let task = TaskModel(isToday: true)
                task.loadFromDB {
                    task.isToday = false
                    task.saveToDB()
                }
                DatabaseModel.shared.saveTask(date: Date.getToday(), isToday: true, task: emptyTask)
            } else if date != Date.getToday().toString(dateFormat: "yyyy-MM-dd") {  // 오늘이 아니고 어제도 아니면
                // 어제 오늘 다 없앰.
                DatabaseModel.shared.saveTask(date: Date.getYesterday(), isToday: false, task: emptyTask)
                DatabaseModel.shared.saveTask(date: Date.getToday(), isToday: true, task: emptyTask)
            }
            
            complete()
        }
    }
}

#if DEBUG
let testDataTasks = [
  Task(title: "example1", completed: false),
  Task(title: "example2", completed: false)
]
#endif
