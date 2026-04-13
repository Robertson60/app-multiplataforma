import 'package:stato_app/shared/shared.dart';

class ConfiguracionCanto {

  final double grosor;
  final String nombre;    //Color o tipo de canto
  final bool largo1;      //Arriba
  final bool largo2;      //Abajo
  final bool ancho1;      //Izquierda
  final bool ancho2;      //Derecha

  const ConfiguracionCanto ({

    this.grosor = AppConstants.grosorCanto05,
    this.nombre = "Canto",
    this.largo1 = false,
    this.largo2 = false,
    this.ancho1 = false,
    this.ancho2 = false,

  });

  double get descuentoLargo {
    double total = 0;
    if(largo1) total += grosor;
    if(largo2) total += grosor;
    return total;
  }

  double get descuentoAncho {
    double total = 0;
    if(ancho1) total += grosor;
    if(ancho2) total += grosor;
    return total;
  }
}