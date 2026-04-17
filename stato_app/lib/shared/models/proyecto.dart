import 'subproceso.dart';

/// Constantes de las etapas principales
class Stages {
  static const String venta = "venta";
  static const String produccion = "produccion";
  static const String instalacion = "instalacion";
}

class Project {
  final String id; // Identificador único
  String name; // Nombre del proyecto
  String currentStage; // Etapa actual: venta, produccion, instalacion
  List<SubProcess>
  subProcesses; // Lista de subprocesos dentro de la etapa actual
  bool isCompleted; // Estado final del proyecto

  Project({
    required this.name,
    this.currentStage = Stages.venta,
    this.subProcesses = const [],
    this.isCompleted = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
