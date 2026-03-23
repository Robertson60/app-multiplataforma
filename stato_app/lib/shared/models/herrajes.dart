class Herraje {
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  Herraje({
    required this.nombre,
    required this.cantidad,
    this.precioUnitario = 0.0,
  });

  double get costoTotal => cantidad * precioUnitario;
}