//
//  StepCountModel.swift
//  Front
//
//  Created by 오인경 on 2021/08/24.
//

import Foundation
import HealthKit

struct StepData{
    var strDate: Date
    var endDate: Date
    var steps: Int
}

struct StepSum {
    var date: Date
    var steps: Int
}

class StepCountModel{
    static let shared=StepCountModel()
    var stepData: [StepData] = []
    var stepSum: [StepSum] = []
    var restDate: [Rest]=[]
    
    private init() {}
    
    func getSteps(complete: @escaping ()-> Void) {
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)
             else {
                 return
         }

        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictStartDate)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: nil) { (hkSampleQuery,hkSampleArray,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return;
                }
                for sample: HKQuantitySample in (hkSampleArray as? [HKQuantitySample]) ?? []{
                    print(sample.quantity.doubleValue(for: .count()))
                }
                self.stepData += self.getStepDataArr(results: hkSampleArray!)

                complete()
            }
        HKHealthStore().execute(query)

    }
    
    func getStepDataArr(results: [HKSample]) -> [StepData]{
        var stepTmp: [StepData]=[]
        for result in results {
            let data=result as! HKQuantitySample
            stepTmp.append(StepData(strDate: result.startDate, endDate:result.endDate, steps:Int(data.quantity.doubleValue(for: .count()))))
        }
        return stepTmp
    }
    
    
    /// getSteps() 이후에 호출
    func makeDayStepData() {
        let today = Date()
        var idx=0

        for i in -7 ... -1{//지난 7일간의 휴식시간 구하기
            let day = Calendar.current.date(byAdding: .day, value: i, to: today)!
            StudyTimeModel.shared.getStudyTimeFromDB(on: day){st in
                if((st) != nil){
                    for rest in st!.rests{
                        self.restDate.append(rest)
                    }
                }
            }
        }
        for rest in self.restDate{
            print(rest.start.toString())
        }
        
        
        for rest in restDate{ //휴식시간의 걸음수
            var count=0
            for _ in 0..<stepData.count{ //걸음수 계산
                let startTarget = Calendar.current.dateComponents([.day, .hour, .minute, .second], from:rest.start)
                let endTarget = Calendar.current.dateComponents([.day, .hour, .minute, .second], from:rest.end!)
                let startDate = Calendar.current.dateComponents([.day, .hour, .minute, .second], from:stepData[idx].strDate)
                let endDate = Calendar.current.dateComponents([.day, .hour, .minute, .second], from:stepData[idx].endDate)
                
                let include=includeTime(startTarget, endTarget, startDate, endDate)
                if(idx < stepData.count && include){
                    count+=stepData[idx].steps
                    idx+=1
                }
            }
            stepSum.append(StepSum(date: stepData[idx].strDate, steps: count))
        }
    }

    func includeTime(_ startT: DateComponents, _ endT: DateComponents, _ startD: DateComponents, _ endD: DateComponents) -> Bool{
        if(startT.day != startD.day){
            return false
        }
        
        else if(startT.hour!>startD.hour! && endT.hour!<endD.hour!){
            return true
        }
        
        else if(startT.hour==startD.hour && startT.minute!<startD.minute! && endT.hour==endD.hour && endT.minute!<endD.minute!){
            return true
        }
        
        else if(startT.hour==startD.hour && startT.minute==startD.minute && startT.second!<=startD.second! && endT.hour==endD.hour && endT.minute==endD.minute && endT.second!<=endD.second!){
            return true
        }
        
        else{
            return false
        }
    }
}
   
