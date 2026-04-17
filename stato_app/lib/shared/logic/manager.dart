import '../models/proyecto.dart';
import '../models/subproceso.dart';

class ProcessManager {
  final List<Project> _projects = [];

  List<Project> get projects => _projects;

  // Agregar un nuevo proyecto
  void addProject(String name) {
    _projects.add(Project(name: name));
  }

  // Eliminar proyecto
  void removeProject(String id) {
    _projects.removeWhere((p) => p.id == id);
  }

  // Agregar subproceso a un proyecto
  void addSubProcess(String projectId, String subName) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    project.subProcesses.add(SubProcess(name: subName));
  }

  // Eliminar subproceso
  void removeSubProcess(String projectId, String subId) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    project.subProcesses.removeWhere((s) => s.id == subId);
  }

  // Marcar subproceso como completado (con confirmación en UI)
  void completeSubProcess(String projectId, String subId) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final sub = project.subProcesses.firstWhere((s) => s.id == subId);
    sub.isCompleted = true;

    // Si todos los subprocesos están completos, avanzar al siguiente stage
    if (project.subProcesses.every((s) => s.isCompleted)) {
      _advanceStage(project);
    }
  }

  // Avanzar automáticamente al siguiente proceso principal
  void _advanceStage(Project project) {
    if (project.currentStage == Stages.venta) {
      project.currentStage = Stages.produccion;
      project.subProcesses.clear(); // limpiar subprocesos para nueva etapa
    } else if (project.currentStage == Stages.produccion) {
      project.currentStage = Stages.instalacion;
      project.subProcesses.clear();
    } else if (project.currentStage == Stages.instalacion) {
      project.isCompleted = true; // proyecto finalizado
    }
  }
}
