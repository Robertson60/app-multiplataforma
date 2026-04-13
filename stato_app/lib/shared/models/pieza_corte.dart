import 'config_canto.dart';

class PiezaCorte {
  final String nombre;
  final double largoBase;
  final double anchoBase;
  final int cantidad;
  final ConfiguracionCanto? canto05Vista;   //Canto .5mm color de puerta
  final ConfiguracionCanto? canto05Huacal;  //Canto .5mm color de huacal
  final ConfiguracionCanto? canto10;        //Canto 1mm color de puerta

  PiezaCorte({
    required this.nombre,
    required this.largoBase,
    required this.anchoBase,
    this.cantidad = 1,
    this.canto05Vista,
    this.canto05Huacal,
    this.canto10,
  });

  //Medidas finales con descuento de todos los cantos aplicado
  double get largo => largoBase - (canto05Vista?.descuentoLargo ?? 0) - (canto05Huacal?.descuentoLargo ?? 0) - (canto10?.descuentoLargo ?? 0);
  double get ancho => anchoBase - (canto05Vista?.descuentoAncho ?? 0) - (canto05Huacal?.descuentoAncho ?? 0) - (canto10?.descuentoAncho ?? 0);

  //Metros lineales de canto por tipo
  double _calcularMetros(ConfiguracionCanto? canto) {
    if (canto == null) return 0;
    double total = 0;
    if (canto.largo1) total += largo;
    if (canto.largo2) total += largo;
    if (canto.ancho1) total += ancho;
    if (canto.ancho2) total += ancho;
    return (total * cantidad) / 1000; //Convierte mm a metros
  }

  double get metrosCanto05Vista  => _calcularMetros(canto05Vista);
  double get metrosCanto05Huacal => _calcularMetros(canto05Huacal);
  double get metrosCanto10       => _calcularMetros(canto10);
}