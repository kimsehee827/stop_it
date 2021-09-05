import Foundation
import HealthKit


struct HeartRateMinMax {
    var min: Int
    var max: Int
}

struct HeartRate {
    var date: Date
    var heartRate: Double
}

class HeartRateModel {
    static let shared = HeartRateModel()
    
    var heartRateMinMaxPerHour: [Int: HeartRateMinMax] = [:] // [Time: HeartRateMinMax]
    var heartRate: [HeartRate] = []
    var averageHeartRate: Double?
    var sampleCount: Int = 0
    var lastFetchTime: Date?
    var underline: Double?
    
    private init() {}
    
    /// 휴식시간 구하기
    /// 외부에서 호출 가능.
    /// 앱이 켜지고 로그인이 되고, studyTime을 디비에서 불러오고, 그 이후 호출하면 됨.
    func getAdditionalRest() {
        guard let studyTime = StudyTimeModel.shared.todayStudyTime else {
            return
        }
        let onlyStudyTime = getOnlyStudyTime(studyTime: studyTime)
        let exceptRest = exceptRestHeartRate(rests: studyTime.rests, target: onlyStudyTime)
        let avg = getAvgHeartRateInStudyTime(heartRate: exceptRest)
        let rests = getSleepTimeAfterLastRest(avg: avg)
        
        self.underline = Double(avg) * 0.9
        
        StudyTimeModel.shared.addRests(rests: rests)
    }
    
    // self.heartRate에서 공부시간만 구하기
    private func getOnlyStudyTime(studyTime: StudyTime) -> [HeartRate] {
        let heartRate = self.heartRate
        let start = studyTime.startTime
        let end = studyTime.endTime
        
        var startIdx, endIdx: Int?
        
        for i in 0..<heartRate.count {
            if startIdx == nil && heartRate[i].date >= start {
                startIdx = i
            } else if startIdx != nil && endIdx == nil && end != nil && heartRate[i].date >= end! {
                endIdx = i - 1
                break
            }
        }
        
        if endIdx == nil {
            endIdx = heartRate.count - 1
        }
        
        return Array(heartRate[startIdx!...endIdx!])
    }
    
    // target 에서 휴식시간을 모두 제외하기
    private func exceptRestHeartRate(rests: [Rest], target: [HeartRate]) -> [HeartRate] {
        var heartRate = target
        
        for rest in rests {
            var startIdx, endIdx: Int?
            for i in 0..<heartRate.count {
                if startIdx == nil && heartRate[i].date >= rest.start {
                    startIdx = i
                } else if startIdx != nil && endIdx == nil && rest.end != nil && heartRate[i].date >= rest.end! {
                    endIdx = i - 1
                    break
                }
            }
            
            if startIdx == nil {
                continue
            }
            
            if endIdx == nil {
                endIdx = heartRate.count - 1
            }
            
            heartRate.removeSubrange(startIdx!...endIdx!)
        }
        
        return heartRate
    }
    
    // 휴식시간을 제외한 모든 공부시간의 심박수 평균 구하기
    private func getAvgHeartRateInStudyTime(heartRate: [HeartRate]) -> Int {
        var sum: Double = 0
        for rate in heartRate {
            sum += rate.heartRate
        }
        return Int(sum / Double(heartRate.count))
    }
    
    // 맨 마지막 측정시간 이후로 평균보다 10퍼센트 떨어진 심박수 구간 구하기.
    private func getSleepTimeAfterLastRest(avg: Int) -> [Rest] {
        let underline = Double(avg) * 0.9
        var lastCalcTime: Date?
        if let time = StudyTimeModel.shared.todayStudyTime?.lastCalcTime {
            lastCalcTime = time
        }
        
        var heartRate = self.heartRate
        
        if let lastCalcTime = lastCalcTime {
            var idx = -1
            for rate in heartRate {
                if rate.date <= lastCalcTime {
                    idx += 1
                } else {
                    break
                }
            }
            if idx != -1 {
                heartRate.removeSubrange(0...idx)
            }
        }
        
        var rests: [Rest] = []
        var check: Bool = false
        var start, end: Date?
        
        for rate in heartRate {
            if rate.heartRate <= underline {
                if check == false {
                    start = rate.date
                    check = true
                } else {
                    end = rate.date
                }
            } else if rate.heartRate > underline && check == true {
                if end == nil {
                    end = rate.date 
                }
                rests.append(Rest(start: start!, end: end))
                check = false
                start = nil
                end = nil
            }
        }
        
        return rests
    }
    
