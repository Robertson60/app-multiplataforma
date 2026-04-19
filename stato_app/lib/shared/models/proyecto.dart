import 'proceso.dart';

class Project {
  final String id;
  String name;
  List<Process> processes;
  int currentProcessIndex;
  bool isCompleted;

  Project({required this.name})
    : id = DateTime.now().millisecondsSinceEpoch.toString(),
      currentProcessIndex = 0,
      isCompleted = false,
      processes = [
        Process(stage: Stage.venta),
        Process(stage: Stage.produccion),
        Process(stage: Stage.instalacion),
      ];
}
