import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        
        Button(action: viewModel.buttonClicked){
            ZStack(alignment: .center){
                Circle()
                    .frame(width: 160, height: 160, alignment: .center)
                    .foregroundColor(viewModel.backgroundColor)

                
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 150, alignment: .center)
                Text(verbatim: viewModel.timeString)
                    .font(.system(size: 30))
            }
        }//.buttonStyle(playinButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
