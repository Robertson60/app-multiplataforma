//Importamos las librerias necesarias
import 'package:flutter/material.dart';           //Libreria para el GUI de flutter
import 'package:stato_app/shared/shared.dart';    //Libreria con el paquete de archivos 


//Pantalla principal del cotizador 
class PantallaCalculador extends StatefulWidget {
  const PantallaCalculador({super.key});

  @override
  State<PantallaCalculador> createState() => _PantallaCalculadorState();
}
//Clase que maneja el estado de la pantalla del cotizador
class _PantallaCalculadorState extends State<PantallaCalculador> {

  //Controladores de texto obtienen el valor de los campos de texto
  final _nombre    = TextEditingController(text: "Gabinete");               //Ya vienen un texto preescrito (se puede borrar)     
  final _alto      = TextEditingController();
  final _ancho     = TextEditingController();
  final _fondo     = TextEditingController();
  final _matHuacal = TextEditingController();
  final _matVista  = TextEditingController();
  final _nombreBisagra  = TextEditingController(text: "Bisagra");            
  final _nombreJaladera = TextEditingController(text: "Jaladera Metálica");

  //Configuracion de puertas
  //Variables que guardan si lleva puerta y los enums de la cantidad de puerta y tipo de jaladera
  bool _tienePuerta         = true;
  CantidadPuertas _cantidad = CantidadPuertas.dos;
  TipoJaladera _jaladera    = TipoJaladera.fisica;

  //Variable que guarda todo el despiece del Huacal
  Huacal? _resultado;

  //Funcion principal encargada de calcular el despiece
  void _calcular() {

    //Obtener las medidas del usuario y convertirlas a double, si no se pueden convertir se regresa null
    final alto  = double.tryParse(_alto.text);
    final ancho = double.tryParse(_ancho.text);
    final fondo = double.tryParse(_fondo.text);

    //Validar que las medidas sean correctas si no no hace nada
    if (alto == null || ancho == null || fondo == null) return;

    //Se llama a setState para que se redibuje la pantalla con el nuevo resultado
    setState(() {
      //Se llama a la funcion del calculardor huacal
      _resultado = CalculadorGabinete.fabricarHuacal(
        nombre: _nombre.text,
        alto: alto, ancho: ancho, fondo: fondo,                 //Medidas del huacal
        materialHuacal: ConfiguracionMaterial(terminado: _matHuacal.text.isEmpty ? "Huacal" : _matHuacal.text),   //Material del huacal
        materialVista:  ConfiguracionMaterial(terminado: _matVista.text.isEmpty  ? "Vista"  : _matVista.text),    //Material de Frente
        //Si tiene puertas se crea la configuracion de puerta, si no se deja en null
        configPuerta:    _tienePuerta ? ConfiguracionPuerta(
          cantidad:      _cantidad,
          jaladera:      _jaladera,
          nombreBisagra: _nombreBisagra.text,
          nombreJaladera: _nombreJaladera.text,
        ) : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculador de Huacal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            //Campos de texto para medidas, organizados en una fila con un espacio entre ellos
            Row(children: [
              _campoMedida("Nombre", _nombre),
              const SizedBox(width: 8),
              _campoMedida("Alto",  _alto),
              const SizedBox(width: 8),
              _campoMedida("Ancho", _ancho),
              const SizedBox(width: 8),
              _campoMedida("Fondo", _fondo),
            ]),
            const SizedBox(height: 8),

            //Campos de texto para materiales
            TextField(controller: _matHuacal, decoration: const InputDecoration(labelText: "Acabado Huacal")),
            const SizedBox(height: 8),
            TextField(controller: _matVista,  decoration: const InputDecoration(labelText: "Acabado Frente")),
            const SizedBox(height: 8),

            //Configuracion de puertas
            Row(children: [
              Checkbox(value: _tienePuerta, onChanged: (v) => setState(() => _tienePuerta = v!)),
              const Text("Tiene puerta"),
            ]),

            if (_tienePuerta) ...[
              //Cantidad de puertas
              Row(children: [
                const Text("Cantidad: "),
                const SizedBox(width: 8),
                DropdownButton<CantidadPuertas>(
                  value: _cantidad,
                  items: CantidadPuertas.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() => _cantidad = v!),
                ),
              ]),
              Row(children: [
                const Text("Jaladera: "),
                const SizedBox(width: 8),
                DropdownButton<TipoJaladera>(
                  value: _jaladera,
                  items: TipoJaladera.values.map((j) => DropdownMenuItem(value: j, child: Text(j.name))).toList(),
                  onChanged: (v) => setState(() => _jaladera = v!),
                ),
              ]),
              Row(children: [
                Expanded(child: TextField(controller: _nombreBisagra,  decoration: const InputDecoration(labelText: "Nombre bisagra"))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _nombreJaladera, decoration: const InputDecoration(labelText: "Nombre jaladera"))),
              ]),
            ],

            const SizedBox(height: 16),

            //Boton calcular
            ElevatedButton(onPressed: _calcular, child: const Text("Calcular")),
            const SizedBox(height: 16),

            //Resultados
            if (_resultado != null) Expanded(child: _ResultadoHuacal(huacal: _resultado!)),
          ],
        ),
      ),
    );
  }

  //Widget auxiliar para campos de medida
  Widget _campoMedida(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "$label (mm)"),
      ),
    );
  }

  @override
  void dispose() {
    _alto.dispose(); _ancho.dispose(); _fondo.dispose();
    _matHuacal.dispose(); _matVista.dispose();
    _nombreBisagra.dispose(); _nombreJaladera.dispose();
    super.dispose();
  }
}

