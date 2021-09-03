import SwiftUI
struct HeartRateGridView: View {
    var color: Color
    let width = UIScreen.main.bounds.width - 40
    var height: CGFloat = 400
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(1..<6) { _ in
                    HStack {
                        color.frame(width: width, height: 1)
                            .padding(.vertical, height / 4 / 2)
                    }
                }
            }
            .frame(height: height)
            HStack {
                ForEach(1..<8) { idx in
                    Text("\(idx * 3)")
                        .padding(.horizontal, width / 27)
                        .padding(.top, 20)
                        .foregroundColor(color)
                }
            }
            .frame(height: 30)
        }
    }
}

struct HeartRateGridView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateGridView(color: Color("heartrate2"))
    }
}
