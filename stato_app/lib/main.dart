import 'package:flutter/material.dart';
import 'package:stato_app/presentation/shared/pantalla_login.dart';
import 'package:stato_app/shared/app_constants.dart';

// Este archivo ya no corre por sí solo, sirve como la estructura base compartida
class MyApp extends StatelessWidget {
  final TipoAplicacion tipoApp;
  const MyApp({super.key, required this.tipoApp});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.nombreApp,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PantallaLogin(tipoApp: tipoApp),
    );
  }
}