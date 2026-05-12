class Project {
  // aqui guardo el id unico del proyecto
  final String id;

  // aqui guardo el nombre del proyecto
  String name;
  int currentProcessIndex;


  int currentSubIndex;
  bool isCompleted;

  // este es mi constructor donde recibo el nombre del proyecto
  Project({required this.name})
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
        currentProcessIndex = 0,
        currentSubIndex = 0,
        isCompleted = false;
}