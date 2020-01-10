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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testSqlLite()
        
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
            let date = generateRandomDate(daysBack: 100)
            
            db.insertReading(date: date!, value: value, sensorId: sensorId)
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

