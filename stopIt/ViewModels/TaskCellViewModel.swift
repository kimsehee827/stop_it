import Foundation
import Combine

class TaskCellViewModel: ObservableObject, Identifiable {
    @Published var task: Task
    @Published var completionStateIconName = ""
    
    var id: String = ""
    private var cancellables = Set<AnyCancellable>()
    var onCommit: () -> Void
    
    init(task: Task, onCommit: @escaping () -> Void) {
        self.onCommit = onCommit
        
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
