import 'package:flutter/material.dart';

class FormularioModulo extends StatefulWidget {
  final List<String> coloresProyecto;
  final String marcaHerrajes;
  final Map<String, dynamic>? datosEdicion;

  const FormularioModulo({
    super.key,
    required this.coloresProyecto,
    required this.marcaHerrajes,
    this.datosEdicion,
  });

  @override
  State<FormularioModulo> createState() => _FormularioModuloState();
}

class _FormularioModuloState extends State<FormularioModulo> {
  // Controladores de texto
  final _nombreCtrl = TextEditingController();
  final _altoCtrl = TextEditingController();
  final _anchoCtrl = TextEditingController();
  final _fondoCtrl = TextEditingController();
  final _cantCtrl = TextEditingController(text: "1");

  // Variables de selección
  String? colorGabinete;
  String? colorVista;
  int cantPuertas = 0;

  @override
  void initState() {
    super.initState();
    
    // 1. Cargar datos si estamos editando
    if (widget.datosEdicion != null) {
      final d = widget.datosEdicion!;
      _nombreCtrl.text = d['nombre']?.toString() ?? "";
      _altoCtrl.text = d['medidas']['alto']?.toString() ?? "";
      _anchoCtrl.text = d['medidas']['ancho']?.toString() ?? "";
      _fondoCtrl.text = d['medidas']['fondo']?.toString() ?? "";
      _cantCtrl.text = d['cantidad']?.toString() ?? "1";
      
      colorGabinete = d['colores']['gabinete'];
      colorVista = d['colores']['vista'];
      cantPuertas = d['puertas']['cantidad'] ?? 0;
    } else {
      // 2. Valores por defecto si es nuevo
      if (widget.coloresProyecto.isNotEmpty) {
        colorGabinete = widget.coloresProyecto.first;
        colorVista = widget.coloresProyecto.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ajuste para que el teclado no tape el formulario
      padding: EdgeInsets.only(
        top: 20, left: 20, right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.datosEdicion == null ? "Nuevo Módulo" : "Editar Módulo",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            
            TextField(
              controller: _nombreCtrl, 
              decoration: const InputDecoration(labelText: "Nombre (Ej: Gabinete Superior)"),
            ),
            
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _altoCtrl, decoration: const InputDecoration(labelText: "Alto mm"), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _anchoCtrl, decoration: const InputDecoration(labelText: "Ancho mm"), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _fondoCtrl, decoration: const InputDecoration(labelText: "Fondo mm"), keyboardType: TextInputType.number)),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Configuración de Colores", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              initialValue: colorGabinete,
              decoration: const InputDecoration(labelText: "Color del Cuerpo (Gabinete)"),
              items: widget.coloresProyecto.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => colorGabinete = val),
            ),
            DropdownButtonFormField<String>(
              initialValue: colorVista,
              decoration: const InputDecoration(labelText: "Color de Vistas / Puertas"),
              items: widget.coloresProyecto.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => colorVista = val),
            ),

            const SizedBox(height: 20),
            const Text("Puertas", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
              for (var n in[]) 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text("$n puertas"),
                    selected: cantPuertas == n,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => cantPuertas = n);
                      }
                    },
                  ),
                ),
            ],
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                // ESTRUCTURA DEL MAP RETORNADO (Debe coincidir con proyecto.dart)
                Navigator.pop(context, {
                  'nombre': _nombreCtrl.text,
                  'cantidad': int.tryParse(_cantCtrl.text) ?? 1,
                  'medidas': {
                    'alto': double.tryParse(_altoCtrl.text) ?? 0.0,
                    'ancho': double.tryParse(_anchoCtrl.text) ?? 0.0,
                    'fondo': double.tryParse(_fondoCtrl.text) ?? 0.0,
                  },
                  'colores': {
                    'gabinete': colorGabinete,
                    'vista': colorVista,
                  },
                  'puertas': {
                    'cantidad': cantPuertas,
                  },
                });
              },
              child: Text(
                widget.datosEdicion == null ? "AGREGAR MÓDULO" : "GUARDAR CAMBIOS",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _altoCtrl.dispose();
    _anchoCtrl.dispose();
    _fondoCtrl.dispose();
    _cantCtrl.dispose();
    super.dispose();
  }
}