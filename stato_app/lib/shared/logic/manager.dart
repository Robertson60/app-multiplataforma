import 'package:stato_app/shared/shared.dart';

class ProcessManager {
  final List<Project> _projects = [];

  final Map<Stage, List<SubProcess>> stageProcesses = {
    Stage.venta: [],
    Stage.produccion: [],
    Stage.instalacion: [],
  };

  List<Project> get projects => _projects;

  void addProject(String name) {
    _projects.add(Project(name: name));
  }

  void removeProject(String id) {
    _projects.removeWhere((p) => p.id == id);
  }

  void addSubProcessToStage(Stage stage, String name) {
    stageProcesses[stage]!.add(SubProcess(name: name));
  }

  void removeSubProcessFromStage(Stage stage, String subId) {
    stageProcesses[stage]!.removeWhere((s) => s.id == subId);
  }

  void completeSubProcess(Project project) {
    final stage = Stage.values[project.currentProcessIndex];
    final processes = stageProcesses[stage]!;

    if (processes.isEmpty) return;

    if (project.currentSubIndex < processes.length - 1) {
      project.currentSubIndex++;
    } else {
      _advanceStage(project);
    }
  }

  void _advanceStage(Project project) {
    if (project.currentProcessIndex < Stage.values.length - 1) {
      project.currentProcessIndex++;
      project.currentSubIndex = 0;
    } else {
      project.isCompleted = true;
    }
  }
}
