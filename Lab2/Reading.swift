import Foundation

class Reading
{
    
    var date: Int = 0
    var value: Float = 0
    var sensorId: Int = 0
    
    init(date:Int, value:Float, sensorId:Int)
    {
        self.date = date
        self.value = value
        self.sensorId = sensorId
    }
    
}
