import SwiftUI

struct StudyTimeTableView: View {
    @Environment(\.presentationMode) var presentMode
    @State private var offset = CGSize.zero
    @ObservedObject var viewModel = StudyTimeTableViewModel(height: Double(UIScreen.main.bounds.height - 160 - 25/* hstack.padding */))
    
    var height: CGFloat = UIScreen.main.bounds.height - 160
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Date")
                }
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 20, height: 1)
                        .foregroundColor(Color.gray)
                    HStack(alignment: .top) {
                        Spacer()
                        
                        VStack {
                            // times
                            Group {
                
                                Text("00:00")
                                    .padding(5)
                                Spacer()
                                Text("03:00")
                                Spacer()
                                Text("06:00")
                                Spacer()
                            }
                            Group {
                                Text("09:00")
                                Spacer()
                                Text("12:00")
                                Spacer()
                                Text("15:00")
                                Spacer()
                            }
                            Group {
                                Text("18:00")
                                Spacer()
                                Text("21:00")
                                Spacer()
                                Text("24:00")
                            }
                        }
                        .foregroundColor(Color.gray)
                        
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 1, height: height)
                            .foregroundColor(Color.gray)
                        Spacer()
                        
                        HStack(alignment: .top) {
                            ForEach(viewModel.graphBarVM) { vm in
                                StudyTimeGraphBar(viewModel: vm)
                            }
                        }
                        .padding([.top], 10)
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
            .gesture(DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { _ in
                            if abs(self.offset.width) > 100 {
                                print("drag")
                            }
                        })
            .navigationBarTitle("Total Study Time Table", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentMode.wrappedValue.dismiss()
            })
            .padding([.top], 20)
        }
    }
}

struct StudyTimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        StudyTimeTableView()
    }
}
