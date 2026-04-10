// importo la libreria principal de flutter para crear la app
import 'package:flutter/material.dart';

// importo mi pantalla principal donde estaran los procesos
import 'presentation/process_screen.dart';

void main() {
  // inicio la aplicacion ejecutando mi widget principal
  runApp(const MyApp());
}

// creo la clase principal de la aplicacion
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // construyo la aplicacion usando materialapp
    return MaterialApp(
      // defino el titulo de la aplicacion
      title: 'gestion de produccion',

      // configuro el tema de la aplicacion
      theme: ThemeData(
        // defino los colores usando una semilla
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        // activo material 3
        useMaterial3: true,
      ),

      // defino la pantalla principal que se va a mostrar
      home: const ProcessScreen(),
    );
  }
}
