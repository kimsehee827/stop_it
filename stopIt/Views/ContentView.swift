import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var state: Int? = 0
    @State private var showingAlert = false
    @State private var isHeartRateViewPresented = false
    
    var body: some View {
        NavigationView {
            if viewModel.isSignIn {
                ScrollView(.vertical) {
                    VStack {
                        TimerView()
                        PageView()
                        
                        NavigationLink(destination: Text("프로필 설정"), tag: 2, selection: $state) {
                            EmptyView()
                        }
                        CardView(contents1: "My HeartRate", contents2: "나의 공부시간 기록과 심박수", contents3: "최저&최고 심박수 확인하러 가기",imageName: "study5")
                            .onTapGesture {
                                isHeartRateViewPresented.toggle()
                            }
                            .fullScreenCover(isPresented: $isHeartRateViewPresented) {
                                HeartRateView()
                            }
                    }
                }
                .navigationBarTitle("Stop-it")
                .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            showingAlert = true
                        }) {
                            CircleImage(image: Image("study5"))
                        }
                        .alert(isPresented: $showingAlert, content: {
                            Alert(title: Text("로그아웃"), message: Text("로그아웃 하시겠습니까?"), primaryButton: .destructive(Text("확인")) {
                                viewModel.signOut()
                                showingAlert = false
                            }, secondaryButton: .cancel(Text("취소")))
                        })
                    }
                )
            } else {
                VStack {
                    Spacer()
                    GoogleLoginView()
                        .onTapGesture(perform: viewModel.googleSignIn)
                }
                .navigationBarTitle("Stop-it")
                .navigationBarItems(trailing: EmptyView())
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
