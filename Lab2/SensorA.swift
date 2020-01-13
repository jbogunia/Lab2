
import UIKit
import os.log


class SensorA: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var descriptionn: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sensors")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let descriptionn = "descriptionn"
    }
    
    //MARK: Initialization
    
    init?(name: String, descriptionn: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        guard !descriptionn.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.descriptionn = descriptionn
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(descriptionn, forKey: PropertyKey.descriptionn)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a SensorA object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let descriptionn = aDecoder.decodeObject(forKey: PropertyKey.descriptionn) as? String else {
            os_log("Unable to decode the name for a SensorA object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, descriptionn: descriptionn)
    }
}
