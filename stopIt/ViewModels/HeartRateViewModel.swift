import Foundation

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: [Int : HeartRateMinMax] = [:]
    @Published var min: Int = 0
    @Published var max: Int = 0
    @Published var avg: Int = 0
    @Published var underline: Double = 0
    
    func appear() {
        self.getTodayHeartRate()
    }
    
    func getHeartRate(on date: Date) {
        if date == Date().onlyDate! {
            self.getTodayHeartRate()
        } else {
            self.getOtherDateHeartRate(on: date)
        }
    }
    
    private func getTodayHeartRate() {
        HeartRateModel.shared.getHeartRateFromHK {
            DispatchQueue.main.async {
                self.heartRate = User.shared.getHeartRateMinMax()
                self.getMinMax()
                self.avg = Int(User.shared.getAvgHeartRate())
                HeartRateModel.shared.getAdditionalRest()
                if let underline = HeartRateModel.shared.underline {
                    self.underline = underline
                }
            }
            
            
        }
    }
    
    private func getOtherDateHeartRate(on date: Date) {
        DatabaseModel.shared.getHeartRatesFrom(on: date) { [weak self] error, snapshot in
            if let error = error {
                print("Error on HeartRateViewModel.getOtherDateHeartRate()")
                print(error)
            } else if snapshot.exists() {
                print("exist")
                let value = snapshot.value as? NSDictionary
                let avg = value?["avg"] as? Int
                var minmax: [Int: HeartRateMinMax] = [:]
                for (key, val) in value! {
                    if key as! String != "avg" {
                        minmax[Int(key as! String)!] = HeartRateMinMax(min: (val as! NSDictionary)["min"] as! Int, max: (val as! NSDictionary)["max"] as! Int)
                    }
                }
                
                DispatchQueue.main.async {
                    self?.avg = avg!
                    self?.heartRate = minmax
                    self?.getMinMax()
                }

            } else {
                DispatchQueue.main.async {
                    self?.avg = 0
                    self?.heartRate = [:]
                    self?.min = 0
                    self?.max = 0
                }
            }
        }
    }
    
    func getMinMax() {
        guard self.heartRate.count != 0 else {
            return
        }
        
        min = Int.max
        max = Int.min
        
        for (_, val) in heartRate {
            if min > val.min && val.min > 0 {
                min = val.min
            }
            if max < val.max {
                max = val.max
            }
        }
    }
}
