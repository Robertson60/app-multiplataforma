enum TipoEntrepano { fijo, movil}

class ConfiguracionEntrepanos {
  final int cantidad;
  final TipoEntrepano tipo;
  final bool cortoAlFrente;    
  final double holguraLateral;
  final double descuentoFondo;

  ConfiguracionEntrepanos({
    this.cantidad = 1,
    this.tipo = TipoEntrepano.movil,
    this.cortoAlFrente = true,
    this.holguraLateral = 1.5,
    this.descuentoFondo = 40, 
  });
}