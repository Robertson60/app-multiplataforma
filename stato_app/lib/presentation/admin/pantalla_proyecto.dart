import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'desplegable_proyecto.dart';

class PantallaListaProyectos extends StatelessWidget {
  // aqui recibo el id del cliente para buscar sus proyectos
  final String clienteId;

  // aqui guardo el nombre del cliente para mostrarlo en la pantalla
  final String clienteNombre;

  // aqui guardo el rol del usuario (admin, vendedor, etc.)
  final String rolUsuario;

  // este es mi constructor donde recibo los datos necesarios
  const PantallaListaProyectos({
    super.key,
    required this.clienteId,
    required this.clienteNombre,
    required this.rolUsuario,
  });

  @override
  Widget build(BuildContext context) {
    // aqui construyo la pantalla principal
    return Scaffold(
      // aqui muestro el nombre del cliente en el appbar
      appBar: AppBar(title: Text("Proyectos: $clienteNombre")),

      // aqui uso un streambuilder para escuchar cambios en firebase en tiempo real
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clientes') // entro a la coleccion clientes
            .doc(clienteId) // selecciono el cliente
            .collection('proyectos') // entro a sus proyectos
            .snapshots(), // escucho los cambios en tiempo real

        builder: (context, snapshot) {
          // si aun no hay datos, muestro un indicador de carga
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // aqui obtengo la lista de proyectos
          final proyectos = snapshot.data!.docs;

          // si no hay proyectos, muestro un mensaje
          if (proyectos.isEmpty) {
            return const Center(
              child: Text("No hay proyectos. Crea el primero."),
            );
          }

          // aqui construyo la lista de proyectos
          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              // aqui obtengo un proyecto individual
              final proyecto = proyectos[index];

              // aqui convierto los datos del proyecto a un mapa
              final datos = proyecto.data() as Map<String, dynamic>;

              return ListTile(
                // icono del proyecto
                leading: const Icon(Icons.architecture),

                // aqui muestro el nombre del proyecto
                title: Text(datos['nombre'] ?? 'Proyecto'),

                // aqui muestro los materiales (si existen)
                subtitle: Text(
                  "Material: ${datos['materiales']?['maderas']?.join(', ') ?? 'N/A'}",
                ),

                // icono de edicion
                trailing: const Icon(Icons.edit),

                // aqui abro la pantalla para editar el proyecto
                onTap: () {
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

      // aqui muestro el boton flotante solo si el usuario es admin o vendedor
      floatingActionButton:
          (rolUsuario == 'admin' || rolUsuario == 'vendedor')
              ? FloatingActionButton.extended(
                  // al presionar, voy a crear un nuevo proyecto
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