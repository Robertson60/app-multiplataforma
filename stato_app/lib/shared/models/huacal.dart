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

  // Función útil para tu compañero de Base de Datos: 
  // Calcula el costo total sumando madera y herrajes.
  double calcularPresupuesto(double precioM2Madera) {
    double costoMadera = piezas.fold(0, (sum, p) => 
      sum + (p.largoBase * p.anchoBase * p.cantidad * precioM2Madera / 1000000));
    
    double costoHerrajes = herrajes.fold(0, (sum, h) => sum + h.costoTotal);
    
    return costoMadera + costoHerrajes;
  }
}