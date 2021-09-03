import SwiftUI

struct GraphBar: View {
    var studyTimeBarColor: Color = Color("graphbar1")
    var restTimeBarColor: Color = Color("graphbar2")
    var totalHeight: CGFloat = 250
    var totalTime: Int
    var studyTime: Int
    
    var height: CGFloat {
        if 1..<totalTime ~= studyTime {
            return CGFloat(Int(totalHeight) / totalTime * studyTime + 10)
        } else if studyTime == totalTime {
            return totalHeight
        } else {
            return totalHeight < 20 ? CGFloat(0) : CGFloat(20)
        }
    }
    var body: some View {
        VStack{
            ZStack(alignment: .bottomTrailing){
                Rectangle()
                    .frame(width: 20, height: totalHeight)
                    .foregroundColor(studyTimeBarColor.opacity(0.5))
                    .overlay(Rectangle().stroke(Color("graphbar1"), lineWidth: 1))
        
                Rectangle()
                    .frame(width: 20, height: height)
                    .foregroundColor(restTimeBarColor.opacity(0.5))
                    .overlay(Rectangle().stroke(Color("graphbar2"), lineWidth: 1))
            }
        }
    }
}

struct GraphBar_Previews: PreviewProvider {
    static var previews: some View {
        GraphBar(totalTime: 24, studyTime: 6)
    }
}
