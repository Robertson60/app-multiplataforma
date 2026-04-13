import 'pieza_corte.dart';
import 'herrajes.dart';

class Huacal {
  final String nombre;
  final List<PiezaCorte> piezas;
  final List<Herraje> herrajes;

  Huacal({
    required this.nombre,
    required this.piezas,
    required this.herrajes,
  });
}