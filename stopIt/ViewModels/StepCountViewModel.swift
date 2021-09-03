import Foundation
import HealthKit

class StepCountViewModel: ObservableObject {
    // @Published var stepCount: [Date : Double] = [:]

    @Published var stepCount: [StepData]=[]
    @Published var stepSum: [StepSum] = []
    
    init() {
        for _ in 0..<7 {
            self.stepSum.append(StepSum(date: Date(), steps: 0))
        }
    }
    
    func getCounts() {
        StepCountModel.shared.getSteps(complete: {
            DispatchQueue.main.async {
                //self.stepCount[date] = steps
                self.stepCount=StepCountModel.shared.stepData
                
                StepCountModel.shared.makeDayStepData()
                
                self.stepSum = StepCountModel.shared.stepSum
            }
        })
        

    }
    
}
