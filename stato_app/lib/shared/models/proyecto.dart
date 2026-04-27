class Proyecto {
  final String id;
  final String nombre;
  final String cliente;
  final List<Map<String, dynamic>> piezas; // Tus cortes
  final Map<String, dynamic> materiales; // Tus insumos

  Proyecto({
    required this.id,
    required this.nombre, 
    required this.cliente, 
    required this.piezas, 
    required this.materiales
  });
}