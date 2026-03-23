
class PiezaCorte {
  final String nombre;
  final double largoBase;
  final double anchoBase;
  final int cantidad;

  PiezaCorte({
    required this.nombre,
    required this.largoBase,
    required this.anchoBase,
    this.cantidad = 1
  });
}