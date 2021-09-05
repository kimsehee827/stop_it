import SwiftUI

struct HeartRateGraph: View {
    var heartRate: [Int: HeartRateMinMax]
    let max = 200.0
    let min = 20.0
    var underline: CGFloat
    
    var body: some View {
        ZStack {
            Color.white
            HeartRateGridView(color: Color("heartrate2"), underline: underline)
            VStack(spacing: 0) {
                Spacer()
                HStack(alignment: .bottom) {
                    ForEach(0..<24) { idx in
                         Rectangle()
                             .frame(width: 7, height: calcCapsuleLength(idx: idx))
                             .overlay(LinearGradient(gradient: Gradient(colors: [Color("heartrategraphcapsule")]), startPoint: .top, endPoint: .bottom))
                             .cornerRadius(30)
                             .padding(.bottom, 45 + calcCapsuleHeight(idx: idx))
                     }
                }
                
                HStack {
                    Spacer()
                    Text("상한: 200BPM, 하한: 20BPM")
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                        .foregroundColor(Color("heartrate2"))
                }
                
                HStack {
                    Spacer()
                    Text("노란색 라인 이하의 심박수: 수면시간으로 추정")
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                        .foregroundColor(Color("heartrate2"))
                }
                
                HStack {
                    Spacer()
                    Text("주의: 수면시간 추정시 일부 오차가 있을 수 있습니다")
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                        .foregroundColor(Color("heartrate2"))
                }
               
             }
         }
         .frame(width: UIScreen.main.bounds.width - 20, height: 643, alignment: .center)
         .cornerRadius(10)
    }
    
    func calcCapsuleLength(idx: Int) -> CGFloat {
        guard let bpm = heartRate[idx] else {
            return 0
        }
        
        if bpm.max - bpm.min < 10 {
            return 9
        } else if bpm.max < bpm.min {
            return 0
        }
        
        let range = Double(bpm.max - bpm.min)
        return CGFloat(range / (max - min) * 400)
    }
    
    func calcCapsuleHeight(idx: Int) -> CGFloat {
        guard let bpm = heartRate[idx] else {
            return 0
        }
        
        return CGFloat(Double(bpm.min - 20) / (max - min) * 400)
    }
}

struct HeartRateGraph_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateGraph(heartRate: [0: HeartRateMinMax(min:20, max: 60), 23: HeartRateMinMax(min: 110, max: 200)], underline: 60)
    }
}
