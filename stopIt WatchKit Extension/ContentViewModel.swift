import WatchKit
import SwiftUI
import Foundation
import CoreMotion
import WatchConnectivity

//얘는 걷기 및 달리기 같은 활동 유형 모니터링.
private let activityManager = CMMotionActivityManager()
//얘는 현재 걸음수 가져오는데 사용
private let pedometer = CMPedometer()
//얘는 자이로스코프 값.
private let motionManager = CMMotionManager()

class ContentViewModel: NSObject,  WCSessionDelegate, ObservableObject{
    
    @Published var messageText = ""
    //아이폰에 보낼 값.
    @Published var start: String = "startit"
    @Published var stop: String = "stopit"
    
    var session: WCSession
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    //iphone에서 데이터 받아오는 받아올것이다 = 시간.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.messageText = message["message"] as? String ?? "Unknown"
        }
        messagefromIPhone()
    }
    
    @State private var output: String?
    
    var backgroundColor = Color.init(white: 0, opacity: 100)
    
    func initializePedometer(){
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { [self](data) in
                guard let data = data
            else {return}
                if data.walking{
                    self.output = "walking"
                    stopTimer()
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
    
    @Published var isStart = false
    func buttonClicked() {
        isStart.toggle()
        if isStart{
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func messagefromIPhone(){
        if messageText == "startit"{
            backgroundColor = Color.green
        }
        if messageText == "stopit"{
            backgroundColor = Color.red
        }
    }
    
    
    func startTimer() {
        self.session.sendMessage(["message" : start], replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
        backgroundColor = Color.green
        initializePedometer()
    }
    
    
    func stopTimer() {
        self.session.sendMessage(["message" : stop], replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
        backgroundColor = Color.red
    }
}
