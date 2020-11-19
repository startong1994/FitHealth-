//
//  ActivityData.swift
//  FitHealthPlus
//
//  Created by xu daitong on 11/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation
import HealthKit


class ActivityData {
    
    let healthStore = HKHealthStore()
    
    
    func authorizeHleathkit(){
        let activityData = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
        healthStore.requestAuthorization(toShare: nil, read: activityData) { (check, error) in
            if let e = error{
                print("error on request Authorization \(e)")
            }
            else{
                print("permission granted")
            }
        }
        
    }
    func loadActivityData(){
        
//        var step: Int
//        var exerciseTime: Int
//        var CaloriesBurned: Int
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else{
            print("error getting steps")
            return
        }
        
        
        
        let predicate = HKQuery.predicateForSamples(withStart: getStartDate(From: -1), end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                let data = result![0] as! HKQuantitySample
                let unit = HKUnit(from: "count")
                let step = data.quantity.doubleValue(for: unit)
                print("most recently steps \(step)")
                
            }
        }
        healthStore.execute(query)
        
        
    }
    
    
    func getStartDate(From from: Int) -> Date?{
        
        let startDate = Calendar.current.date(byAdding: .day, value: from, to: Date())
        
        return startDate
    }
    
    
    
    
    
    
    
    
    
}
