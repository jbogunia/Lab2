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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db.createTable()
        db.insertSensor(name: "test", description: "test")
        db.insertSensor(name: "test2", description: "test2")
        
        sensors = db.readSensors()
        
        print(sensors)
    }


}

