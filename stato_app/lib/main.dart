import 'package:flutter/material.dart';
//import 'package:stato_app/presentation/common/cotizador.dart';
import 'package:stato_app/presentation/common/login.dart';
import 'package:stato_app/shared/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.nombreApp,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PantallaLogin(),
    );
  }
}
