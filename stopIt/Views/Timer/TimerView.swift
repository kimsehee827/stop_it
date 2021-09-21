import SwiftUI
import WatchConnectivity

struct TimerView: View {
    @ObservedObject var viewModel = TimerViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
               Text("Timer")
                    .foregroundColor(.white)
                    .font(.system(.headline))
                    .fontWeight(.heavy)
                
                HStack {
                    Text(viewModel.timeString)
                        .foregroundColor(.white)
                        .font(.system(size: 45))
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.buttonClicked()
                        self.viewModel.session.sendMessage(["message" : viewModel.timeString], replyHandler: nil) { (error) in
                            print(error.localizedDescription)
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("lightgray"))
                            Circle()
                                .foregroundColor(Color(red: 103/255, green: 120/255, blue: 180/255))
                                .frame(width: 60, height: 60, alignment: .center)
                            Text(viewModel.buttonText)
                                .foregroundColor(.white)
                        }
                    })
                    .frame(width: 70, height: 70, alignment: .center)
                }
            }
            .padding()
            .frame(height: 120)
            .background(Color(red: 103/255, green: 120/255, blue: 180/255))
        }
        .onAppear(perform: viewModel.onAppear)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .frame(width: UIScreen.main.bounds.width - 20)
        .padding([.top, .horizontal])
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

