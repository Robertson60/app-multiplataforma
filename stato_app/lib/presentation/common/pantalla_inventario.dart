import 'package:flutter/material.dart';
import '../../shared/services/firestore_services.dart';
//import 'package:stato_app/presentation/shared_pantallas.dart';

import 'package:stato_app/shared/shared.dart';

class PantallaInventario extends StatefulWidget {
  final String rolUsuario;

  const PantallaInventario({super.key, required this.rolUsuario});

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {
  final FirestoreService firestoreService = FirestoreService();
  // =========================
  // BISAGRAS
  // =========================

  List<Map<String, dynamic>> bisagras = [];

  // =========================
  // CORREDERAS
  // =========================

  List<Map<String, dynamic>> correderas = [];

  // =========================
  // TABLEROS
  // =========================

  List<Map<String, dynamic>> tableros = [];

  // =========================
  // CONTROLADORES BISAGRAS
  // =========================

  final tipoBisagraController = TextEditingController();

  final marcaBisagraController = TextEditingController();

  final precioBisagraController = TextEditingController();

  final cantidadBisagraController = TextEditingController();

  // =========================
  // CONTROLADORES CORREDERAS
  // =========================

  final medidaCorrederaController = TextEditingController();

  final precioCorrederaController = TextEditingController();

  final cantidadCorrederaController = TextEditingController();

  // =========================
  // CONTROLADORES TABLEROS
  // =========================

  final colorTableroController = TextEditingController();

  final marcaTableroController = TextEditingController();

  final grosorTableroController = TextEditingController();

  final precioTableroController = TextEditingController();

  final cantidadTableroController = TextEditingController();

  // =========================
  // AGREGAR BISAGRA
  // =========================

  void agregarBisagra() async {
    if (tipoBisagraController.text.isEmpty ||
        marcaBisagraController.text.isEmpty ||
        precioBisagraController.text.isEmpty ||
        cantidadBisagraController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> datos = {
      "tipo": tipoBisagraController.text,

      "marca": marcaBisagraController.text,

      "precio": double.parse(precioBisagraController.text),

      "cantidad": int.parse(cantidadBisagraController.text),
    };

    await firestoreService.agregarMaterial("bisagras", datos);

    tipoBisagraController.clear();
    marcaBisagraController.clear();
    precioBisagraController.clear();
    cantidadBisagraController.clear();

    Navigator.pop(context);
  }

  // =========================
  // AGREGAR CORREDERA
  // =========================

  void agregarCorredera() async {
    if (medidaCorrederaController.text.isEmpty ||
        precioCorrederaController.text.isEmpty ||
        cantidadCorrederaController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> datos = {
      "medida": int.parse(medidaCorrederaController.text),

      "tipo": "Aluminio",

      "marca": "Bum",

      "precio": double.parse(precioCorrederaController.text),

      "cantidad": int.parse(cantidadCorrederaController.text),
    };

    await firestoreService.agregarMaterial("correderas", datos);

    medidaCorrederaController.clear();
    precioCorrederaController.clear();
    cantidadCorrederaController.clear();

    Navigator.pop(context);
  }

  // =========================
  // AGREGAR TABLERO
  // =========================

  void agregarTablero() async {
    if (colorTableroController.text.isEmpty ||
        marcaTableroController.text.isEmpty ||
        grosorTableroController.text.isEmpty ||
        precioTableroController.text.isEmpty ||
        cantidadTableroController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> datos = {
      "color": colorTableroController.text,

      "marca": marcaTableroController.text,

      "grosor": grosorTableroController.text,

      "precio": double.parse(precioTableroController.text),

      "cantidad": int.parse(cantidadTableroController.text),
    };

    await firestoreService.agregarMaterial("tableros", datos);

    colorTableroController.clear();
    marcaTableroController.clear();
    grosorTableroController.clear();
    precioTableroController.clear();
    cantidadTableroController.clear();

    Navigator.pop(context);
  }

  // =========================
  // ALERTA INVENTARIO
  // =========================

  void verificarInventario(String nombre, int cantidad) {
    if (cantidad <= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,

          content: Text("⚠ Poco inventario de $nombre"),
        ),
      );
    }
  }

  // =========================
  // ERROR INVENTARIO
  // =========================

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(mensaje)),
    );
  }

  // =========================
  // MODIFICAR BISAGRA
  // =========================

  void modificarBisagra(int index, bool agregar) {
    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(agregar ? "Agregar piezas" : "Quitar piezas"),

          content: TextField(
            controller: controller,

            keyboardType: TextInputType.number,

            decoration: const InputDecoration(labelText: "Cantidad"),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () {
                int cantidad = int.tryParse(controller.text) ?? 0;

                setState(() {
                  if (agregar) {
                    bisagras[index]["cantidad"] += cantidad;
                  } else {
                    if (cantidad > bisagras[index]["cantidad"]) {
                      mostrarError("No hay suficiente inventario");
                    } else {
                      bisagras[index]["cantidad"] -= cantidad;

                      verificarInventario(
                        bisagras[index]["tipo"],

                        bisagras[index]["cantidad"],
                      );
                    }
                  }
                });

                Navigator.pop(context);
              },

              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // MODIFICAR CORREDERA
  // =========================

  void modificarCorredera(int index, bool agregar) {
    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(agregar ? "Agregar piezas" : "Quitar piezas"),

          content: TextField(
            controller: controller,

            keyboardType: TextInputType.number,

            decoration: const InputDecoration(labelText: "Cantidad"),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () {
                int cantidad = int.tryParse(controller.text) ?? 0;

                setState(() {
                  if (agregar) {
                    correderas[index]["cantidad"] += cantidad;
                  } else {
                    if (cantidad > correderas[index]["cantidad"]) {
                      mostrarError("No hay suficiente inventario");
                    } else {
                      correderas[index]["cantidad"] -= cantidad;

                      verificarInventario(
                        "Corredera ${correderas[index]["medida"]}",

                        correderas[index]["cantidad"],
                      );
                    }
                  }
                });

                Navigator.pop(context);
              },

              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // MODIFICAR TABLERO
  // =========================

  void modificarTablero(int index, bool agregar) {
    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(agregar ? "Agregar piezas" : "Quitar piezas"),

          content: TextField(
            controller: controller,

            keyboardType: TextInputType.number,

            decoration: const InputDecoration(labelText: "Cantidad"),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () {
                int cantidad = int.tryParse(controller.text) ?? 0;

                setState(() {
                  if (agregar) {
                    tableros[index]["cantidad"] += cantidad;
                  } else {
                    if (cantidad > tableros[index]["cantidad"]) {
                      mostrarError("No hay suficiente inventario");
                    } else {
                      tableros[index]["cantidad"] -= cantidad;

                      verificarInventario(
                        tableros[index]["color"],

                        tableros[index]["cantidad"],
                      );
                    }
                  }
                });

                Navigator.pop(context);
              },

              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // FORMULARIO BISAGRA
  // =========================

  void mostrarFormularioBisagra() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Bisagra"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: tipoBisagraController,
                  decoration: const InputDecoration(labelText: "Tipo"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: marcaBisagraController,
                  decoration: const InputDecoration(labelText: "Marca"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: precioBisagraController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Precio"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: cantidadBisagraController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Cantidad"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: agregarBisagra,

              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // FORMULARIO CORREDERA
  // =========================

  void mostrarFormularioCorredera() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Corredera"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: medidaCorrederaController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(labelText: "Medida"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: precioCorrederaController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(labelText: "Precio"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: cantidadCorrederaController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(labelText: "Cantidad"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: agregarCorredera,

              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // FORMULARIO TABLERO
  // =========================

  void mostrarFormularioTablero() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Tablero"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: colorTableroController,

                  decoration: const InputDecoration(labelText: "Color"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: marcaTableroController,

                  decoration: const InputDecoration(labelText: "Marca"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: grosorTableroController,

                  decoration: const InputDecoration(labelText: "Grosor"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: precioTableroController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(labelText: "Precio"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: cantidadTableroController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(labelText: "Cantidad"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: agregarTablero,

              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventario")),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          FloatingActionButton(
            heroTag: "bisagra",

            onPressed: mostrarFormularioBisagra,

            child: const Icon(Icons.build),
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "corredera",

            onPressed: mostrarFormularioCorredera,

            child: const Icon(Icons.linear_scale),
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "tablero",

            onPressed: mostrarFormularioTablero,

            child: const Icon(Icons.dashboard),
          ),
        ],
      ),

      body: const Center(child: Text("Inventario funcionando")),
    );
  }
}
