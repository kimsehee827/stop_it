//
//  HealthKitModel.swift
//  Front
//
//  Created by 오인경 on 2021/08/15.
//

import Foundation
import HealthKit

class HealthKitModel {
    static let shared = HealthKitModel()
    let healthKitStore = HKHealthStore()
    
    private init() {
        
    }
    
    private enum HealthKitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        
        guard let rate = HKObjectType.quantityType(forIdentifier: .heartRate), let step = HKCategoryType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [rate, step]
            
        HealthKitModel.shared.healthKitStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead, completion: completion)
    }
}
