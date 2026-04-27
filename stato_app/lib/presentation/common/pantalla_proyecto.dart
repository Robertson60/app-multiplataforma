import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'desplegable_proyecto.dart';

class PantallaListaProyectos extends StatelessWidget {
  final String clienteId;
  final String clienteNombre;
  final String rolUsuario;

  const PantallaListaProyectos({
    super.key,
    required this.clienteId,
    required this.clienteNombre,
    required this.rolUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Proyectos: $clienteNombre")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clientes')
            .doc(clienteId)
            .collection('proyectos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final proyectos = snapshot.data!.docs;

          if (proyectos.isEmpty) {
            return const Center(child: Text("No hay proyectos. Crea el primero."));
          }

          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = proyectos[index];
              final datos = proyecto.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.architecture),
                title: Text(datos['nombre'] ?? 'Proyecto'),
                subtitle: Text("Material: ${datos['materiales']?['maderas']?.join(', ') ?? 'N/A'}"),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  // Abrir editor de proyecto existente
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaProyecto(
                        clienteId: clienteId,
                        proyectoId: proyecto.id,
                        nombreClienteDefault: clienteNombre,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: (rolUsuario == 'admin' || rolUsuario == 'vendedor')
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaProyecto(
                      clienteId: clienteId,
                      nombreClienteDefault: clienteNombre,
                    ),
                  ),
                );
              },
              label: const Text("Nuevo Proyecto"),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}