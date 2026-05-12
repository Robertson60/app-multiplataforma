class SubProcess {
  // aqui guardo el id unico del subproceso
  final String id;

  // aqui guardo el nombre del subproceso
  String name;

  // este es mi constructor donde recibo el nombre del subproceso
  SubProcess({required this.name})
      // aqui genero automaticamente un id unico usando la fecha actual en milisegundos
      : id = DateTime.now().millisecondsSinceEpoch.toString();
}