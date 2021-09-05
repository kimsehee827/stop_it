import SwiftUI

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel // (1)
    var onCommit: (Result<Task, InputError>) -> Void = { result in
        // 변경하고 엔터치면 불림
    }
    
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.completionStateIconName)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
                }
            TextField("20자 제한", text: $taskCellVM.task.title, onEditingChanged: { isStart in
                    if self.taskCellVM.task.title.count > 20 {
                        let idx = taskCellVM.task.title.index(taskCellVM.task.title.startIndex, offsetBy: 19)
                        self.taskCellVM.task.title = String(taskCellVM.task.title[..<idx])
                    }
            }, onCommit: {
                    if !self.taskCellVM.task.title.isEmpty && self.taskCellVM.task.title.count < 20 {
                        self.onCommit(.success(self.taskCellVM.task))
                        self.taskCellVM.onCommit()
                    }
                    else {
                        self.onCommit(.failure(.empty))
                    }
            })
                .id(taskCellVM.id)
                .foregroundColor(.black)
        }
    }
}

enum InputError: Error {
  case empty
}
