//
//  BMIRecords.swift
//  BMITrackingApp
//
//  Created by Shrinal Patel on 17/12/21.
//  Final Exam for MAPD714 - iOS Development
//  Description: This is a simple BMI Calculator app to calculate BMI In both Standard and Imperial units. It also supports persistant data storage.

import Foundation
import CoreData

@objc(BMIRecords)

class BMIRecords: NSManagedObject {

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: String?
    @NSManaged public var date: String?
    @NSManaged public var height: Float
    @NSManaged public var weight: Float
    @NSManaged public var bmi: Float
}


