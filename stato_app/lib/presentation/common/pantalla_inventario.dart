import 'package:flutter/material.dart';
import 'package:stato_app/presentation/shared_pantallas.dart';


class PantallaInventario extends StatefulWidget {
  final String rolUsuario;
  const PantallaInventario({super.key, required this.rolUsuario});

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario') ),
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