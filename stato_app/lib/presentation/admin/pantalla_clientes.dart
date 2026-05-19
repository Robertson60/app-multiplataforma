import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pantalla_proyecto.dart';


class PantallaListaClientes extends StatelessWidget {
  final String rolUsuario;

  const PantallaListaClientes({super.key, required this.rolUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes Stato"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clientes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error de conexión"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final clientes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              final datos = cliente.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueGrey),
                  title: Text(datos['nombre'] ?? 'Sin Nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // NAVEGACIÓN CLAVE: Pasar el ID del cliente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaListaProyectos(
                          clienteId: cliente.id,
                          clienteNombre: datos['nombre'],
                          rolUsuario: rolUsuario,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: (rolUsuario == 'admin' || rolUsuario == 'vendedor')
          ? FloatingActionButton.extended(
              onPressed: () => _modalNuevoCliente(context),
              label: const Text("Nuevo Cliente"),
              icon: const Icon(Icons.person_add),
            )
          : null,
    );
  }

  void _modalNuevoCliente(BuildContext context){
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController telefonoController = TextEditingController();
    final TextEditingController direccionController = TextEditingController();

    Future<void> agregarCliente() async {
      if (nombreController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          telefonoController.text.isNotEmpty &&
          direccionController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('clientes').add({
          'nombre': nombreController.text,
          'email': emailController.text,
          'telefono': telefonoController.text,
          'direccion': direccionController.text,
        });

        Navigator.pop(context);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nuevo Cliente"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(labelText: "Teléfono"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: direccionController,
                  decoration: const InputDecoration(labelText: "Dirección"),
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
              onPressed: agregarCliente,
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}

