import 'package:flutter/material.dart';
//import 'package:stato_app/presentation/shared_pantallas.dart';
import 'package:stato_app/shared/shared.dart';

class PantallaInventario extends StatefulWidget {
  final String rolUsuario;

  const PantallaInventario({super.key, required this.rolUsuario});

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {
  // =========================
  // HERRAJES
  // =========================

  List<Map<String, dynamic>> herrajes = [
    {"tipo": "Bisagra", "medida": "-", "cantidad": 100},

    {"tipo": "Corredera", "medida": "30", "cantidad": 50},

    {"tipo": "Corredera", "medida": "35", "cantidad": 50},

    {"tipo": "Corredera", "medida": "40", "cantidad": 50},

    {"tipo": "Corredera", "medida": "45", "cantidad": 50},

    {"tipo": "Corredera", "medida": "50", "cantidad": 50},
  ];

  // =========================
  // TABLEROS
  // =========================

  List<Map<String, dynamic>> tableros = [];

  // =========================
  // CONTROLADORES TABLEROS
  // =========================

  final grosorController = TextEditingController();
  final colorController = TextEditingController();
  final marcaController = TextEditingController();
  final cantidadController = TextEditingController();

  // =========================
  // AGREGAR TABLERO
  // =========================

  void agregarTablero() {
    if (grosorController.text.isEmpty ||
        colorController.text.isEmpty ||
        marcaController.text.isEmpty ||
        cantidadController.text.isEmpty) {
      return;
    }

    setState(() {
      tableros.add({
        "grosor": grosorController.text,
        "color": colorController.text,
        "marca": marcaController.text,
        "cantidad": int.parse(cantidadController.text),
      });
    });

    grosorController.clear();
    colorController.clear();
    marcaController.clear();
    cantidadController.clear();

    Navigator.pop(context);
  }

  // =========================
  // ELIMINAR TABLERO
  // =========================

  void eliminarTablero(int index) {
    setState(() {
      tableros.removeAt(index);
    });
  }

  // =========================
  // ALERTA INVENTARIO BAJO
  // =========================

  void verificarAlerta(String nombre, int cantidad) {
    if (cantidad <= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,

          content: Text("⚠ Poco inventario de: $nombre"),
        ),
      );
    }
  }

  // =========================
  // MENSAJE ERROR
  // =========================

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(mensaje)),
    );
  }

  // =========================
  // MODIFICAR HERRAJE
  // =========================

  void modificarHerraje(int index, bool agregar) {
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
                    herrajes[index]["cantidad"] += cantidad;
                  } else {
                    if (cantidad > herrajes[index]["cantidad"]) {
                      mostrarError("No hay material suficiente");
                    } else {
                      herrajes[index]["cantidad"] -= cantidad;

                      verificarAlerta(
                        "${herrajes[index]["tipo"]} ${herrajes[index]["medida"]}",
                        herrajes[index]["cantidad"],
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
                      mostrarError("No hay material suficiente");
                    } else {
                      tableros[index]["cantidad"] -= cantidad;

                      verificarAlerta(
                        "${tableros[index]["color"]} ${tableros[index]["marca"]}",
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
  // FORMULARIO TABLEROS
  // =========================

  void mostrarFormulario() {
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
                  controller: grosorController,
                  decoration: const InputDecoration(labelText: "Grosor"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: "Color"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: marcaController,
                  decoration: const InputDecoration(labelText: "Marca"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: cantidadController,
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
      appBar: AppBar(title: const Text('Inventario')),

      floatingActionButton: FloatingActionButton(
        onPressed: mostrarFormulario,

        child: const Icon(Icons.add),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // HERRAJES
            // =========================
            const Text(
              "Herrajes",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...herrajes.asMap().entries.map((entry) {
              int index = entry.key;
              var herraje = entry.value;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.build),

                  title: Text(herraje["tipo"]),

                  subtitle: Text("Medida: ${herraje["medida"]}"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      IconButton(
                        onPressed: () {
                          modificarHerraje(index, false);
                        },

                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),

                      Text(
                        "${herraje["cantidad"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          modificarHerraje(index, true);
                        },

                        icon: const Icon(Icons.add_circle, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            // =========================
            // TABLEROS
            // =========================
            const Text(
              "Tableros",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (tableros.isEmpty) const Text("No hay tableros agregados"),

            ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: tableros.length,

              itemBuilder: (context, index) {
                final tablero = tableros[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),

                    title: Text("${tablero["color"]} - ${tablero["marca"]}"),

                    subtitle: Text("Grosor: ${tablero["grosor"]}"),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          onPressed: () {
                            modificarTablero(index, false);
                          },

                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),

                        Text(
                          "${tablero["cantidad"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            modificarTablero(index, true);
                          },

                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            eliminarTablero(index);
                          },

                          icon: const Icon(Icons.delete, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
