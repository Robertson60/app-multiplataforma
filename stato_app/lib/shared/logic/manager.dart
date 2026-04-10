// importo la clase Process desde otro archivo
import 'procesos.dart';

// defino la clase que se encarga de manejar los procesos
class ProcessManager {
  // creo una lista privada donde guardo todos mis procesos
  final List<Process> _processes = [];

  // creo un getter para poder ver la lista desde fuera sin modificarla directamente
  List<Process> get processes => _processes;

  // creo una funcion para agregar un nuevo proceso
  void addProcess(String name) {
    // agrego un nuevo proceso a la lista con el nombre que recibo
    _processes.add(Process(name: name));
  }

  // creo una funcion para eliminar un proceso usando su posicion
  void removeProcess(int index) {
    // verifico que el indice sea valido antes de eliminar
    if (index >= 0 && index < _processes.length) {
      // elimino el proceso de la lista
      _processes.removeAt(index);
    }
  }

  // creo una funcion para marcar un proceso como completado
  void markCompleted(int index) {
    // verifico que el indice sea valido
    if (index >= 0 && index < _processes.length) {
      // cambio el estado del proceso a completado
      _processes[index].isCompleted = true;
    }
  }

  // aqui obtengo el proceso actual que no esta completado
  int get currentStep {
    // busco el primer proceso que no este completado
    // si todos estan completos devuelve -1
    return _processes.indexWhere((p) => !p.isCompleted);
  }
}
