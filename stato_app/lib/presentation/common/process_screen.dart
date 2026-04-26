import 'package:flutter/material.dart';
import 'package:stato_app/shared/shared.dart';

class ProcesoPantalla extends StatefulWidget {
  const ProcesoPantalla({super.key});

  @override
  State<ProcesoPantalla> createState() => _ProcesoPantallaState();
}

class _ProcesoPantallaState extends State<ProcesoPantalla> {
  final manager = ProcessManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Proyectos")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStage(Stage.venta, "Ventas", Colors.blue),
            _buildStage(Stage.produccion, "Taller", Colors.orange),
            _buildStage(Stage.instalacion, "Instalación", Colors.green),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // 🔥 NUEVO: CADA ETAPA TIENE SUS PROCESOS COMO COLUMNAS INTERNAS
  Widget _buildStage(Stage stage, String title, Color color) {
    final processes = manager.stageProcesses[stage]!;

    return Container(
      width: 350,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ENCABEZADO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ➕ AGREGAR PROCESO
          TextButton.icon(
            onPressed: () => _addProcessDialog(stage),
            icon: const Icon(Icons.add),
            label: const Text("Añadir proceso"),
          ),

          // 🔥 LISTA DE PROCESOS (CADA UNO CON SUS PROYECTOS)
          Expanded(
            child: ListView(
              children: processes
                  .asMap()
                  .entries
                  .map(
                    (entry) =>
                        _buildProcessColumn(stage, entry.key, entry.value),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CADA PROCESO ES UNA "SUB-COLUMNA"
  Widget _buildProcessColumn(Stage stage, int index, subProcess) {
    final projects = manager.projects.where(
      (p) =>
          Stage.values[p.currentProcessIndex] == stage &&
          p.currentSubIndex == index,
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOMBRE DEL PROCESO
            Row(
              children: [
                Expanded(
                  child: Text(
                    subProcess.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () {
                    setState(() {
                      manager.removeSubProcessFromStage(stage, subProcess.id);
                    });
                  },
                ),
              ],
            ),

            const Divider(),

            // 🔥 PROYECTOS DENTRO DEL PROCESO
            ...projects.map((p) => _buildProjectCard(p)),
          ],
        ),
      ),
    );
  }

  // 🔥 TARJETA DE PROYECTO
  Widget _buildProjectCard(Project project) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(project.name),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              manager.completeSubProcess(project);
            });
          },
        ),
      ),
    );
  }

  void _addProcessDialog(Stage stage) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuevo proceso"),
        content: TextField(controller: controller),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                manager.addSubProcessToStage(stage, controller.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Agregar"),
          ),
        ],
      ),
    );
  }

  void _addProjectDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuevo Proyecto"),
        content: TextField(controller: controller),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                manager.addProject(controller.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Agregar"),
          ),
        ],
      ),
    );
  }
}
