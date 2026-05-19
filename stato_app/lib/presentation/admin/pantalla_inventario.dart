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
  final FirestoreService firestoreService = FirestoreService();

  final tipoBisagraController = TextEditingController();
  final marcaBisagraController = TextEditingController();
  final precioBisagraController = TextEditingController();
  final cantidadBisagraController = TextEditingController();

  final medidaCorrederaController = TextEditingController();
  final precioCorrederaController = TextEditingController();
  final cantidadCorrederaController = TextEditingController();

  final colorTableroController = TextEditingController();
  final marcaTableroController = TextEditingController();
  final grosorTableroController = TextEditingController();
  final precioTableroController = TextEditingController();
  final cantidadTableroController = TextEditingController();

  void actualizarCantidad(String coleccion, String docId, int nuevaCantidad, String nombre) async {
    if (nuevaCantidad < 0) {
      mostrarError("El inventario no puede ser menor a 0");
      return;
    }

    // 1. Primero guardamos la cantidad (incluso si es 0) 
    // para que la interfaz muestre el "0" físicamente.
    await firestoreService.actualizarMaterial(
      coleccion, 
      docId, 
      {'cantidad': nuevaCantidad}
    );


    if (nuevaCantidad == 0) {
      if (mounted) {
        // Quitamos cualquier aviso naranja anterior para que destaque este
        ScaffoldMessenger.of(context).clearSnackBars(); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("⚠ $nombre en 0. Se eliminará en 3 segundos..."),
            duration: const Duration(seconds: 3), // Duración visible del aviso
          ),
        );
      }

      // Hacemos que el código espere 3 segundos exactos
      await Future.delayed(const Duration(seconds: 3));

      final docRevisado = await FirebaseFirestore.instance.collection(coleccion).doc(docId).get();
      
      if (docRevisado.exists && docRevisado.data()?['cantidad'] == 0) {
        await firestoreService.eliminarMaterial(coleccion, docId);
      }
      
      return;
    }

    // Si la cantidad no es 0, hacemos la verificación normal de "poco inventario"
    verificarInventario(nombre, nuevaCantidad);
  }

  void mostrarDialogoCantidadFija(String coleccion, String docId, int actual, String nombre) {
    final controller = TextEditingController(text: actual.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajustar Stock: $nombre"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Cantidad Total Actual"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              int valor = int.tryParse(controller.text) ?? actual;
              actualizarCantidad(coleccion, docId, valor, nombre);
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void verificarInventario(String nombre, int cantidad) {
    if (cantidad <= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text("⚠ Poco inventario de $nombre: $cantidad piezas"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(mensaje)),
    );
  }

  void agregarBisagra() async {
    if (tipoBisagraController.text.isEmpty || precioBisagraController.text.isEmpty) return;
    Map<String, dynamic> datos = {
      "tipo": tipoBisagraController.text,
      "marca": marcaBisagraController.text,
      "precio": double.tryParse(precioBisagraController.text) ?? 0.0,
      "cantidad": int.tryParse(cantidadBisagraController.text) ?? 0,
    };
    await firestoreService.agregarMaterial("bisagras", datos);
    tipoBisagraController.clear();
    marcaBisagraController.clear();
    precioBisagraController.clear();
    cantidadBisagraController.clear();
    Navigator.pop(context);
  }

  void agregarCorredera() async {
    if (medidaCorrederaController.text.isEmpty || precioCorrederaController.text.isEmpty) return;
    Map<String, dynamic> datos = {
      "medida": int.tryParse(medidaCorrederaController.text) ?? 0,
      "tipo": "Aluminio",
      "marca": "Bum",
      "precio": double.tryParse(precioCorrederaController.text) ?? 0.0,
      "cantidad": int.tryParse(cantidadCorrederaController.text) ?? 0,
    };
    await firestoreService.agregarMaterial("correderas", datos);
    medidaCorrederaController.clear();
    precioCorrederaController.clear();
    cantidadCorrederaController.clear();
    Navigator.pop(context);
  }

  void agregarTablero() async {
    if (colorTableroController.text.isEmpty || precioTableroController.text.isEmpty) return;
    Map<String, dynamic> datos = {
      "color": colorTableroController.text,
      "marca": marcaTableroController.text,
      "grosor": grosorTableroController.text,
      "precio": double.tryParse(precioTableroController.text) ?? 0.0,
      "cantidad": int.tryParse(cantidadTableroController.text) ?? 0,
    };
    await firestoreService.agregarMaterial("tableros", datos);
    colorTableroController.clear();
    marcaTableroController.clear();
    grosorTableroController.clear();
    precioTableroController.clear();
    cantidadTableroController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventario")),
      floatingActionButton: _buildFloatingMenu(),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20, left: 20, right: 20, bottom: 220,
        ),
        children: [
          _buildSeccionInventario("bisagras", "Bisagras", Icons.build),
          const SizedBox(height: 30),
          _buildSeccionInventario("correderas", "Correderas", Icons.linear_scale),
          const SizedBox(height: 30),
          _buildSeccionInventario("tableros", "Tableros", Icons.dashboard),
        ],
      ),
    );
  }

  Widget _buildSeccionInventario(String coleccion, String titulo, IconData icono) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Divider(),
        StreamBuilder<QuerySnapshot>(
          stream: firestoreService.obtenerMateriales(coleccion),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final documentos = snapshot.data!.docs;

            if (documentos.isEmpty) return Text("No hay $titulo en existencia.");

            return Column(
              children: documentos.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final int stock = data['cantidad'] ?? 0;
                
                // Determinar nombre a mostrar según el tipo de material
                String nombreMostrar = "";
                if (coleccion == "bisagras") nombreMostrar = data['tipo'];
                if (coleccion == "correderas") nombreMostrar = "Corredera ${data['medida']} mm";
                if (coleccion == "tableros") nombreMostrar = data['color'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(icono),
                    title: Text(nombreMostrar, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Marca: ${data['marca']} | \$${data['precio']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón Restar 1
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                          onPressed: () => actualizarCantidad(coleccion, doc.id, stock - 1, nombreMostrar),
                        ),
                        // Cantidad (Click para ajuste manual)
                        GestureDetector(
                          onTap: () => mostrarDialogoCantidadFija(coleccion, doc.id, stock, nombreMostrar),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 193, 221, 235),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("$stock", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        // Botón Sumar 1
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => actualizarCantidad(coleccion, doc.id, stock + 1, nombreMostrar),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloatingMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: "add_bisagra",
          onPressed: () => _mostrarDialogoNuevo("Bisagra"),
          child: const Icon(Icons.build),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.small(
          heroTag: "add_corredera",
          onPressed: () => _mostrarDialogoNuevo("Corredera"),
          child: const Icon(Icons.linear_scale),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "add_tablero",
          onPressed: () => _mostrarDialogoNuevo("Tablero"),
          child: const Icon(Icons.dashboard),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _mostrarDialogoNuevo(String tipo) {
    if (tipo == "Bisagra") {
      _showForm(context, "Agregar Bisagra", [
        _buildField(tipoBisagraController, "Tipo (ej. Cobertura total)"),
        _buildField(marcaBisagraController, "Marca"),
        _buildField(precioBisagraController, "Precio", isNumber: true),
        _buildField(cantidadBisagraController, "Cantidad Inicial", isNumber: true),
      ], agregarBisagra);
    } else if (tipo == "Corredera") {
      _showForm(context, "Agregar Corredera", [
        _buildField(medidaCorrederaController, "Medida (cm)", isNumber: true),
        _buildField(precioCorrederaController, "Precio", isNumber: true),
        _buildField(cantidadCorrederaController, "Cantidad Inicial", isNumber: true),
      ], agregarCorredera);
    } else {
      _showForm(context, "Agregar Tablero", [
        _buildField(colorTableroController, "Color/Acabado"),
        _buildField(marcaTableroController, "Marca"),
        _buildField(grosorTableroController, "Grosor (ej. 15mm)"),
        _buildField(precioTableroController, "Precio", isNumber: true),
        _buildField(cantidadTableroController, "Cantidad Inicial", isNumber: true),
      ], agregarTablero);
    }
  }

  Widget _buildField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  void _showForm(BuildContext context, String title, List<Widget> fields, VoidCallback onSave) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: fields)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(onPressed: onSave, child: const Text("Guardar")),
        ],
      ),
    );
  }
}