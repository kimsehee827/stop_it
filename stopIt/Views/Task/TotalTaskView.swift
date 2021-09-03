import SwiftUI

struct TotalTaskView: View {
    @State private var isPresented = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                self.isPresented.toggle()
            }) {
                Text("Detail")
            }
            TaskListView(title: "Today's To-Do List", targetTask: TaskModel.today, color: "task1")
            TaskListView(title: "Yesterday's To-Do List", targetTask: TaskModel.yesterday, color: "task2")
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            StudyTimeTableView()
        })
    }
}

struct TotalTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TotalTaskView()
    }
}
