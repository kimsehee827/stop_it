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
    
    private init() {}
    
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

