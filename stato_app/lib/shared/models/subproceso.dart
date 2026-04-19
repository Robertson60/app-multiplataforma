class SubProcess {
  final String id;
  String name;
  bool isCompleted;

  SubProcess({required this.name, this.isCompleted = false})
    : id = DateTime.now().millisecondsSinceEpoch.toString();
}
