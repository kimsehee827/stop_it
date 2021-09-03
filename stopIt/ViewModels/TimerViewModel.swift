import Foundation
import SwiftUI
import CoreMotion



//얘는 걷기 및 달리기 같은 활동 유형 모니터링.
private let activityManager = CMMotionActivityManager()
//얘는 현재 걸음수 가져오는데 사용
private let pedometer = CMPedometer()

class TimerViewModel: ObservableObject {
    @Published var timeString: String = "00 : 00 : 00"
    @Published var isStart = false
    var buttonText: String {
        if isStart {
            return "Stop"
        } else {
            return "Start"
        }
    }
    
    let interval = 1.0
    var mainTimer: Timer?
    var timeCount: Int = 0
    
        
    @State var steps: Int?
    @State private var output: String?

    func initializePedometer(){
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { [self](data) in
                guard let data = data
            else {return}
                if data.walking{
                    self.output = "walking"
                    stopTimer()
                    print("walking")
                    if isStart{
                        isStart.toggle()
                    }
                }
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
        if isStart {
            startTimer()
        } else {
            stopTimer()
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
