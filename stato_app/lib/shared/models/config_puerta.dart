enum TipoJaladera { fisica, merenti, push, sobrada}
enum CantidadPuertas { una, dos}

class ConfiguracionPuerta {
  final CantidadPuertas cantidad;
  final TipoJaladera jaladera; 
  final double traslapeInferior; 
  final double luzEntrePuertas;
  final String nombreBisagra;
  final String nombreJaladera;

  ConfiguracionPuerta({
    this.cantidad = CantidadPuertas.dos,
    this.jaladera = TipoJaladera.fisica,
    this.traslapeInferior = -1.5,
    this.luzEntrePuertas = -3.0,
    this.nombreBisagra = "Bisagra",
    this.nombreJaladera = "Jaladera Metálica",
  });

  double get descuentoPorJaladera {
    switch (jaladera) {
      case TipoJaladera.fisica:
        return -5.0; 
      case TipoJaladera.merenti:
        return -30.0; 
      case TipoJaladera.push:
        return -1.5;     
      case TipoJaladera.sobrada:
        return 30.0;  }
  }
}