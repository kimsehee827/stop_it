//
//  SleepModel.swift
//  Front
//
//  Created by 오인경 on 2021/08/21.
//

import Foundation
import HealthKit

class SleepModel {
    static let shared = SleepModel()
    
    private init() {
        
    }
    
    /// 설명을 적어줌
    func getSleepAnalysis() {
        guard let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }
        
        let startDate = Date.getToday()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor], resultsHandler: { (sample, result, error) in
            guard error == nil else {
                return
            }
            
            guard let result = result else {
                return
            }
            
            print("sleep")
        })
        
        HealthKitModel.shared.healthKitStore.execute(query)
    }
}
