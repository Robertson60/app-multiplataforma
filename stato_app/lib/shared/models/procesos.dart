class Project {
  final String id;
  String name;

  int currentProcessIndex;
  int currentSubIndex;
  bool isCompleted;

  Project({required this.name})
    : id = DateTime.now().millisecondsSinceEpoch.toString(),
      currentProcessIndex = 0,
      currentSubIndex = 0,
      isCompleted = false;
}