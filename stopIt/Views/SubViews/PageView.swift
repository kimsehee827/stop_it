import SwiftUI

struct PageView: View {
    var body: some View {
        TabView {
            
            ZStack {
                Color.white
                TotalTaskView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .padding([.bottom], 20)

            //걸음수
            ZStack {
                Color.white
                StepCountGraph()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .padding([.bottom], 20)
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .frame(width: UIScreen.main.bounds.width-20, height: 480)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .padding(.all, 10)
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView()
    }
}
