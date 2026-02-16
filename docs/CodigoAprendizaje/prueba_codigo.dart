//Define Opciones permitidas para campos del un objeto
import 'dart:io';

enum Acabados { Veteado, liso, Alto_Brillo }

enum GruesoMM {
  //Asignamos un nombre para guardar el numero de milimetros que representa cada tipo de grosor
  delgado(12),
  estandar(16),
  grueso(18);

  //Constructor que asigna el valor en milimetros a cada tipo de grosor
  final int milimetros;

  //Indicamos que el constructor es privado para evitar que se puedan crear mas valores
  const GruesoMM(this.milimetros);
}

class Maderas {
  String nombre;
  Acabados acabado;
  GruesoMM grueso;
  double precio;
  String Prooveedor;

  Maderas(this.nombre, this.acabado, this.grueso, this.precio, this.Prooveedor);
}

void main() {
  print("Prueba de ingreso de texto: ");

  stdout.write("Ingrese su nombre g: ");
  String? texto = stdin
      .readLineSync()!; // Espera a que el usuario ingrese texto y presione Enter

  stdout.write('Ingrese su edad: ');
  double? entrada = double.tryParse(
    stdin.readLineSync()!,
  ); // Espera a que el usuario ingrese texto y presione Enter

  print("Numero ingresado: $entrada");
  print("Texto ingresado: $texto");

  /*
  //Creamos un objeto de la clase Maderas con valores para cada campo
  Maderas madera1 = Maderas("Pino", Acabados.Veteado, GruesoMM.delgado, 100.0, "Proveedor A");
  //Imprimimos los valores del objeto creado
  print("Nombre: ${madera1.nombre}");
  print("Acabado: ${madera1.acabado}");
  print("Grueso: ${madera1.grueso.milimetros} mm");
  print("Precio: \$${madera1.precio}");
  print("Proveedor: ${madera1.Prooveedor}");
  print("Entrada del usuario: $entrada");
  */
}
