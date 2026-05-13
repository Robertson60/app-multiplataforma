import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/services/firestore_services.dart';

class PantallaInventario extends StatefulWidget {
  final String rolUsuario;

  const PantallaInventario({super.key, required this.rolUsuario});

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {
  // =========================
  // FIREBASE
  // =========================

  final FirestoreService firestoreService = FirestoreService();

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
  // MENSAJE ERROR
  // =========================

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(mensaje)),
    );
  }

  // =========================
  // ACTUALIZAR CANTIDAD
  // =========================

  void actualizarCantidad(
    String tipo,
    String id,
    int cantidadActual,
    bool agregar,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(agregar ? "Agregar cantidad" : "Quitar cantidad"),

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
              onPressed: () async {
                int cantidad = int.tryParse(controller.text) ?? 0;

                int nuevaCantidad = agregar
                    ? cantidadActual + cantidad
                    : cantidadActual - cantidad;

                if (nuevaCantidad < 0) {
                  mostrarError("No hay suficiente inventario");

                  return;
                }

                await firestoreService.actualizarMaterial(tipo, id, {
                  "cantidad": nuevaCantidad,
                });

                if (nuevaCantidad <= 20) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.orange,

                      content: Text("⚠ Poco inventario en $tipo"),
                    ),
                  );
                }

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
  // FORMULARIOS
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

  Widget construirLista(String tipo, IconData icono) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.obtenerMateriales(tipo),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final documentos = snapshot.data!.docs;

        if (documentos.isEmpty) {
          return Text("No hay $tipo");
        }

        return Column(
          children: documentos.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                leading: Icon(icono),

                title: Text(
                  tipo == "correderas"
                      ? "Corredera ${data["medida"]} cm"
                      : tipo == "tableros"
                      ? data["color"]
                      : data["tipo"],
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    if (data["marca"] != null) Text("Marca: ${data["marca"]}"),

                    if (data["grosor"] != null)
                      Text("Grosor: ${data["grosor"]}"),

                    Text("Precio: \$${data["precio"]}"),

                    Text("Cantidad: ${data["cantidad"]}"),

                    if (data["cantidad"] <= 20)
                      const Text(
                        "⚠ Poco inventario",

                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // BOTON RESTAR
                    IconButton(
                      onPressed: () {
                        actualizarCantidad(
                          tipo,

                          doc.id,

                          data["cantidad"],

                          false,
                        );
                      },

                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                    ),

                    // BOTON SUMAR
                    IconButton(
                      onPressed: () {
                        actualizarCantidad(
                          tipo,

                          doc.id,

                          data["cantidad"],

                          true,
                        );
                      },

                      icon: const Icon(Icons.add_circle, color: Colors.green),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Bisagras",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            construirLista("bisagras", Icons.build),

            const SizedBox(height: 30),

            const Text(
              "Correderas",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            construirLista("correderas", Icons.linear_scale),

            const SizedBox(height: 30),

            const Text(
              "Tableros",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            construirLista("tableros", Icons.dashboard),
          ],
        ),
      ),
    );
  }
}
