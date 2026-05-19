import 'package:flutter/material.dart';
import 'package:stato_app/shared/shared.dart';

class PantallaProceso extends StatefulWidget {
  const PantallaProceso({super.key});

  @override
  State<PantallaProceso> createState() => _PantallaProcesoState();
}

class _PantallaProcesoState extends State<PantallaProceso> {
  // aqui creo una instancia del manager que controla los proyectos y procesos
  final manager = ProcessManager();

  @override
  Widget build(BuildContext context) {
    // aqui construyo la pantalla principal
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Proyectos")),

      // aqui uso scroll horizontal para ver todas las etapas
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // aqui construyo cada etapa principal
            _buildStage(Stage.venta, "Ventas", Colors.blue),
            _buildStage(Stage.produccion, "Taller", Colors.orange),
            _buildStage(Stage.instalacion, "Instalación", Colors.green),
          ],
        ),
      ),

      // este boton flotante me sirve para agregar nuevos proyectos
      floatingActionButton: FloatingActionButton(
        onPressed: _addProjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // aqui construyo cada etapa (venta, produccion, instalacion)
  Widget _buildStage(Stage stage, String title, Color color) {
    // aqui obtengo los procesos de esa etapa
    final processes = manager.stageProcesses[stage]!;

    return Container(
      width: 350,
      margin: const EdgeInsets.all(10),

      // aqui doy estilo a la columna
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          // aqui muestro el encabezado de la etapa
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

          // aqui pongo el boton para agregar procesos a esta etapa
          TextButton.icon(
            onPressed: () => _addProcessDialog(stage),
            icon: const Icon(Icons.add),
            label: const Text("Añadir proceso"),
          ),

          // aqui muestro la lista de procesos con sus proyectos
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

  // aqui construyo cada subproceso como una "mini columna"
  Widget _buildProcessColumn(Stage stage, int index, subProcess) {
    // aqui filtro los proyectos que estan en este proceso
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
            // aqui muestro el nombre del proceso
            Row(
              children: [
                Expanded(
                  child: Text(
                    subProcess.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // aqui pongo boton para eliminar el proceso
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

            // aqui muestro los proyectos dentro de este proceso
            ...projects.map((p) => _buildProjectCard(p)),
          ],
        ),
      ),
    );
  }

  // aqui construyo la tarjeta de cada proyecto
  Widget _buildProjectCard(Project project) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),

      child: ListTile(
        // aqui muestro el nombre del proyecto
        title: Text(project.name),

        // este boton sirve para avanzar el proyecto al siguiente proceso
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

  // aqui abro un dialogo para agregar un nuevo proceso
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

  // aqui abro un dialogo para agregar un nuevo proyecto
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