import '';

class ProcessManager {
  final List<Process> _processes = [];

  List<Process> get processes => _processes;

  void addProcess(String name) {
    _processes.add(Process(name: name));
  }

  void removeProcess(int index) {
    if (index >= 0 && index < _processes.length) {
      _processes.removeAt(index);
    }
  }

  void markCompleted(int index) {
    if (index >= 0 && index < _processes.length) {
      _processes[index].isCompleted = true;
    }
  }

  int get currentStep {
    return _processes.indexWhere((p) => !p.isCompleted);
  }
}
