import Foundation

class Reading
{
    
    var date: Date = Date()
    var value: Float = 0
    var sensorId: Int = 0
    
    init(date:Date, value:Float, sensorId:Int)
    {
        self.date = date
        self.value = value
        self.sensorId = sensorId
    }
    
}
