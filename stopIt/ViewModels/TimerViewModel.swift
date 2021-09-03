import Foundation

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
