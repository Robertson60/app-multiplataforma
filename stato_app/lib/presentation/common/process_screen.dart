import 'package:flutter/material.dart';
import '../../shared/logic/manager.dart';
import '../../shared/models/proyecto.dart';
import '../../shared/models/subproceso.dart';

class ProcesoPantalla extends StatefulWidget {
  const ProcesoPantalla({super.key});

  @override
  State<ProcesoPantalla> createState() => _ProcesoPantallaState();
}

class _ProcesoPantallaState extends State<ProcesoPantalla> {
  final ProcessManager manager = ProcessManager();
  final TextEditingController projectController = TextEditingController();

  Color _getStageColor(String stage) {
    switch (stage) {
      case Stages.venta:
        return Colors.blue.shade100;
      case Stages.produccion:
        return Colors.orange.shade100;
      case Stages.instalacion:
        return Colors.green.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Proyectos")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStageSection(Stages.venta, "Venta"),
            _buildStageSection(Stages.produccion, "Producción"),
            _buildStageSection(Stages.instalacion, "Instalación"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Nuevo proyecto"),
                content: TextField(
                  controller: projectController,
                  decoration: const InputDecoration(
                    labelText: "Nombre del proyecto",
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (projectController.text.isNotEmpty) {
                        setState(() {
                          manager.addProject(projectController.text);
                          projectController.clear();
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Agregar"),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Proyecto"),
      ),
    );
  }

  Widget _buildStageSection(String stage, String title) {
    final projects = manager.projects
        .where((p) => p.currentStage == stage)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...projects.map(
            (project) => Card(
              color: _getStageColor(stage),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                title: Text(
                  project.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: _buildProgress(project),
                children: [
                  // Lista de subprocesos
                  Column(
                    children: project.subProcesses.map((sub) {
                      return ListTile(
                        title: Text(sub.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                sub.isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: sub.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                _confirmCompletion(project, sub);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  manager.removeSubProcess(project.id, sub.id);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  // Campo para agregar subproceso
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            manager.addSubProcess(project.id, value);
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Nuevo subproceso",
                        prefixIcon: Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(Project project) {
    final completedCount = project.subProcesses
        .where((s) => s.isCompleted)
        .length;
    final totalCount = project.subProcesses.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (totalCount > 0)
          LinearProgressIndicator(
            value: progress,
            color: Colors.green,
            backgroundColor: Colors.grey[300],
          ),
        if (totalCount > 0)
          Text("$completedCount de $totalCount subprocesos completados"),
      ],
    );
  }

  void _confirmCompletion(Project project, SubProcess sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar avance"),
        content: Text(
          "¿Seguro que quieres marcar '${sub.name}' como completado?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Sí, avanzar"),
            onPressed: () {
              setState(() {
                manager.completeSubProcess(project.id, sub.id);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
