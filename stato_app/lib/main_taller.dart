import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stato_app/main.dart';
import 'package:stato_app/shared/app_constants.dart';
import 'package:stato_app/auth/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp(tipoApp: TipoAplicacion.taller));
}