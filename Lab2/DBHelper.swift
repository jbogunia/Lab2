
import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        
        db = openDatabase()
        dropSensorTable()
        dropReadingsTable()
        createSensorTable()
        createReadingsTable()
        
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createSensorTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS sensor(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("sensor table created.")
            } else {
                print("sensor table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createReadingsTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS reading(id INTEGER PRIMARY KEY AUTOINCREMENT,date INTEGER, value REAL, sensorId INTEGER, FOREIGN KEY (sensorId) REFERENCES Sensor (id));"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("readings table created.")
            } else {
                print("readings table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertSensor(name:String, description:String)
    {
        let sensors = readSensors()
        for s in sensors
        {
            if s.name == name
            {
                return
            }
        }
        
        let insertStatementString = "INSERT INTO sensor (name, description) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (description as NSString).utf8String, -1, nil)
            
            //if sqlite3_step(insertStatement) == SQLITE_DONE {
             //   print("Successfully inserted row.")
            //} else {
              //  print("Could not insert row.")
            //}
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertReading(date:Double, value:Float, sensorId:Int)
    {
        let readings = readReadings()
        //for r in readings
        //{
          //  if r.date == date
            //{
              //  return
            //}
        //}
        
 //       let df = DateFormatter()
 //       df.dateFormat = "yyyy-MM-dd hh:mm:ss"
 //       let dateInsert = df.string(from: date)
        
        let insertStatementString = "INSERT INTO reading (date, value, sensorId) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(date))
            sqlite3_bind_double(insertStatement, 2, Double(value))
            sqlite3_bind_int(insertStatement, 3, Int32(sensorId))
            
            //if sqlite3_step(insertStatement) == SQLITE_DONE {
             //   print("Successfully inserted row.")
            //} else {
              //  print("Could not insert row.")
            //}
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readSensors() -> [Sensor] {
        let queryStatementString = "SELECT * FROM sensor;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Sensor] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                psns.append(Sensor(name: name, description: description))
                print("Query Result:")
                print("\(name) | \(description)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func readReadings() -> [Reading] {
        let queryStatementString = "SELECT * FROM reading;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Reading] = []
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                //let date = df.date(from: String(describing: String(cString: sqlite3_column_text(queryStatement, 1))))
                
                let value = Float(sqlite3_column_double(queryStatement, 2))
                let sensorId = Int(sqlite3_column_int(queryStatement, 3))
                let date = Int(sqlite3_column_int(queryStatement, 1))
                psns.append(Reading(date: date, value: value, sensorId: sensorId))
            }
        } else {
            print("SELECT reading statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func getAvg() {
        
        let startTime = NSDate()
        var average : Float = 0 ;
        
        let queryStatementString = "SELECT AVG(value) FROM reading;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                average = Float(sqlite3_column_double(queryStatement, 0))
            }
        } else {
            print("AVERAGE reading statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        print("Average value: \(average)")
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        
        print("Time required to average: \(measuredTime)")

        
    }
    
    func getSensorAvg() {
        
        let startTime = NSDate()
        let queryStatementString = "SELECT sensor.name, AVG(reading.value) as average FROM sensor INNER JOIN reading ON sensor.id = reading.sensorId GROUP BY sensor.name;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let average = Float(sqlite3_column_double(queryStatement, 1))
                print("\(name) avg: \(average)")
            }
        } else {
            print("AVERAGE reading statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        
        print("Time required to get average by sensor: \(measuredTime)")
        
    }
    
    func getLargest() {
        
        let startTime = NSDate()
        //Fix date to integer
        let queryStatementString = "SELECT MAX(date) from reading;"
        var queryStatement: OpaquePointer? = nil
        
 //Specify your format that you want
//        let strDate = dateFormatter.string(from: date)
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {

                let date = Double(sqlite3_column_int(queryStatement, 0))
                
                let dateToFormat = Date(timeIntervalSince1970: date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let formattedDate = dateFormatter.string(from: dateToFormat)
                print("Largest date is: \(formattedDate)")
            }
        } else {
            print("AVERAGE reading statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        
        print("Time required to get largest date: \(measuredTime)")
    }
    
    func getLowest() {
        
        let startTime = NSDate()
        //Fix date to integer
        let queryStatementString = "SELECT MIN(date) from reading;"
        var queryStatement: OpaquePointer? = nil
        
 
        //        let strDate = dateFormatter.string(from: date)
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                


                let date = Double(sqlite3_column_int(queryStatement, 0))
                
                let dateToFormat = Date(timeIntervalSince1970: date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let formattedDate = dateFormatter.string(from: dateToFormat)
                print("Largest date is: \(formattedDate)")
            }
        } else {
            print("AVERAGE reading statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        
        print("Time required to get lowest date: \(measuredTime)")
        
    }
    
    func clearSensorTable() {
        let deleteStatementStirng = "DELETE FROM sensor;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func dropSensorTable() {
        let deleteStatementStirng = "DROP TABLE sensor;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully removed table.")
            } else {
                print("Could not remove table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func dropReadingsTable() {
        let deleteStatementStirng = "DROP TABLE reading;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully removed table.")
            } else {
                print("Could not remove table.")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
