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
        
        let time = [K.healthKit.daily,K.healthKit.weekly,K.healthKit.monthly]
        
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        
        for t in time {
            storeStepData(SampleType: stepSample, SortDescriptor: sortDescriptor, Time: t)
            storeExerciseData(SampleType: exerciseSample,SortDescriptor: sortDescriptor, Time: t)
            storeEnergyBurned(SampleType: energySample, SortDescriptor: sortDescriptor, Time: t)
            
        }
        
    }
    
    
    func storeStepData(SampleType sampleType: HKQuantityType, SortDescriptor sortDescriptor: NSSortDescriptor, Time time: Int) {
        let predicate = HKQuery.predicateForSamples(withStart: getStartDate(From: time), end: Date(), options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                self.steps = 0.00
                if result!.count > 0 {
                    for temp in result!{
                        let data = temp as! HKQuantitySample
                        let unit = HKUnit(from: "count")
                        let step = data.quantity.doubleValue(for: unit)
                        self.steps += step
                    }
                }
            }
            if time == K.healthKit.daily{
                self.defaults.setValue(self.steps, forKey: K.healthKit.dSteps)
            }else if time == K.healthKit.weekly{
                self.defaults.setValue(self.steps, forKey: K.healthKit.wSteps)
            }else if time == K.healthKit.monthly{
                self.defaults.setValue(self.steps, forKey: K.healthKit.mSteps)
            }
            
            //print(("total steps test \(self.steps)"))
            //print("if steps = 0? because you need to connect it to your pysical phone to read data, ;D")
        }
        healthStore.execute(query)
    }
    
    
    func storeExerciseData(SampleType sampleType: HKQuantityType, SortDescriptor sortDescriptor: NSSortDescriptor, Time time: Int) {
        let predicate = HKQuery.predicateForSamples(withStart: getStartDate(From: time), end: Date(), options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                self.exerciseTime = 0.00
                if result!.count > 0{
                    for temp in result!{
                        let data = temp as! HKQuantitySample
                        let unit = HKUnit(from: "min")
                        let time = data.quantity.doubleValue(for: unit)
                        self.exerciseTime += time
                    }
                }
                }
            if time == K.healthKit.daily{
                self.defaults.setValue(self.exerciseTime, forKey: K.healthKit.dExerciseTime)
            }else if time == K.healthKit.weekly{
                self.defaults.setValue(self.exerciseTime, forKey: K.healthKit.wExerciseTime)
            }else if time == K.healthKit.monthly{
                self.defaults.setValue(self.exerciseTime, forKey: K.healthKit.mExerciseTime)
            }
            }
        healthStore.execute(query)
    }
    
    func storeEnergyBurned(SampleType sampleType: HKQuantityType, SortDescriptor sortDescriptor: NSSortDescriptor, Time time: Int) {
        let predicate = HKQuery.predicateForSamples(withStart: getStartDate(From: time), end: Date(), options: .strictEndDate)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            if let e = error{
                print("error \(e)")
            }else{
                self.eneryBurned = 0.00
                if result!.count > 0{
                    for temp in result!{
                        let data = temp as! HKQuantitySample
                        let unit = HKUnit(from: "kcal")
                        let calBurned = data.quantity.doubleValue(for: unit)
                        self.eneryBurned += calBurned
                    }
                }
                }
            if time == K.healthKit.daily{
                self.defaults.setValue(self.eneryBurned, forKey: K.healthKit.dEnergyBurned)
            }else if time == K.healthKit.weekly{
                self.defaults.setValue(self.eneryBurned, forKey: K.healthKit.wEnergyBurned)
            }else if time == K.healthKit.monthly{
                self.defaults.setValue(self.eneryBurned, forKey: K.healthKit.mEnergyBurned)
            }
            }
        healthStore.execute(query)
    }
    
    func getStartDate(From from: Int) -> Date?{
        
        let startDate = Calendar.current.date(byAdding: .day, value: from, to: Date())
        
        return startDate
    }
    func getDailySteps() -> Double{
       return defaults.double(forKey: K.healthKit.dSteps)
}
    func getWeeklySteps() -> Double{
        return defaults.double(forKey: K.healthKit.wSteps)
    }
    func getMonthlySteps() -> Double{
        return defaults.double(forKey: K.healthKit.mSteps)
    }
    func getDailyExercise() -> Double{
        return defaults.double(forKey: K.healthKit.dExerciseTime)
    }
    func getWeeklyExercise() -> Double{
        return defaults.double(forKey: K.healthKit.wExerciseTime)
    }
    func getMonthlyExercise() -> Double{
        return defaults.double(forKey: K.healthKit.mExerciseTime)
    }
    func getDailyEnergyBurned() -> Double{
        return defaults.double(forKey: K.healthKit.dEnergyBurned)
    }
    func getWeeklyEnergyBurned() -> Double{
        return defaults.double(forKey: K.healthKit.wEnergyBurned)
    }
    func getMonthlyEnergyBurned() -> Double{
        return defaults.double(forKey: K.healthKit.mEnergyBurned)
    }

    
    
}
