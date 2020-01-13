//
//  ViewController.swift
//  Lab2
//
//  Created by Jakub Bogunia on 09/01/2020.
//  Copyright © 2020 Jakub Bogunia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var db:DBHelper = DBHelper()
    var sensors:[Sensor] = []
    var readings:[Reading] = []
    var sensorsA:[SensorA] = []
    var readingsA:[ReadingA] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //testSqlLite()
        testArchiving()
    
        
    }
    
    
    func testArchiving() {
        
        for n in 1...20 {
            
            var sensorName = "";
            
            if(n<10) {
                sensorName = String(format: "S0%d", n)
            } else {
                sensorName = String(format: "S%d", n)
            }
            
            let sensorDescription = String(format: "Sensor number %d", n)
            
            let sensorA = SensorA(name: sensorName, descriptionn: sensorDescription)
            
            sensorsA.append(sensorA!)
        }
        
        saveSensorsA()
        
        
        for n in 1...20 {
            
            let value = Float.random(in: 1...100)
            let sensorId = Int.random(in: 0..<20)
            let date = (Date() - Double.random(in: 0...31556926)).timeIntervalSince1970
            let readingA = ReadingA(date: date, sensorId: sensorId, value: value)
            readingsA.append(readingA!)
        }
        
        
        saveReadingsA()
        
        sensorsA = []
        readingsA = []
        
        sensorsA = loadSensorsA()
        readingsA = loadReadingsA()
        
        averageReadingA()
        sensorAverageReadingA()
        
    
        //
    }
    
    private func saveSensorsA() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(sensorsA, toFile: SensorA.ArchiveURL.path)
        if isSuccessfulSave {
            print("Sensors successfully saved.")
        } else {
            print("Failed to save sensors")
        }
    }
    
    private func saveReadingsA() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(readingsA, toFile: ReadingA.ArchiveURL.path)
        if isSuccessfulSave {
            print("Readings successfully saved.")
        } else {
            print("Failed to save readings")
        }
    }
    
    private func loadSensorsA() -> [SensorA]  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: SensorA.ArchiveURL.path) as! [SensorA]
    }
    
    private func loadReadingsA() -> [ReadingA]  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ReadingA.ArchiveURL.path) as! [ReadingA]
    }
    
    private func averageReadingA() {
        var average:Float = 0.0
        
        if !readingsA.isEmpty {
            for readingA in readingsA {
                average += readingA.value
            }
        }
        
        average = average/Float(readingsA.count)
        
       print("Average records value is: \(average)")
    }
    
    private func sensorAverageReadingA() {
        
        
        var sensors:[Int] = []
        var average:[Float] = Array(repeating: 0.0, count: 20)
        
        if !readingsA.isEmpty {
            readingsA.forEach { readingA in
        
                if(sensors.contains(readingA.sensorId)) {
                    average[readingA.sensorId] = (average[readingA.sensorId] + readingA.value)/2
                } else {
                    sensors.append(readingA.sensorId)
                    //average.insert(readingA.value, at: readingA.sensorId)
                    average[readingA.sensorId] = readingA.value
                }
            }
        }
        
        
        var i = 0;
        average.forEach { avg in
        i += 1
        if(avg != 0.0) {
            print("Average value for sensor \(i) is \(avg)")
        }
        }
        
    
    }
    
    func testSqlLite() {
        
        
        for n in 1...20 {
            
            var sensorName = "";
            
            if(n<10) {
                sensorName = String(format: "S0%d", n)
            } else {
                sensorName = String(format: "S%d", n)
            }
            
            let sensorDescription = String(format: "Sensor number %d", n)
            
            db.insertSensor(name: sensorName, description: sensorDescription)
        }
        
       for n in 1...20 {
            
            let value = Float.random(in: 1...100)
            let sensorId = Int.random(in: 0..<20)
            let date = (Date() - Double.random(in: 0...31556926)).timeIntervalSince1970
            
            db.insertReading(date: date, value: value, sensorId: sensorId)
        }
        
        
        
    
       // db.insertReading(date: Date(), value: 52, sensorId: 1)
    
        sensors = db.readSensors()
    
        readings = db.readReadings()
    
        print("Sensors from DB")
    
        for sensor in sensors {
        print(sensor.name + " " + sensor.description)
        }
    
    
        print("Readings from DB")
    
        for reading in readings {
            print("Reading value: \(reading.value), sensorId: \(reading.sensorId), date: \(reading.date)")
        }
        
        print("Average value= \(db.getAvg())")
        
        db.getSensorAvg()
        
        db.getLowest()
        db.getLargest()
    
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -1 * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }


}

