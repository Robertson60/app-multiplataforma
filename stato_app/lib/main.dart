// importo la libreria principal de flutter para crear la app
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stato_app/presentation/common/pantalla_login.dart';
import 'package:stato_app/shared/app_constants.dart';
import 'package:stato_app/auth/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// creo la clase principal de la aplicacion
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // construyo la aplicacion usando materialapp
    return MaterialApp(
      title: AppConstants.nombreApp,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PantallaLogin(),
    );
  }
}
