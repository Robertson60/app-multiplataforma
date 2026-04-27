import 'package:flutter/material.dart';
import 'package:stato_app/presentation/shared_pantallas.dart';


class PantallaAjustes extends StatefulWidget {
  final String rolUsuario;
  const PantallaAjustes({super.key, required this.rolUsuario});

  @override
  State<PantallaAjustes> createState() => _PantallaAjustesState();
}

class _PantallaAjustesState extends State<PantallaAjustes> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes') ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(

          ),
        ),
      ),
    );
  } 
}