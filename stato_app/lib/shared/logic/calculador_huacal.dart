import '../models/pieza_corte.dart';
import '../models/huacal.dart';

class CalculadorHuacal {
  static Huacal fabricarHuacalEstandar({
    //Huacal estandar 
    required String nombre,
    required double alto,
    required double ancho,
    required double fondo,
    required double grosor,

    //Agregados unicos
    int numEntrepanos = 0,
    bool entrepanoFijo = false,
    bool tienePuerta = true 



  }) {
    
    double anchoInterno = ancho - (grosor * 2);
    double altoInterno  = alto - (grosor * 2);

    
    List<PiezaCorte> piezas = [
      PiezaCorte(nombre: "Lateral Izq", largo: alto, ancho: fondo),
      PiezaCorte(nombre: "Lateral Der", largo: alto, ancho: fondo),
      PiezaCorte(nombre: "Piso", largo: anchoInterno, ancho: fondo),
      PiezaCorte(nombre: "Techo", largo: anchoInterno, ancho: fondo),
      PiezaCorte(nombre: 'Trasera', largo: altoInterno, ancho: anchoInterno),
    ];

    if (numEntrepanos > 0 ) {
      if(entrepanoFijo){
        for (int i = 1; i <= numEntrepanos; i++) {
        piezas.add(PiezaCorte(
          nombre: "Entrepaño $i",
          largo: anchoInterno - 2,                  // Descuento de holgura
          ancho: fondo - 20,                        // Se hacen más cortos para que no peguen con la puerta
        ));
        }
      }
    }

   
    return Huacal(nombre: nombre, piezas: piezas);

  }

  
}


