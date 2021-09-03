import SwiftUI


struct StepCountGraph: View {
    @ObservedObject var viewModel = StepCountViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("7 days step")
                    .font(.system(size: 28))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 15)

                HStack(spacing: 18) {
                        ForEach(0..<7) {idx in
                            VStack {
                                //GraphCapsule2(totalStep:10000, step: viewModel.stepSum[idx].steps)
                                Text("\(viewModel.stepSum[idx].date.toString(dateFormat: "MM/dd"))").font(.system(size: 14))

                            }
                        }
                }
            }
            
            Text("7일간의 총 걸음 수")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding([.top], 10)
        }
        .onAppear(perform: viewModel.getCounts)
    }

}

struct StepCountGraph_Previews: PreviewProvider {
    static var previews: some View {
        StepCountGraph()
    }
}
