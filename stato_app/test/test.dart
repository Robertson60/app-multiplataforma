// ignore_for_file: avoid_print

//Trae el archivo que engobla todos los archivos 
import 'package:stato_app/shared/shared.dart';

void main() {

  //Configuracion de Material Huacal (piezas internas)
  final miConfigMaterialHuacal = ConfiguracionMaterial(
    terminado: 'Blanco Frosty',
  );

  //Configuracion de Material Vista (puertas)
  final miConfigMaterialVista = ConfiguracionMaterial(
    terminado: 'Roble Azabache',
    
  );

  //Configuracion de Puertas
  final miConfigPuerta = ConfiguracionPuerta(
    cantidad: CantidadPuertas.dos,
    jaladera: TipoJaladera.merenti,
    nombreBisagra: 'Hettich 110',
    nombreJaladera: 'Merenti',
  );

  //Configuracion de Entrepaños 
  final miConfigMovil = ConfiguracionEntrepanos(
    cantidad: 1,
    tipo: TipoEntrepano.movil,
  );

  //Configuracion de Huacal
  final huacal = CalculadorGabinete.fabricarHuacal(
    nombre: "Gabinete Estandar",
    alto: 700, ancho: 800, fondo: 600,
    configPuerta: miConfigPuerta,
    configEntrepanos: miConfigMovil,
    materialHuacal: miConfigMaterialHuacal,
    materialVista: miConfigMaterialVista,
    
  );

  //Imprimir la lista de piezas
  print('Módulo: ${huacal.nombre}');
  for (var p in huacal.piezas) {
    print('${p.cantidad}x ${p.nombre} | Base: ${p.largoBase} x ${p.anchoBase} | Corte: ${p.largo} x ${p.ancho}');
  }

  //Imprimir metros de canto agrupados por terminado y grosor
  print('\nCantos:');
  final Map<String, double> metrosPorCanto = {};
  for (var p in huacal.piezas) {
    if (p.canto05Vista  != null) { final key = '${p.canto05Vista!.nombre} 0.5mm';  metrosPorCanto[key] = (metrosPorCanto[key] ?? 0) + p.metrosCanto05Vista; }
    if (p.canto05Huacal != null) { final key = '${p.canto05Huacal!.nombre} 0.5mm'; metrosPorCanto[key] = (metrosPorCanto[key] ?? 0) + p.metrosCanto05Huacal; }
    if (p.canto10       != null) { final key = '${p.canto10!.nombre} 1mm';         metrosPorCanto[key] = (metrosPorCanto[key] ?? 0) + p.metrosCanto10; }
  }
  metrosPorCanto.forEach((nombre, metros) {
    print('$nombre: ${metros.toStringAsFixed(2)} mts');
  });

  //Imprimir la lista de herrajes
  print('Herrajes: ');
  for (var h in huacal.herrajes) {
    print('${h.cantidad}x ${h.nombre}');
  }
}