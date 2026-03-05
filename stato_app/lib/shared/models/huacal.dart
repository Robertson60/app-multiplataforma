import 'pieza_corte.dart';

class Huacal {
  final String nombre;
  final List<PiezaCorte> piezas; // Aquí vive el grupo de piezas

  Huacal({
    required this.nombre,
    required this.piezas,
  });

  // Un método extra para saber cuánta madera gasta este mueble en total
  double get areaTotal {
    return piezas.fold(0, (suma, p) => suma + (p.largo * p.ancho));
  }
}