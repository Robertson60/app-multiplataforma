import 'subproceso.dart';

enum Stage { venta, produccion, instalacion }

class Process {
  Stage stage;
  List<SubProcess> subProcesses;
  int currentSubIndex;

  Process({
    required this.stage,
    this.subProcesses = const [],
    this.currentSubIndex = 0,
  });
}
