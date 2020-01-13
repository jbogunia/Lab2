import UIKit
import os.log


class ReadingA: NSObject, NSCoding {
    
    //MARK: Properties
    
    var date: Double
    var sensorId: Int
    var value: Float
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("readings")
    
    //MARK: Types
    
    struct PropertyKey {
        static let date = "date"
        static let sensorId = "sensorId"
        static let value = "value"
    }
    
    //MARK: Initialization
    
    init?(date: Double, sensorId: Int, value: Float) {
        
        // The name must not be empty

        
        // Initialize stored properties.
        self.date = date
        self.sensorId = sensorId
        self.value = value
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(sensorId, forKey: PropertyKey.sensorId)
        aCoder.encode(value, forKey: PropertyKey.value)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let date = aDecoder.decodeDouble(forKey: PropertyKey.date) as? Double else {
            os_log("Unable to decode the date for a ReadingA object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let sensorId = aDecoder.decodeInteger(forKey: PropertyKey.sensorId) as? Int else {
            os_log("Unable to decode the value for a ReadingA object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let value = aDecoder.decodeFloat(forKey: PropertyKey.value) as? Float else {
            os_log("Unable to decode the value for a ReadingA object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(date: date, sensorId: sensorId, value: value)
    }
}

