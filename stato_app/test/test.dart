// ignore_for_file: avoid_print

import 'package:stato_app/shared/logic/calculador_huacal.dart';
import 'package:stato_app/shared/shared.dart'; // Importamos todo desde el barrel file

void main() {
  print('--- 🪚 PRUEBA DE DESPIECE: MÓDULO DE COCINA ---');

  // 1. Definimos las medidas que nos daría el cliente
  double altoCliente = 700.0;  // 70 cm
  double anchoCliente = 900.0; // 60 cm
  double fondoCliente = 600.0; // 30 cm
  double grosorMdf = 16.0;     // 15 mm

  // 2. Usamos el calculador para "fabricar" el módulo
  // Aquí es donde se conectan los 3 archivos:
  // Calculador crea las Piezas y las mete en el Modulo.
  
  final miHuacal = CalculadorHuacal.fabricarHuacalEstandar(
    
    nombre: 'Fregadero', 
    alto: altoCliente, 
    ancho: anchoCliente, 
    fondo: fondoCliente, 
    grosor: grosorMdf);

  // 3. Imprimimos los resultados en consola
  print('Mueble: ${miHuacal.nombre}');
  print('Medidas Externas: ${anchoCliente}x${altoCliente}x$fondoCliente mm');
  print('-------------------------------------------');
  print('LISTA DE CORTE PARA TALLER:');

  for (var pieza in miHuacal.piezas) {
    print('- ${pieza.nombre}: ${pieza.largo} x ${pieza.ancho} mm');
  }

  print('-------------------------------------------');
  
  // 4. Probamos el cálculo del área total (importante para costos)
  double areaTotalCm2 = miHuacal.areaTotal / 100; // Convertimos mm2 a cm2
  print('Área total de melamina: ${areaTotalCm2.toStringAsFixed(2)} cm²');
  
  print('--- ✅ PRUEBA FINALIZADA CON ÉXITO ---');
}