    func getHeartRateFromHK(complete: @escaping () -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let startDate = lastFetchTime ?? Date.getToday()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor], resultsHandler: { (sample, result, error) in
            guard error == nil else {
                return
            }
            
            guard let result = result else {
                return
            }
            
            self.heartRate = self.convertHKSampleToHeartRate(results: result)
            //self.storeHeartRate(results: self.heartRate)
            complete()
        })
        
        HealthKitModel.shared.healthKitStore.execute(query)
        // lastFetchTime = Date()
    }
    
    func saveTodayHeartRate() {
        guard let avg = self.averageHeartRate else {
            print("HeartRateModel.saveTodayHeartRate() : avg heart rate didn't exist")
            return
        }
        
        DatabaseModel.shared.saveAverageHeartRate(date: Date(), avg: Int(avg))
        
        for (key, val) in self.heartRateMinMaxPerHour {
            if val.min < 0 || val.max < 0 {
                continue
            }
            DatabaseModel.shared.saveHeartRate(at: key, min: val.min, max: val.max)
        }
    }
    
    
    func exceptHeartRatesOutOfPeriod(startDate: Date, endDate: Date) {
        var startIdx, endIdx: Int?
        for i in 0..<heartRate.count {
            if startIdx == nil && heartRate[i].date >= startDate {
                startIdx = i
            } else if startIdx != nil && endIdx == nil && heartRate[i].date >= endDate {
                endIdx = i - 1
                break
            }
        }
        
        if startIdx == nil {
            return
        }
        
        if endIdx == nil {
            endIdx = heartRate.count - 1
        }
        
        heartRate.removeSubrange(startIdx!...endIdx!)
    }
    
    func convertHKSampleToHeartRate(results: [HKSample]) -> [HeartRate] {
        var heartRate: [HeartRate] = []
        
        let unit = HKUnit(from: "count/min")
        for result in results {
            let data = result as! HKQuantitySample
            heartRate.append(HeartRate(date: result.startDate, heartRate: data.quantity.doubleValue(for: unit)))
        }
        
        return heartRate
    }
    
    func storeHeartRate(results: [HeartRate]) {
        guard results.count != 0 else {
            return
        }
        
        var hour: Int = Calendar.current.component(.hour, from: results[0].date)
        var front: Int = 0
        
        for (index, _) in results.enumerated() {
            if index + 1 >= results.count || Calendar.current.component(.hour, from: results[index + 1].date) != hour {
                let heartRateMinMax = getMinMax(results: Array(results[front..<index + 1]))
                if heartRateMinMaxPerHour[hour] != nil {
                    heartRateMinMaxPerHour[hour]!.min = min(heartRateMinMaxPerHour[hour]!.min, heartRateMinMax.min)
                    heartRateMinMaxPerHour[hour]!.max = max(heartRateMinMaxPerHour[hour]!.max, heartRateMinMax.max)
                } else {
                    heartRateMinMaxPerHour[hour] = heartRateMinMax
                }
                front = index + 1
                if (index + 1 < results.count) {
                    hour = Calendar.current.component(.hour, from: results[index + 1].date)
                }
            }
        }
        
        // calculate average
        var sum = 0.0
        for result in results {
            sum += result.heartRate
        }
        
        if self.averageHeartRate == nil {
            self.averageHeartRate = sum / Double(results.count)
        } else {
            averageHeartRate = (averageHeartRate! * Double(sampleCount) + sum) / Double(sampleCount + results.count)
        }
    }
    
    func getMinMax(results: [HeartRate]) -> HeartRateMinMax {
        guard results.count != 0 else {
            return HeartRateMinMax(min: -1, max: -2)
        }
        
        var min: Int = Int.max
        var max: Int = Int.min
        
        for result in results {
            let heartRate = result.heartRate
            
            if Int(heartRate) < min {
                min = Int(heartRate)
            }
            
            if Int(heartRate) > max {
                max = Int(heartRate)
            }
        }
        
        return HeartRateMinMax(min: min, max: max)
    }
}

