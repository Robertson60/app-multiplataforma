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

  void _modalNuevoCliente(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registrar Cliente"),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Nombre completo")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('clientes').add({'nombre': controller.text});
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          )
        ],
      ),
    );
  }
}