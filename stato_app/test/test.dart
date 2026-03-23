// ignore_for_file: avoid_print

//Trae el archivo que engobla todos los archivos 
import 'package:stato_app/shared/shared.dart';

void main() {
  final miConfigPuerta = ConfiguracionPuerta(
    cantidad: CantidadPuertas.dos,
    jaladera: TipoJaladera.merenti, 
  );

  final alacena = CalculadorGabinete.fabricarHuacal(
    nombre: "Gabinete Especial",
    alto: 1800, ancho: 600, fondo: 600, grosor: 16,
    tieneLateralIzq: true,
    tieneLateralDer: true, 
    configPuerta: miConfigPuerta,
    configEntrepanos: ConfiguracionEntrepanos(cantidad: 4, tipo: TipoEntrepano.movil),
  );

  print('Módulo: ${alacena.nombre}');
  for (var p in alacena.piezas) {
    print('${p.cantidad}x ${p.nombre} de ${p.largoBase} x ${p.anchoBase}');
  }
}