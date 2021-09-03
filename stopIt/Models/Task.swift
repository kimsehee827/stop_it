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

class TaskModel {
    var tasks: [Task] = [
        Task(title: "example1", completed: false),
        Task(title: "example2", completed: false)
      ] // 최대 2개로 고정
    
    static let today = TaskModel()
    static let yesterday = TaskModel()
    
    private init() {}
    
    func saveToDB() {
        // TODO
        // 디비에 저장
    }
    
    func loadFromDB(complete: @escaping () -> Void) {
        // TODO
        // 디비에서 불러와서 complete함수 호출 (필요없으면 complete 지워도 됨)
    }
}

#if DEBUG
let testDataTasks = [
  Task(title: "example1", completed: false),
  Task(title: "example2", completed: false)
]
#endif
