import '../shared.dart';

class CalculadorGabinete {

  //funcion principal del fabricante
  static Huacal fabricarHuacal({

    //Nombre y medidas requeridas para cada pieza individual 
    required String nombre,
    required double alto,
    required double ancho,
    required double fondo,
    required double grosor,

    //Variable confirmatoria de piezas 
    bool tieneLateralIzq = true,
    bool tieneLateralDer = true,
    bool tienePiso = true,
    bool tieneTecho = true,

    //Configuracion para puerta y entrepaños
    ConfiguracionPuerta? configPuerta,
    ConfiguracionEntrepanos? configEntrepanos,

  }) {
    
    List<PiezaCorte> piezasFinales = [];
    List<Herraje> herrajesFinales = [];

    // Calculo del ancho interno del huacal
    //Operador ternario ? X : Y forma abreviada de un if-else 
    int numLaterales = (tieneLateralIzq ? 1 : 0) + (tieneLateralDer ? 1 : 0);
    double anchoInterno = ancho - (grosor * numLaterales);

    //Contabilizar piezas iguales (Laterales)
    if (numLaterales > 0) {
      piezasFinales.add(PiezaCorte(   //Añade piezas al listado de las piezas
        nombre: "Laterales", 
        largoBase: alto, 
        anchoBase: fondo, 
        cantidad: numLaterales
      ));
    }

    //Contabilizar piezas iguales (Piso/Techo)
    int numHorizontales = (tienePiso ? 1 : 0) + (tieneTecho ? 1 : 0);
    if (numHorizontales > 0) {
      piezasFinales.add(PiezaCorte(
        nombre: "Piso/Techo", 
        largoBase: anchoInterno, 
        anchoBase: fondo, 
        cantidad: numHorizontales
      ));
    }

    //Cantabilizar Entrepaños
    if (configEntrepanos != null && configEntrepanos.cantidad > 0) {
      double anchoE = (configEntrepanos.tipo == TipoEntrepano.movil)       //Si la configuracion de entrepaño es movil
          ? anchoInterno - (configEntrepanos.holguraLateral * 2)           //Quitamos fugas para algo quitable
          : anchoInterno;                                                  //Si no el ancho interno total
      double fondoE = configEntrepanos.cortoAlFrente ? fondo - configEntrepanos.descuentoFondo : fondo; //Medidas de fondo

      piezasFinales.add(PiezaCorte(
        nombre: "Entrepaños (${configEntrepanos.tipo.name})",
        largoBase: anchoE,
        anchoBase: fondoE,
        cantidad: configEntrepanos.cantidad
      ));
    }

    //Puertas y Jaladeras
    if (configPuerta != null) {
      double altoP = alto + configPuerta.descuentoPorJaladera + configPuerta.traslapeInferior;
      double anchoP = (configPuerta.cantidad == CantidadPuertas.dos)
          ? (ancho / 2) - (configPuerta.luzEntrePuertas / 2)
          : ancho - 4;
      
      int cantPuertas = (configPuerta.cantidad == CantidadPuertas.dos) ? 2 : 1;

      piezasFinales.add(PiezaCorte(
        nombre: "Puerta (${configPuerta.jaladera.name})", 
        largoBase: altoP,
        anchoBase: anchoP,
        cantidad: cantPuertas
      ));

      // Herrajes
      if (configPuerta.jaladera == TipoJaladera.fisica) {
        herrajesFinales.add(Herraje(nombre: "Jaladera Metálica", cantidad: cantPuertas));
      }
    }

    

    return Huacal(nombre: nombre, piezas: piezasFinales, herrajes: herrajesFinales);
  }

  
}
