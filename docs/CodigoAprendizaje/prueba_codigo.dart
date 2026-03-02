import 'dart:io';

void main() {
  //sirve para que el usurario escriba en el mismo renglon.
  stdout.write('Ingrese un numero A: ');

  //esto es para guardar la variable
  double entrada = double.parse(
    stdin.readLineSync()!,
  ); // Espera a que el usuario ingrese texto y presione Enter

  //es para escribir en pantalla.
  stdout.write('Ingrese un numero B: ');
  //guardar la variable
  double entrada2 = double.parse(
    stdin.readLineSync()!,
  ); // Espera a que el usuario ingrese texto y presione Enter

  double r = entrada + entrada2;

  print(r);
}
