enum TipoJaladera { fisica, merenti, push, sobrada}
enum CantidadPuertas { una, dos, cuatro}

class ConfiguracionPuerta {
  final CantidadPuertas cantidad;
  final TipoJaladera jaladera; 
  final double traslapeInferior; 
  final double luzEntrePuertas;  

  ConfiguracionPuerta({
    this.cantidad = CantidadPuertas.dos,
    this.jaladera = TipoJaladera.fisica,
    this.traslapeInferior = -1.5,
    this.luzEntrePuertas = -3.0,
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