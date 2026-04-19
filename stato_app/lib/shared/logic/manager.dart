import '../models/proyecto.dart';
import '../models/proceso.dart';
import '../models/subproceso.dart';

class ProcessManager {
  final List<Project> _projects = [];

  List<Project> get projects => _projects;

  void addProject(String name) {
    _projects.add(Project(name: name));
  }

  void removeProject(String id) {
    _projects.removeWhere((p) => p.id == id);
  }

  Process _getCurrentProcess(Project project) {
    return project.processes[project.currentProcessIndex];
  }

  void addSubProcess(String projectId, String name) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final process = _getCurrentProcess(project);

    process.subProcesses = List.from(process.subProcesses)
      ..add(SubProcess(name: name));
  }

  void removeSubProcess(String projectId, String subId) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final process = _getCurrentProcess(project);

    process.subProcesses = process.subProcesses
        .where((s) => s.id != subId)
        .toList();
  }

  void completeSubProcess(String projectId, String subId) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final process = _getCurrentProcess(project);

    final index = process.subProcesses.indexWhere((s) => s.id == subId);

    if (index == -1) return;

    process.subProcesses[index].isCompleted = true;

    // avanzar subproceso
    if (process.currentSubIndex < process.subProcesses.length - 1) {
      process.currentSubIndex++;
    } else {
      _advanceProcess(project);
    }
  }

  void _advanceProcess(Project project) {
    if (project.currentProcessIndex < project.processes.length - 1) {
      project.currentProcessIndex++;
    } else {
      project.isCompleted = true;
    }
  }
}
