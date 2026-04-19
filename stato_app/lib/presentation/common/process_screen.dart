import 'package:flutter/material.dart';

import '../shared/logic/manager.dart';

class ProcesoPantalla extends StatefulWidget {
  const ProcesoPantalla({super.key});

  @override
  State<ProcesoPantalla> createState() => _ProcesoPantallaState();
}

class _ProcesoPantallaState extends State<ProcesoPantalla> {
  final manager = ProcessManager();
  final controller = TextEditingController();

  String getStageName(Stage stage) {
    switch (stage) {
      case Stage.venta:
        return "Ventas";
      case Stage.produccion:
        return "Producción";
      case Stage.instalacion:
        return "Instalación";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Procesos")),
      body: ListView(
        children: manager.projects.map((project) {
          final process = project.processes[project.currentProcessIndex];

          return Card(
            child: ExpansionTile(
              title: Text(project.name),
              subtitle: Text(getStageName(process.stage)),
              children: [
                ...process.subProcesses.map((sub) {
                  return ListTile(
                    title: Text(sub.name),
                    trailing: IconButton(
                      icon: Icon(
                        sub.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                      ),
                      onPressed: sub.isCompleted
                          ? null
                          : () {
                              setState(() {
                                manager.completeSubProcess(project.id, sub.id);
                              });
                            },
                    ),
                  );
                }),
                TextField(
                  onSubmitted: (value) {
                    setState(() {
                      manager.addSubProcess(project.id, value);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Nuevo subproceso",
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Nuevo proyecto"),
                content: TextField(controller: controller),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        manager.addProject(controller.text);
                        controller.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Agregar"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
