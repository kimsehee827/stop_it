import Foundation

struct RestPoint {
    var start: Double
    var end: Double
}

class StudyTimeGraphBarViewModel: ObservableObject, Identifiable {
    @Published var startPoint: Double = 0
    @Published var endPoint: Double = 0
    @Published var restPoints: [RestPoint] = []
    
    var totalHeight: Double
    var heightPerSecond: Double {
        totalHeight / 60 / 60 / 24
    }
    
    /// 해당 날짜 00시 00분
    var date: Date?
    
    init(studyTime: StudyTime?, height: Double) {
        self.totalHeight = height
        
        guard let studyTime = studyTime else {
            return
        }
        
        self.date = studyTime.startTime.onlyDate
        
        if let date = self.date {
            startPoint = heightPerSecond * (studyTime.startTime - date)
            
            if let endTime = studyTime.endTime {
                endPoint = heightPerSecond * (endTime - date)
            } else {
                endPoint = heightPerSecond * (Date() - date)
            }
            
            for rest in studyTime.rests {
                let first = heightPerSecond * (rest.start - date)
                var second: Double
                if let end = rest.end {
                    second = heightPerSecond * (end - date)
                } else {
                    second = heightPerSecond * (Date() - date)
                }
                restPoints.append(RestPoint(start: first, end: second))
            }
        }
        
    }
    
}
