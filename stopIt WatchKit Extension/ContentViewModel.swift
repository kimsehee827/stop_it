import WatchKit
import SwiftUI
import Foundation
import CoreMotion

//얘는 걷기 및 달리기 같은 활동 유형 모니터링.
private let activityManager = CMMotionActivityManager()
//얘는 현재 걸음수 가져오는데 사용
private let pedometer = CMPedometer()
//얘는 자이로스코프 값.
private let motionManager = CMMotionManager()

class ContentViewModel: ObservableObject{
    @Published var timeString: String = "00 : 00 : 00"
    @Published var isStart = false
    var buttonText: String{
        if isStart{
            return "stop"
        }
        else {
            return"start"
        }
    }
    
    let interval = 1.0
    var mainTimer: Timer?
    var timeCount: Int = 0
    
    @State private var steps: Int?
    @State private var output: String?
    @State private var labelX: Double?
    @State private var labelY: Double?
    @State private var labelZ: Double?
    
    var backgroundColor = Color.init(white: 0, opacity: 100)
    
    
    func initializePedometer(){
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { [self](data) in
                guard let data = data
            else {return}
                if data.running{
                    self.output = "running"
                    stopTimer()
                    print("running")
                    if isStart{
                        isStart.toggle()
                    }
                }
            })
        }
    }
    
    func buttonClicked() {
        isStart.toggle()
        if isStart{
            startTimer()
            backgroundColor = Color.green
        } else {
            stopTimer()
            backgroundColor = Color.red
        }
    }
    func startTimer() {
        mainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.timeCount += 1
            DispatchQueue.main.async {
                self.timeString = self.makeTimeString(count: self.timeCount)
            }
        })
        initializePedometer()
    }
    
    func makeTimeString(count:Int) -> String {
        let hour = count/3600
        let min = (count%3600)/60
        let sec = (count%3600)%60
        let sec_string = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        let hour_string = "\(hour)".count == 1 ? "0\(hour)" : "\(hour)"
        return ("\(hour_string) : \(min_string) : \(sec_string)")
    }
    
    func stopTimer() {
        mainTimer?.invalidate()
        mainTimer = nil
    }
    
}



// gyro
/*
private func initializeMotion(){
    
    if motionManager.isAccelerometerAvailable{
        //motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: <#T##CMGyroHandler##CMGyroHandler##(CMGyroData?, Error?) -> Void#>)
        motionManager.startAccelerometerUpdates(to: .main, withHandler: { [self](gyro: CMAccelerometerData?, error) in
            guard let gyro = gyro, error == nil else {return}
            labelX = gyro.acceleration.x
            labelY = gyro.acceleration.y
            labelZ = gyro.acceleration.z
        })
    }

}
*/
