import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'desplegable_huacal.dart';
import '../../shared/shared.dart';

class PantallaProyecto extends StatefulWidget {
  final String clienteId;
  final String? proyectoId; // Si es null, el proyecto es nuevo
  final String nombreClienteDefault;

  const PantallaProyecto({
    super.key,
    required this.clienteId,
    required this.nombreClienteDefault,
    this.proyectoId,
  });

  @override
  State<PantallaProyecto> createState() => _PantallaProyectoState();
}

class _PantallaProyectoState extends State<PantallaProyecto> {
  // --- ESTADO DEL PROYECTO ---
  String nombreProyecto = "";
  List<String> melaminas = [];
  Map<String, dynamic> herrajes = {
    'bisagras': {'nombre': '', 'marca': ''},
    'correderas': {'nombre': '', 'marca': ''},
    'jaladeras': {'nombre': 'N/A', 'marca': 'N/A'},
  };
  List<Map<String, dynamic>> modulos = [];

  // Controladores para el modal de configuración
  final _nombreProyCtrl = TextEditingController();
  final _bisagraNom = TextEditingController();
  final _bisagraMar = TextEditingController();
  final _correderaNom = TextEditingController();
  final _correderaMar = TextEditingController();
  final _jaladeraNom = TextEditingController(text: "N/A");
  final _jaladeraMar = TextEditingController(text: "N/A");
  final _nuevaMaderaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.proyectoId != null) {
      _cargarDatosProyecto();
    } else {
      // Si es nuevo, abrir configuración automáticamente al cargar
      WidgetsBinding.instance.addPostFrameCallback((_) => _abrirConfiguracion());
    }
  }

  // --- CARGA DE DATOS DESDE FIREBASE ---
  void _cargarDatosProyecto() async {
    final doc = await FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.clienteId)
        .collection('proyectos')
        .doc(widget.proyectoId)
        .get();

    if (doc.exists) {
      final d = doc.data()!;
      setState(() {
        nombreProyecto = d['nombre'] ?? '';
        melaminas = List<String>.from(d['materiales']['maderas'] ?? []);
        herrajes = d['materiales']['herrajes'] ?? herrajes;
        modulos = List<Map<String, dynamic>>.from(d['modulos'] ?? []);
        
        // Sincronizar controladores
        _nombreProyCtrl.text = nombreProyecto;
        _bisagraNom.text = herrajes['bisagras']['nombre'];
        _bisagraMar.text = herrajes['bisagras']['marca'];
        _correderaNom.text = herrajes['correderas']['nombre'];
        _correderaMar.text = herrajes['correderas']['marca'];
        _jaladeraNom.text = herrajes['jaladeras']['nombre'];
        _jaladeraMar.text = herrajes['jaladeras']['marca'];
      });
    }
  }

  // --- LÓGICA DE EDICIÓN DE MÓDULO ---
  void _editarModulo(int index) async {
    final resultado = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FormularioModulo(
        coloresProyecto: melaminas,
        marcaHerrajes: herrajes['bisagras']['marca'],
        datosEdicion: modulos[index], // Pasar datos actuales
      ),
    );

    if (resultado != null) {
      setState(() {
        modulos[index] = resultado;
      });
    }
  }

  // --- VISUALIZAR DESPIECE (MEDIDAS) ---
  void _verDespieceMueble(Map<String, dynamic> m, int index) {
    final huacal = CalculadorGabinete.fabricarHuacal(
      nombre: m['nombre'],
      alto: double.tryParse(m['medidas']['alto'].toString()) ?? 0,
      ancho: double.tryParse(m['medidas']['ancho'].toString()) ?? 0,
      fondo: double.tryParse(m['medidas']['fondo'].toString()) ?? 0,
      materialHuacal: ConfiguracionMaterial(terminado: m['colores']['gabinete']),
      materialVista: ConfiguracionMaterial(terminado: m['colores']['vista']),
      configPuerta: (m['puertas']['cantidad'] > 0)
          ? ConfiguracionPuerta(cantidad: m['puertas']['cantidad'] == 2 ? CantidadPuertas.dos : CantidadPuertas.una)
          : null,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //shape: const RoundedRectangleBorder(borderRadius: Radius.circular(top: Radius.circular(25))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Piezas: ${m['nombre']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _editarModulo(index);
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  label: const Text("Editar", style: TextStyle(color: Colors.orange)),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: huacal.piezas.length,
                itemBuilder: (context, i) {
                  final pieza = huacal.piezas[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text("${pieza.cantidad}")),
                    title: Text(pieza.nombre),
                    subtitle: Text("Color: ${pieza.nombre.contains('Puerta') ? m['colores']['vista'] : m['colores']['gabinete']}"),
                    trailing: Text("${pieza.largoBase.toStringAsFixed(0)}x${pieza.anchoBase.toStringAsFixed(0)}", 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CONFIGURACIÓN GLOBAL (BOTTOM SHEET) ---
  void _abrirConfiguracion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Configuración del Proyecto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextField(controller: _nombreProyCtrl, decoration: const InputDecoration(labelText: "Nombre del Proyecto")),
              const SizedBox(height: 10),
              _buildHerrajeField("Bisagras", _bisagraNom, _bisagraMar),
              _buildHerrajeField("Correderas", _correderaNom, _correderaMar),
              _buildHerrajeField("Jaladeras", _jaladeraNom, _jaladeraMar),
              const SizedBox(height: 10),
              _buildMaderaInput(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  setState(() {
                    nombreProyecto = _nombreProyCtrl.text;
                    herrajes['bisagras'] = {'nombre': _bisagraNom.text, 'marca': _bisagraMar.text};
                    herrajes['correderas'] = {'nombre': _correderaNom.text, 'marca': _correderaMar.text};
                    herrajes['jaladeras'] = {'nombre': _jaladeraNom.text, 'marca': _jaladeraMar.text};
                  });
                  Navigator.pop(context);
                },
                child: const Text("Confirmar Datos"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreProyecto.isEmpty ? "Proyecto" : nombreProyecto),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _abrirConfiguracion)],
      ),
      body: Column(
        children: [
          _buildResumenSuperior(),
          Expanded(
            child: modulos.isEmpty
                ? const Center(child: Text("Sin módulos agregados"))
                : ListView.builder(
                    itemCount: modulos.length,
                    itemBuilder: (context, index) {
                      final m = modulos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text("${m['nombre']} (x${m['cantidad']})"),
                          subtitle: Text("${m['medidas']['alto']}x${m['medidas']['ancho']} mm"),
                          trailing: const Icon(Icons.visibility, color: Colors.blue),
                          onTap: () => _verDespieceMueble(m, index),
                          onLongPress: () => _confirmarEliminar(index),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
              onPressed: _guardarEnFirebase,
              child: const Text("SINCRONIZAR CON FIREBASE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: melaminas.isEmpty ? null : _agregarNuevoModulo,
        backgroundColor: melaminas.isEmpty ? Colors.grey : Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- MÉTODOS DE FIREBASE Y APOYO ---
  void _guardarEnFirebase() async {
    final db = FirebaseFirestore.instance.collection('clientes').doc(widget.clienteId).collection('proyectos');
    final datos = {
      'nombre': nombreProyecto,
      'materiales': {'maderas': melaminas, 'herrajes': herrajes},
      'modulos': modulos,
      'ultimaActualizacion': FieldValue.serverTimestamp(),
    };

    try {
      if (widget.proyectoId == null) {
        await db.add(datos);
      } else {
        await db.doc(widget.proyectoId).set(datos, SetOptions(merge: true));
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
    }
  }

  void _agregarNuevoModulo() async {
    final res = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FormularioModulo(
        coloresProyecto: melaminas,
        marcaHerrajes: herrajes['bisagras']['marca'],
      ),
    );
    if (res != null) setState(() => modulos.add(res));
  }

  void _confirmarEliminar(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Módulo"),
        content: const Text("¿Estás seguro de quitar este mueble?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(onPressed: () { setState(() => modulos.removeAt(index)); Navigator.pop(context); }, child: const Text("Eliminar", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildResumenSuperior() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16), color: Colors.blueGrey.shade50,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Cliente: ${widget.nombreClienteDefault}", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("Materiales: ${melaminas.join(', ')}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
      ]),
    );
  }

  Widget _buildHerrajeField(String t, TextEditingController n, TextEditingController m) {
    return Row(children: [
      Expanded(child: TextField(controller: n, decoration: InputDecoration(labelText: "$t Nombre"))),
      const SizedBox(width: 10),
      Expanded(child: TextField(controller: m, decoration: const InputDecoration(labelText: "Marca"))),
    ]);
  }

  Widget _buildMaderaInput() {
    return Row(children: [
      Expanded(child: TextField(controller: _nuevaMaderaCtrl, decoration: const InputDecoration(labelText: "Agregar Madera"))),
      IconButton(icon: const Icon(Icons.add_circle), onPressed: () {
        if (_nuevaMaderaCtrl.text.isNotEmpty) {
          setState(() => melaminas.add(_nuevaMaderaCtrl.text));
          _nuevaMaderaCtrl.clear();
        }
      })
    ]);
  }
}