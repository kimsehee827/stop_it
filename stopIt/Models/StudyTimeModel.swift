//
//  StudyTimeModel.swift
//  Front
//
//  Created by 오인경 on 2021/08/19.
//

import Foundation

struct Rest {
    var start: Date
    var end: Date?
}

struct StudyTime {
    var startTime: Date
    var endTime: Date?
    var savedStudyTime: Int? // 디비에서 가져올때 쓰는 프로퍼티
    var totalStudyTime: Int? { // 오늘치 계산할때 쓰는 프로퍼티
        if endTime == nil && startTime.isToday {
            return Int(Date() - startTime)
        }
        return nil
    }
    var rests: [Rest] = []
    var savedRestTime: Int? // 디비
    var totalRestTime: Int? { // 오늘치
        guard rests.count != 0 else {
            return nil
        }
        
        var total = 0
        
        for rest in rests {
            if rest.end == nil {
                continue
            }
            
            total += Int(rest.end! - rest.start)
        }
        
        return total
    }
    var lastCalcTime: Date?
}

class StudyTimeModel {
    static var shared = StudyTimeModel()
    
    var todayStudyTime: StudyTime?
    
    private init() {}
    
    func startStudy() {
        self.todayStudyTime = StudyTime(startTime: Date())
    }
    
    /// rest 추가하려면 무조건 이걸로 해야 정렬됨.
    func addRests(rests: [Rest]) {
        for rest in rests {
            self.todayStudyTime?.rests.append(rest)
        }
        self.todayStudyTime?.lastCalcTime = Date()
        self.sortRest()
    }
    
    func sortRest() {
        self.todayStudyTime?.rests.sort(by: { $0.start < $1.start })
    }
    
    /// 앱 꺼질때 불러줘야함
    func saveTodayStudyTime() {
        guard let studyTime = todayStudyTime  else {
            return
        }
        
        DatabaseModel.shared.saveStudyStartTime(startTime: studyTime.startTime)
        DatabaseModel.shared.saveTotalStudyTime(time: studyTime.totalStudyTime ?? 0)
        DatabaseModel.shared.saveRestTime(restTime: studyTime.totalRestTime ?? 0)
        DatabaseModel.shared.saveStudyEndTime(endTime: studyTime.endTime)
        DatabaseModel.shared.saveLastCalcTime(time: studyTime.lastCalcTime)
        
        for rest in studyTime.rests {
            DatabaseModel.shared.saveRest(start: rest.start, end: rest.end)
        }
    }
    
    //dateformatter부분 삭제
    /// 앱 켜질때 오늘치 불러야함
    func getStudyTimeFromDB(on date: Date, complete: @escaping (StudyTime?) -> Void) {
        
        DatabaseModel.shared.getStudyTimeFrom(on: date) { error, dataSnapshot in
            if let error = error {
                print("Error in StudyTimeModel.getStudyTime()")
                print(error)
            } else if dataSnapshot.exists() {
                let value = dataSnapshot.value as? NSDictionary
                let startTime = value!["startTime"] as! String
                let endTime = value!["endTime"] as! String
                let studyTime = value!["studyTime"] as! Int
                let restTime = value!["restTime"] as! Int
                let rests = value!["rests"] as! NSDictionary
                let lastCalcTime = value!["lastCalcTime"] as! String
                
                var st = StudyTime(startTime: Date.fromString(str: startTime)!)
                st.endTime =  Date.fromString(str: endTime)!
                st.savedStudyTime = studyTime
                st.savedRestTime = restTime
                
                if lastCalcTime == "" {
                    st.lastCalcTime = nil
                } else {
                    st.lastCalcTime = Date.fromString(str: lastCalcTime)
                }
                
                for (start, end) in rests {
                    //print(start)
                    let restStart = Date.fromString(str: start as! String)!
                    var restEnd: Date?
                    if (end as! String) == "" {
                        restEnd = nil
                    } else {
                        restEnd = Date.fromString(str: (end as! String))!
                    }
                    st.rests.append(Rest(start: restStart, end: restEnd))
                }
                complete(st)
            } else {
                complete(nil)
            }
        }
    }
}
