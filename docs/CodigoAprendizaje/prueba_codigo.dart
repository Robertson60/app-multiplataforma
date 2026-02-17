import 'dart:io';

//Creacion de una clase interna 
class Calculos{

  double suma(double a, double b){
    return a +b;
  }

  double resta(double a, double b){
    return a - b;
  }

  double multiplicacion(double a, double b){
    return a * b;
  }

  double division(double a, double b){
    
    if (b ==0){
      print('No se puede dividir por cero');
      return 0;
    }
    return a/b;
  }
}


void main() {

  stdout.write('Ingrese un numero A: ');
  double? entrada = double.tryParse(
  stdin.readLineSync()!,); // Espera a que el usuario ingrese texto y presione Enter

  stdout.write('Ingrese un numero B: ');
  double? entrada2 = double.tryParse(
  stdin.readLineSync()!,); // Espera a que el usuario ingrese texto y presione Enter

  Calculos calculos = new Calculos();


  print('La suma de A y B es: ${calculos.suma(entrada!, entrada2!)}');
  print("Numero ingresado: $entrada");


}
