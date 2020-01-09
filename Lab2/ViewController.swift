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

        db.insertSensor(name: "Name test", description: "DescTest")
        db.insertSensor(name: "test2", description: "test2")
        db.insertReading(date: Date(), value: 52, sensorId: 1)
        
        sensors = db.readSensors()
        
        readings = db.readReadings()
        
        print("Sensors from DB")
    
        for sensor in sensors {
            print(sensor.name + " " + sensor.description)
        }
        
        
        print("Readings from DB")
        
        for reading in readings {
            print(reading.date)
        }
        
    }


}

