class SubProcess {
  final String id; // Identificador único
  String name; // Nombre del subproceso
  bool isCompleted; // Estado del subproceso

  SubProcess({required this.name, this.isCompleted = false})
    : id = DateTime.now().millisecondsSinceEpoch.toString();
}
