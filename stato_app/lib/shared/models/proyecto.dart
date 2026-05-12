class Proyecto {
  // aqui guardo el id unico del proyecto
  final String id;

  // aqui guardo el nombre del proyecto
  final String nombre;

  // aqui guardo el nombre del cliente
  final String cliente;

  // aqui guardo la lista de piezas o cortes del proyecto
  // cada pieza es un mapa con diferentes datos (por ejemplo: medidas, tipo, etc.)
  final List<Map<String, dynamic>> piezas;

  // aqui guardo los materiales necesarios para el proyecto
  // uso un mapa porque puede tener diferentes tipos de datos
  final Map<String, dynamic> materiales;

  // este es mi constructor donde recibo toda la informacion del proyecto
  Proyecto({
    required this.id,
    required this.nombre, 
    required this.cliente, 
    required this.piezas, 
    required this.materiales
  });
}