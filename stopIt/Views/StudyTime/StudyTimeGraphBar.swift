import SwiftUI

struct StudyTimeGraphBar: View {
    @ObservedObject var viewModel: StudyTimeGraphBarViewModel
    var studyTimeBarColor: Color = Color("graphbar1")
    var restTimeBarColor: Color = Color("graphbar2")
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Rectangle()
                .frame(width: 20, height: CGFloat(viewModel.endPoint - viewModel.startPoint))
                .foregroundColor(studyTimeBarColor.opacity(0.5))
                .overlay(Rectangle().stroke(studyTimeBarColor, lineWidth: 1))
                .padding([.top], CGFloat(viewModel.startPoint))
            
            ForEach(0..<viewModel.restPoints.count) { idx in
                Rectangle()
                    .frame(width: 20, height: CGFloat(viewModel.restPoints[idx].end - viewModel.restPoints[idx].start))
                    .foregroundColor(restTimeBarColor.opacity(0.5))
                    .overlay(Rectangle().stroke(restTimeBarColor, lineWidth: 1))
                    .padding([.top], CGFloat(viewModel.restPoints[idx].start))
            }
        }
        .frame(width: 30)
    }
}
