import Foundation
import SwiftUI
import CoreMotion
import WatchConnectivity



//얘는 걷기 및 달리기 같은 활동 유형 모니터링.
private let activityManager = CMMotionActivityManager()
//얘는 현재 걸음수 가져오는데 사용
private let pedometer = CMPedometer()

class TimerViewModel: NSObject,ObservableObject, WCSessionDelegate{
    @Published var timeString: String = "00 : 00 : 00"
    @Published var messageText = ""
    @Published var start: String = "startit"
    @Published var startInPhone: String = "start in Iphone"
    @Published var stop: String = "stopit"
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
    
    var initializerTimer: Timer?
    
    var session: WCSession
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    //Watch에서 보낸 데이터를 받는 부분.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.messageText = message["message"] as? String ?? "Unknown"
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
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
    
    func onAppear() {
//        initializerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
//            if let _ = StudyTimeModel.shared.todayStudyTime {
//                DispatchQueue.main.async {
//                    self.isStart = true
//                    self.startTimer()
//                    self.initializerTimer?.invalidate()
//                    self.initializerTimer = nil
//                }
//            }
//        })
    }
    
    func buttonClicked() {
        isStart.toggle()
        if isStart {
            startTimer()
            if StudyTimeModel.shared.todayStudyTime == nil {
                StudyTimeModel.shared.startStudy()
            } else {
                StudyTimeModel.shared.todayStudyTime?.endTime = nil
                if StudyTimeModel.shared.todayStudyTime!.rests.count > 0 {
                    let idx = StudyTimeModel.shared.todayStudyTime!.rests.count - 1
                    StudyTimeModel.shared.todayStudyTime?.rests[idx].end = Date()
                }
            }
        } else {
            stopTimer()
            if StudyTimeModel.shared.todayStudyTime != nil {
                StudyTimeModel.shared.addRests(rests: [Rest(start: Date(), end: nil)])
                StudyTimeModel.shared.todayStudyTime?.endTime = Date()
            }
        }
        StudyTimeModel.shared.saveTodayStudyTime()
    }
    
    func send(){
        self.session.sendMessage(["message" : timeString], replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func messagefromWatch(){
        if messageText == "stopit"{
            buttonClicked()
        }
        if messageText == "startit"{
            self.session.sendMessage(["message" : startInPhone ], replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // start 버튼 눌렀을 경우 start & watch에 start sign 전송.
    func sendToStart(){
        self.session.sendMessage(["message" : start], replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func startTimer() {
        sendToStart()
        if let today = StudyTimeModel.shared.todayStudyTime {
            self.timeCount = today.totalStudyTime ?? 0
        }
        mainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.timeCount += 1
            DispatchQueue.main.async {
                self.timeString = self.makeTimeString(count: self.timeCount)
            }
        })
        initializePedometer()
    }
    
    func makeTimeString(count:Int) -> String {
        send()
        messagefromWatch()
        let hour = count/3600
        let min = (count%3600)/60
        let sec = (count%3600)%60
        let sec_string = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        let hour_string = "\(hour)".count == 1 ? "0\(hour)" : "\(hour)"
        return ("\(hour_string) : \(min_string) : \(sec_string)")
    }
    func sendToStop(){
        self.session.sendMessage(["message" : stop], replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func stopTimer() {
        sendToStop()
        mainTimer?.invalidate()
        mainTimer = nil
    }
}
