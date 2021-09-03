import Foundation
import Combine

class TaskCellViewModel: ObservableObject, Identifiable {
    @Published var task: Task
    @Published var completionStateIconName = ""
    
    var id: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    static func newTask() -> TaskCellViewModel {
        TaskCellViewModel(task: Task(title: "", completed: false))
    }
    
    init(task: Task) {
        self.task = task
  
        $task // (8)
          .map { $0.completed ? "checkmark.circle.fill" : "circle" }
          .assign(to: \.completionStateIconName, on: self)
          .store(in: &cancellables)
        $task // (7)
          .map { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)

    }
}
