import Foundation

/// 왼쪽 -> 오른쪽으로 드래그 시 이전 일주일의 기록 확인 가능
/// 오른쪽 -> 왼쪽으로 드래그 시 그 다음 일주일의 기록 확인 가능: 만약 현재 보고 있는 기록이 가장 최신의 기록이라면 더이상 드래그 되면 안됨

class StudyTimeTableViewModel: ObservableObject {
    @Published var graphBarVM: [StudyTimeGraphBarViewModel] = []
    var height: Double
    var sevenDays: [Date] = []
    
    init(height: Double) {
        self.height = height
        // 일주일 날짜 가져오기
        loadData()
    }
    
    func loadData() {
        // TODO
        // 일주일치 다 해야함.
        // 얘는 하루치만 해봄
        // 이전 graphBarVM 다 없애고 다시 시작 
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-18-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-19-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-20-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-21-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-22-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-23-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        StudyTimeModel.shared.getStudyTime(on: Date.fromString(str: "2021-08-24-00-00-00")!) { studyTime in
            DispatchQueue.main.async {
                self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
            }
        }
        
    }
    
    func onDrag(direction: Int) {
        // TODO
        // 일주일 날짜 가져오기
        // 그다음 loadData()
    }
}
