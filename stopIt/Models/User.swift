//
//  User.swift
//  Front
//
//  Created by 오인경 on 2021/08/15.
//

import Foundation

class User {
    // 사용자 정보
    // 공부시간, 심박수, UserID, 이메일 주소, 시작시간, 종료시간, 잠든시간 등등,,
    static let shared = User()
    
    let heartRateModel = HeartRateModel.shared
    let studyTimeModel = StudyTimeModel.shared
    
    var uid: String!
    var email: String!
    var isSignIn: Bool = false
    
    private init() {}
    
    func loginHandler(uid: String, email: String) {
        isSignIn = true
        
        self.uid = uid
        self.email = email
        
        HeartRateModel.shared.getHeartRateFromHK {
            print("get heart rate complete")
            HeartRateModel.shared.storeHeartRate(results: HeartRateModel.shared.heartRate)
            HeartRateModel.shared.saveTodayHeartRate()
            StudyTimeModel.shared.getStudyTimeFromDB(on: Date.getToday()) { studyTime in
                StudyTimeModel.shared.todayStudyTime = studyTime
                StudyTimeModel.shared.sortRest()
                
                HeartRateModel.shared.getAdditionalRest()
            }
        }
        
        print("login handler")

    }
    
    func logOutHandler() {
        isSignIn = false
        
        self.uid = nil
        self.email = nil
    }
    
    func getTotalHeartRate() -> [HeartRate] { 
        return heartRateModel.heartRate
    }
    
    func getHeartRateMinMax() -> [Int: HeartRateMinMax] {
        heartRateModel.storeHeartRate(results: getTotalHeartRate())
        return heartRateModel.heartRateMinMaxPerHour
    }
    
    func getAvgHeartRate() -> Double {
        return heartRateModel.averageHeartRate ?? 0
    }
    
}
