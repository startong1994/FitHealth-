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
    
    let dispatchGroup = DispatchGroup()
    let healthStore = HKHealthStore()
    let defaults = UserDefaults.standard
    
    var steps: Double = 0.00
    var exerciseTime: Double = 0.00
    var eneryBurned: Double = 0.00
    
    
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
        
        guard let stepSample = HKObjectType.quantityType(forIdentifier: .stepCount) else{
            print("error getting steps")
            return
        }
        guard let exerciseSample = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else{
            print("error getting steps")
            return
        }
        guard let energySample = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else{
            print("error getting steps")
            return
        }
        
        
        
        
        let predicate = HKQuery.predicateForSamples(withStart: getStartDate(From: -1), end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        storeStepData(SampleType: stepSample, Predicate: predicate, SortDescriptor: sortDescriptor)
        storeExerciseData(SampleType: exerciseSample, Predicate: predicate, SortDescriptor: sortDescriptor)
        storeEnergyBurned(SampleType: energySample, Predicate: predicate, SortDescriptor: sortDescriptor)
        
    }
    
    
    func storeStepData(SampleType sampleType: HKQuantityType, Predicate predicate: NSPredicate, SortDescriptor sortDescriptor: NSSortDescriptor) {
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                if result!.count > 0 {
                    self.steps = 0.00
                    for temp in result!{
                        let data = temp as! HKQuantitySample
                        let unit = HKUnit(from: "count")
                        let step = data.quantity.doubleValue(for: unit)
                        self.steps += step
                    }
                }
            }
            self.defaults.setValue(self.steps, forKey: K.healthKit.steps)
            print(("total steps test \(self.steps)"))
            print("if steps = 0? because you need to connect it to your pysical phone to read data, ;D")
        }
        healthStore.execute(query)
    }
    
    
    func storeExerciseData(SampleType sampleType: HKQuantityType, Predicate predicate: NSPredicate, SortDescriptor sortDescriptor: NSSortDescriptor) {
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                if result!.count > 0{
                    for temp in result!{
                        self.exerciseTime = 0.00
                        let data = temp as! HKQuantitySample
                        let unit = HKUnit(from: "min")
                        let time = data.quantity.doubleValue(for: unit)
                        self.exerciseTime += time
                    }
                }
                }
            self.defaults.setValue(self.exerciseTime, forKey: K.healthKit.exerciseTime)
            print("exercise  \(self.exerciseTime) mins")
            }
        healthStore.execute(query)
    }
    
    func storeEnergyBurned(SampleType sampleType: HKQuantityType, Predicate predicate: NSPredicate, SortDescriptor sortDescriptor: NSSortDescriptor) {
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                if result!.count > 0{
                    for temp in result!{
                        let data = temp as! HKQuantitySample
                        let unit = HKUnit(from: "kcal")
                        let calBurned = data.quantity.doubleValue(for: unit)
                        self.eneryBurned += calBurned
                    }
                }
                
                }
            self.defaults.setValue(self.eneryBurned, forKey: K.healthKit.energyBurned)
            print("enerty Burned today  \(self.eneryBurned) Cal")
            }
        healthStore.execute(query)
    }
    
    func getStartDate(From from: Int) -> Date?{
        
        let startDate = Calendar.current.date(byAdding: .day, value: from, to: Date())
        
        return startDate
    }
    
}
