//
//  StudyTimeTableViewModel.swift
//  Front
//
//  Created by 오인경 on 2021/08/29.
//

import Foundation

/// 왼쪽 -> 오른쪽으로 드래그 시 이전 일주일의 기록 확인 가능
/// 오른쪽 -> 왼쪽으로 드래그 시 그 다음 일주일의 기록 확인 가능: 만약 현재 보고 있는 기록이 가장 최신의 기록이라면 더이상 드래그 되면 안됨

class StudyTimeTableViewModel: ObservableObject {
    @Published var graphBarVM: [StudyTimeGraphBarViewModel] = []
    @Published var weekString: String = ""
    var height: Double
    var sevenDays: [Date] = []
    
    init(height: Double) {
        self.height = height
        // 일주일 날짜 가져오기
        sevenDays = Date().getAllWeekDays()
        
        self.weekString = sevenDays[0].toString(dateFormat: "YYYY.MM.dd") + " ~ " + sevenDays[6].toString(dateFormat: "YYYY.MM.dd")
        
        loadData()
    }
    
    func loadData() {
        // TODO
        // 일주일치 다 해야함.
        // 얘는 하루치만 해봄
        // 이전 graphBarVM 다 없애고 다시 시작
        for day in sevenDays {
            StudyTimeModel.shared.getStudyTimeFromDB(on: day) { studyTime in
                DispatchQueue.main.async {
                    self.graphBarVM.append(StudyTimeGraphBarViewModel(studyTime: studyTime, height: self.height))
                    if self.graphBarVM.count == 14 {
                        self.graphBarVM.removeFirst(7)
                    }
                }
            }
        }
        
    }
    
    func onDrag(direction: Int) {
        // TODO
        // 일주일 날짜 가져오기
        // 그다음 loadData()
        if direction > 0 { // 오른쪽으로 드래그 > 이전주
            sevenDays = sevenDays[0].before7Days().getAllWeekDays()
        } else {           // 왼쪽으로 드래그 > 다음주
            for day in sevenDays {
                if day.isToday {
                    return
                }
            }
            sevenDays = sevenDays[0].after7Days().getAllWeekDays()
        }
        
        self.weekString = sevenDays[0].toString(dateFormat: "YYYY.MM.dd") + " ~ " + sevenDays[6].toString(dateFormat: "YYYY.MM.dd")
        
        loadData()
    }
}
