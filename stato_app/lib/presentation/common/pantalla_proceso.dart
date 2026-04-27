// Importo la libreria principal de Flutter para crear la interfaz
import 'package:flutter/material.dart';

// Importo mi logica donde manejo los procesos
import '../../shared/logic/manager.dart';

// Defino la pantalla principal como un widget con estado
class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

// Aqui manejo el estado de mi pantalla
class _ProcessScreenState extends State<ProcessScreen> {
  // Creo una instancia del manager para controlar mis procesos
  final ProcessManager manager = ProcessManager();

  // Creo un controlador para leer lo que escribo en el TextField
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Uso Scaffold como estructura base de mi pantalla
    return Scaffold(
      // Aqui creo la barra superior con un titulo
      appBar: AppBar(title: const Text("Gestion de Procesos")),

      // Aqui construyo todo el contenido de la pantalla
      body: Column(
        children: [
          // Aqui creo el campo para agregar procesos
          Padding(
            padding: const EdgeInsets.all(8.0), // Le doy espacio alrededor
            child: Row(
              children: [
                // Hago que el campo de texto ocupe todo el espacio disponible
                Expanded(
                  child: TextField(
                    controller: controller, // Conecto el controlador
                    decoration: const InputDecoration(
                      labelText: "Nombre del proceso", // Texto de ayuda
                    ),
                  ),
                ),

                // Creo el boton para agregar procesos
                ElevatedButton(
                  onPressed: () {
                    // Verifico que el campo no este vacio
                    if (controller.text.isNotEmpty) {
                      // Actualizo la interfaz
                      setState(() {
                        // Agrego el proceso usando el manager
                        manager.addProcess(controller.text);

                        // Limpio el campo de texto
                        controller.clear();
                      });
                    }
                  },
                  child: const Text("Agregar"),
                ),
              ],
            ),
          ),

          // Aqui muestro la lista de procesos
          Expanded(
            child: ListView.builder(
              // Indico cuantos procesos hay
              itemCount: manager.processes.length,

              // Construyo cada elemento de la lista
              itemBuilder: (context, index) {
                // Obtengo el proceso actual
                final process = manager.processes[index];

                return ListTile(
                  // Muestro el nombre del proceso
                  title: Text(process.name),

                  // Agrego botones al lado derecho
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Ajusto el tamaño
                    children: [
                      // Boton para marcar como completado
                      IconButton(
                        icon: Icon(
                          // Cambio el icono dependiendo si esta completo o no
                          process.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,

                          // Cambio el color dependiendo del estado
                          color: process.isCompleted
                              ? Colors.green
                              : Colors.grey,
                        ),

                        onPressed: () {
                          setState(() {
                            // Marco el proceso como completado
                            manager.markCompleted(index);
                          });
                        },
                      ),

                      // Boton para eliminar el proceso
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            // Elimino el proceso de la lista
                            manager.removeProcess(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Aqui muestro cual es el proceso actual
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              // Si ya complete todos los procesos muestro este mensaje
              manager.currentStep == -1
                  ? "Todos los procesos completados"
                  // Si no, muestro el proceso actual
                  : "Proceso actual: ${manager.processes[manager.currentStep].name}",

              // Le doy estilo al texto
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
