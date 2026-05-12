import 'package:stato_app/shared/models/subproceso.dart';
import 'package:stato_app/shared/shared.dart';

// aqui defino las etapas principales del sistema
enum Stage { venta, produccion, instalacion }

class ProcessManager {
  // aqui guardo todos los proyectos que se crean en la aplicacion
  final List<Project> _projects = [];

  // aqui defino los subprocesos globales para cada etapa
  // cada etapa tiene su propia lista de procesos
  final Map<Stage, List<SubProcess>> stageProcesses = {
    Stage.venta: [],
    Stage.produccion: [],
    Stage.instalacion: [],
  };

  // este getter me permite acceder a la lista de proyectos desde fuera
  List<Project> get projects => _projects;

  // con esta funcion creo un nuevo proyecto y lo agrego a la lista
  void addProject(String name) {
    _projects.add(Project(name: name));
  }

  // con esta funcion elimino un proyecto usando su id
  void removeProject(String id) {
    _projects.removeWhere((p) => p.id == id);
  }

  // aqui agrego un nuevo subproceso a una etapa especifica
  // todos los proyectos pasaran por estos procesos
  void addSubProcessToStage(Stage stage, String name) {
    stageProcesses[stage]!.add(SubProcess(name: name));
  }

  // aqui elimino un subproceso de una etapa
  void removeSubProcessFromStage(Stage stage, String subId) {
    stageProcesses[stage]!.removeWhere((s) => s.id == subId);
  }

  // aqui avanzo un proyecto al siguiente subproceso
  void completeSubProcess(Project project) {
    // primero obtengo la etapa actual del proyecto
    final stage = Stage.values[project.currentProcessIndex];

    // luego obtengo los subprocesos de esa etapa
    final processes = stageProcesses[stage]!;

    // si no hay procesos definidos, no hago nada
    if (processes.isEmpty) return;

    // si aun hay mas subprocesos, avanzo al siguiente
    if (project.currentSubIndex < processes.length - 1) {
      project.currentSubIndex++;
    } else {
      // si ya termine todos los subprocesos, paso a la siguiente etapa
      _advanceStage(project);
    }
  }

  // esta funcion se encarga de cambiar de etapa
  void _advanceStage(Project project) {
    // si aun hay etapas disponibles, avanzo a la siguiente
    if (project.currentProcessIndex < Stage.values.length - 1) {
      project.currentProcessIndex++;
      project.currentSubIndex = 0;
    } else {
      // si ya no hay mas etapas, marco el proyecto como terminado
      project.isCompleted = true;
    }
  }
}