//Widget que muestra el resultado del huacal
class _ResultadoHuacal extends StatelessWidget {
  final Huacal huacal;
  const _ResultadoHuacal({required this.huacal});

  @override
  Widget build(BuildContext context) {
    //Calcular metros de canto agrupados por nombre y grosor
    final Map<String, double> metrosPorCanto = {};
    for (var p in huacal.piezas) {
      if (p.canto05Vista  != null) { final key = '${p.canto05Vista!.nombre} 0.5mm';  metrosPorCanto[key] = (metrosPorCanto[key] ?? 0) + p.metrosCanto05Vista; }
      if (p.canto05Huacal != null) { final key = '${p.canto05Huacal!.nombre} 0.5mm'; metrosPorCanto[key] = (metrosPorCanto[key] ?? 0) + p.metrosCanto05Huacal; }
      if (p.canto10       != null) { final key = '${p.canto10!.nombre} 1mm';         metrosPorCanto[key] = (metrosPorCanto[key] ?? 0) + p.metrosCanto10; }
    }

    return ListView(
      children: [

        //Piezas de corte divididas por material
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Columna material huacal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Huacal", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // Mapeo de las piezas filtradas
                  ...huacal.piezas.where((p) => !p.nombre.startsWith('Puerta')).map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),

                    child: Row( 
                      children: [
                        // Columna 1: Cantidad
                        SizedBox(
                          width: 30, // Ancho fijo para que todos los números se alineen
                          child: Text("${p.cantidad}x", style: const TextStyle(fontSize: 13)),
                        ),
                        
                        // Columna 2: Nombre (Flexible para que use el espacio restante)
                        Expanded(
                          child: Text(p.nombre, style: const TextStyle(fontSize: 13)),
                        ),
                        
                        // Columna 3: Medidas
                        Text(
                          "${p.largo.toStringAsFixed(1)} x ${p.ancho.toStringAsFixed(1)}", 
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(width: 1, child: ColoredBox(color: Colors.grey)),
            const SizedBox(width: 8),

            //Columna material vista
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Vista", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // Mapeo de las piezas filtradas
                  ...huacal.piezas.where((p) => p.nombre.startsWith('Puerta')).map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row( // <-- Cambiamos Column por Row para crear las "celdas"
                      children: [
                        // Columna 1: Cantidad
                        SizedBox(
                          width: 30, // Ancho fijo para que todos los números se alineen
                          child: Text("${p.cantidad}x", style: const TextStyle(fontSize: 13)),
                        ),
                        
                        // Columna 2: Nombre (Flexible para que use el espacio restante)
                        Expanded(
                          child: Text(p.nombre, style: const TextStyle(fontSize: 13)),
                        ),
                        
                        // Columna 3: Medidas
                        Text(
                          "${p.largo.toStringAsFixed(1)} x ${p.ancho.toStringAsFixed(1)}", 
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),

        const Divider(),

        //Cantos
        const Text("Cantos", style: TextStyle(fontWeight: FontWeight.bold)),
        ...metrosPorCanto.entries.map((e) => ListTile(
          dense: true,
          title: Text(e.key),
          trailing: Text("${e.value.toStringAsFixed(2)} ml"),
        )),

        const Divider(),

        //Herrajes
        const Text("Herrajes", style: TextStyle(fontWeight: FontWeight.bold)),
        ...huacal.herrajes.map((h) => ListTile(
          dense: true,
          title: Text(h.nombre),
          trailing: Text("${h.cantidad}x"),
        )),
      ],
    );
  }
}
