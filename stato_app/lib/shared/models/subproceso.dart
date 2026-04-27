class SubProcess {
  final String id;
  String name;

  SubProcess({required this.name})
    : id = DateTime.now().millisecondsSinceEpoch.toString();
}