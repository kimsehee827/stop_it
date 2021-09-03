import SwiftUI

struct HeartRateView: View {
    @Environment(\.presentationMode) var presentMode
    @State private var date = Date().onlyDate!
    
    @StateObject var viewModel = HeartRateViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: .date){
                        }
                        .environment(\.locale, Locale.init(identifier: "ko"))
                        .labelsHidden()
                        .padding(.trailing, 15)
                    }
                    
                    HeartRateGraph(heartRate: viewModel.heartRate)
                    
                    MinMaxHeartRateView(minimumHR: viewModel.min, maximumHR: viewModel.max, averageHR: viewModel.avg)
                }
                .navigationBarTitle("My HeartRate", displayMode: .inline)
                .navigationBarItems(trailing: Button("Close") {
                    presentMode.wrappedValue.dismiss()
                })
            }
    
        }
        .onAppear(perform: viewModel.appear)
        .onChange(of: self.date, perform: { value in
            self.viewModel.getHeartRate(on: value)
        })
    }
}

struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}
