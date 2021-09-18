import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        
        Button(action: {
            viewModel.buttonClicked()
                self.viewModel.session.sendMessage(["message" : viewModel.messageText], replyHandler: nil) { (error) in
                    print(error.localizedDescription)
                }
        }, label: {
           ZStack(alignment: .center){
               Circle()
                   .frame(width: 150, height: 150, alignment: .center)
                   .foregroundColor(viewModel.backgroundColor)

               
               Circle()
                   .foregroundColor(.black)
                   .frame(width: 140, height: 140, alignment: .center)
               Text(verbatim: viewModel.messageText)
                   .font(.system(size: 30))
           }
        })//.buttonStyle(playinButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
