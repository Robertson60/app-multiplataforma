import '../shared.dart';

class CalculadorGabinete {

  //funcion principal del fabricante
  static Huacal fabricarHuacal({

    //Nombre y medidas requeridas para cada pieza individual 
    required String nombre,
    required double alto,
    required double ancho,
    required double fondo,
    
    //Valores constantes
    double grosorMelamina = AppConstants.grosorMelamina,

    //Variable confirmatoria de piezas 
    bool tieneLateralIzq = true,
    bool tieneLateralDer = true,
    bool tienePiso  = true,
    bool tieneTecho = true,

    //Configuracion para puerta y entrepaños
    ConfiguracionPuerta? configPuerta,
    ConfiguracionEntrepanos? configEntrepanos,

    //Configuracion de materiales (huacal = piezas internas, vista = puertas)
    ConfiguracionMaterial materialHuacal = const ConfiguracionMaterial(terminado: "Huacal"),
    ConfiguracionMaterial materialVista  = const ConfiguracionMaterial(terminado: "Vista",),

  }) {
    
    List<PiezaCorte> piezasFinales = [];
    List<Herraje> herrajesFinales = [];

    // Calculo dee medidas internas del huacal
    //Operador ternario ? X : Y forma abreviada de un if-else 
    int numLaterales = (tieneLateralIzq ? 1 : 0) + (tieneLateralDer ? 1 : 0);
    int numHorizontales = (tienePiso ? 1 : 0) + (tieneTecho ? 1 : 0);

    double anchoInterno = ancho - (grosorMelamina * numLaterales);
    double altoInterno = alto - (grosorMelamina * numHorizontales);

    //Contabilizar piezas iguales (Laterales)
    if (numLaterales > 0) {
      piezasFinales.add(PiezaCorte(   //Añade piezas al listado de las piezas
        nombre: "Laterales", 
        largoBase: alto, 
        anchoBase: fondo, 
        cantidad: numLaterales,
        canto05Vista:  materialVista.canto05(largo1: true),                              //Frente: color puerta .5mm
        canto05Huacal: materialHuacal.canto05(largo2: true, ancho1: true, ancho2: true), //Resto: color huacal .5mm
      ));
    }

    //Contabilizar piezas iguales (Piso/Techo)
    if (numHorizontales > 0) {
      piezasFinales.add(PiezaCorte(
        nombre: "Piso/Techo", 
        largoBase: anchoInterno, 
        anchoBase: fondo, 
        cantidad: numHorizontales,
        canto05Vista:  materialVista.canto05(largo1: true, ancho1: !tieneLateralIzq, ancho2: !tieneLateralDer), //Frente + fondos expuestos: color puerta .5mm
        canto05Huacal: materialHuacal.canto05(largo2: true),                                                    //Atras: color huacal .5mm
      ));
    }
    
    //Contabilizar respaldo
    piezasFinales.add(PiezaCorte(
      nombre: "Trasera", 
      largoBase: altoInterno, 
      anchoBase: anchoInterno,
      cantidad: 1,
    ));



    //Contabilizar Entrepaños
    if (configEntrepanos != null && configEntrepanos.cantidad > 0) {
      bool esMovil = configEntrepanos.tipo == TipoEntrepano.movil;
      double anchoE = esMovil                                              //Si la configuracion de entrepaño es movil
          ? anchoInterno - (configEntrepanos.holguraLateral * 2)           //Quitamos fugas para algo quitable
          : anchoInterno;                                                  //Si no el ancho interno total
      double fondoE = configEntrepanos.cortoAlFrente ? fondo - configEntrepanos.descuentoFondo : fondo; //Medidas de fondo

      piezasFinales.add(PiezaCorte(
        nombre: "Entrepaños (${configEntrepanos.tipo.name})",
        largoBase: anchoE,
        anchoBase: fondoE,
        cantidad: configEntrepanos.cantidad,
        canto05Vista:  esMovil ? null : materialVista.canto05(ancho1: true),                                             //Fijo: solo frente color puerta .5mm
        canto05Huacal: esMovil ? materialHuacal.canto05(largo1: true, largo2: true, ancho1: true, ancho2: true) : null, //Movil: 4 lados huacal .5mm
      ));
    }

    //Puertas y Jaladeras
    if (configPuerta != null) {
      double altoP = alto + configPuerta.descuentoPorJaladera + configPuerta.traslapeInferior;
      double anchoP = (configPuerta.cantidad == CantidadPuertas.dos)
          ? (ancho / 2) + (configPuerta.luzEntrePuertas)
          : ancho + configPuerta.luzEntrePuertas;
      
      int cantPuertas = (configPuerta.cantidad == CantidadPuertas.dos) ? 2 : 1;

      piezasFinales.add(PiezaCorte(
        nombre: "Puerta (${configPuerta.jaladera.name})", 
        largoBase: altoP,
        anchoBase: anchoP,
        cantidad: cantPuertas,
        canto10: materialVista.canto10(largo1: true, largo2: true, ancho1: true, ancho2: true), //Puertas: 4 lados vista 1mm
      ));

      // Herrajes para puertas
      //Jaladeras 
      if (configPuerta.jaladera == TipoJaladera.fisica) {
        herrajesFinales.add(Herraje(nombre: configPuerta.nombreJaladera, cantidad: cantPuertas));
      }

      // Bisagras
      //2 Bisagras por puerta hasta 900mm de alto, luego una adicional por cada 600mm  (.ceil() redondea hacia arriba)
      int bisagrasPorPuerta = alto <= 900 ? 2 : 2 + ((alto - 900) / 600).ceil();
      herrajesFinales.add(Herraje(nombre: configPuerta.nombreBisagra, cantidad: bisagrasPorPuerta * cantPuertas));
    }

    return Huacal(nombre: nombre, piezas: piezasFinales, herrajes: herrajesFinales);
  }
}
