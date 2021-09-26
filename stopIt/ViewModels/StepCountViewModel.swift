import Foundation
import HealthKit

class StepCountViewModel: ObservableObject {
    // @Published var stepCount: [Date : Double] = [:]

    @Published var stepCount: [StepData]=[]
    @Published var stepSum: [StepSum] = []
    
    init() {
        for i in -7 ... -1{//지난 7일간의 휴식시간 구하기
            let today = Date()
            let day = Calendar.current.date(byAdding: .day, value: i, to: today)!
            self.stepSum.append(StepSum(date: day, steps: 0))
        }
    }
    
    func getCounts() {
        StepCountModel.shared.getSteps(complete: {
            DispatchQueue.main.async {
                //self.stepCount[date] = steps
                self.stepCount=StepCountModel.shared.stepData
                
                StepCountModel.shared.makeDayStepData()
                
                //self.stepSum=StepCountModel.shared.stepSum

                for step in StepCountModel.shared.stepSum{
                    let date=step.date
                    let target = Calendar.current.dateComponents([.day], from:date, to:Date())
                    self.stepSum[6-(target.day!-1)].steps+=step.steps
                }
            }
        })

    }
    
}

