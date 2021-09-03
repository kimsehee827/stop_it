import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskListVM: TaskListViewModel = TaskListViewModel(target: TaskModel.today)
    
    
    var title: String
    var color: String
    
    init(title: String, targetTask: TaskModel, color: String) {
        self.title = title
        self.color = color
        self.taskListVM = TaskListViewModel(target: targetTask)
    }
    
    var body: some View {
        VStack{
            Text(title)
                .font(.title2)
                .fontWeight(.black)
                .foregroundColor(.primary)
            VStack {
                ForEach (taskListVM.taskCellViewModels) { taskCellVM in 
                    TaskCell(taskCellVM: taskCellVM)
                        .padding([.all], 7)
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 50, height: 1)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 160, alignment: .center)
            .background(Color(color))
            .cornerRadius(10)
            
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(title: "Today's To-Do List", targetTask: TaskModel.today, color: "task2")
    }
}
