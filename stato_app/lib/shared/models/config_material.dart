import 'package:stato_app/shared/shared.dart';

class ConfiguracionMaterial {

  final String terminado;                          //Nombre del terminado (eje. "Blanco Frosty")

  const ConfiguracionMaterial({
    required this.terminado,
  });

  //Genera canto de .5mm con los lados que se necesiten
  ConfiguracionCanto canto05({bool largo1 = false, bool largo2 = false, bool ancho1 = false, bool ancho2 = false}) {
    return ConfiguracionCanto(
      nombre: terminado,
      grosor: AppConstants.grosorCanto05,
      largo1: largo1, largo2: largo2,
      ancho1: ancho1, ancho2: ancho2,
    );
  }

  //Genera canto de 1mm con los lados que se necesiten
  ConfiguracionCanto canto10({bool largo1 = false, bool largo2 = false, bool ancho1 = false, bool ancho2 = false}) {
    return ConfiguracionCanto(
      nombre: terminado,
      grosor: AppConstants.grosorCanto10,
      largo1: largo1, largo2: largo2,
      ancho1: ancho1, ancho2: ancho2,
    );
  }
}
