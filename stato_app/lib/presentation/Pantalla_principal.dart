import 'package:flutter/material.dart';
import 'package:stato_app/presentation/shared_pantallas.dart';

class PantallaPrincipal extends StatefulWidget {
  final String rolUsuario;
  const PantallaPrincipal({super.key, required this.rolUsuario});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  @override
  Widget build(BuildContext context) {
    // 1. Detectamos si la aplicación se abrió en una pantalla grande (Escritorio/Web)
    final bool esEscritorio = MediaQuery.of(context).size.width > 600;

    // 2. Filtro de Seguridad: Bloqueo para Taller e Instalador si entran en Windows/Web
    if (esEscritorio && (widget.rolUsuario == 'taller' || widget.rolUsuario == 'instalador')) {
      return const _PantallaAccesoRestringido();
    }

    // 3. Renderizado de vistas según el rol del usuario
    switch (widget.rolUsuario) {
      case 'admin':
      case 'vendedor':
        return _construirMenuAdministrativo(esEscritorio);
        
      case 'taller':
        return _construirMenuTallerMobile();
        
      case 'instalador':
        return _construirMenuInstaladorMobile();
        
      default:
        return const Scaffold(
          body: Center(child: Text("Rol no reconocido")),
        );
    }
  }

  // --- VISTA 1: ADMINISTRATIVO / GERENTE (ESCRITORIO & MÓVIL) ---
  Widget _construirMenuAdministrativo(bool esEscritorio) {
    // Mantenemos tu lista original de pantallas compartidas
    final List<Widget> pantallasAdmin = [
      const PantallaProceso(),
      PantallaListaClientes(rolUsuario: widget.rolUsuario),
      PantallaInventario(rolUsuario: widget.rolUsuario),
      PantallaAjustes(rolUsuario: widget.rolUsuario),
    ];

    if (esEscritorio) {
      // Si está en Windows o Web, usamos un menú lateral para aprovechar el ancho
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _indiceActual,
              onDestinationSelected: (index) => setState(() => _indiceActual = index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: Colors.blueGrey),
              selectedLabelTextStyle: const TextStyle(color: Colors.blueGrey),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.calculate), label: Text('Procesos')),
                NavigationRailDestination(icon: Icon(Icons.folder_special), label: Text('Clientes')),
                NavigationRailDestination(icon: Icon(Icons.inventory_2), label: Text('Inventario')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Perfil')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: pantallasAdmin[_indiceActual]),
          ],
        ),
      );
    } else {
      // Si el administrador abre la app desde su celular, conserva tu barra inferior original
      return Scaffold(
        body: pantallasAdmin[_indiceActual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceActual,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _indiceActual = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Procesos'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_special), label: 'Clientes'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventario'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      );
    }
  }

  // --- VISTA 2: OPERADOR DE TALLER (SOLO MÓVIL) ---
  Widget _construirMenuTallerMobile() {
    // Aquí puedes definir pestañas específicas para la producción interna
    // (Ej: Lista de cortes asignados, Reporte de errores rápidos, Ajustes del perfil)
    return Scaffold(
      appBar: AppBar(title: const Text("Panel de Producción - Stato")),
      body: const Center(
        child: Text("Pantalla de Taller: Lista de proyectos filtrados por sub-rol (área de trabajo)"),
      ),
    );
  }

  // --- VISTA 3: INSTALADOR EN CAMPO (SOLO MÓVIL) ---
  Widget _construirMenuInstaladorMobile() {
    // Interfaz súper simplificada para campo
    // (Ej: Agenda del día, Carga de fotos de evidencia)
    return Scaffold(
      appBar: AppBar(title: const Text("Ruta de Instalación")),
      body: const Center(
        child: Text("Pantalla de Instalador: Proyectos del día, mapa y cámara para subir evidencias"),
      ),
    );
  }
}

// --- WIDGET AUXILIAR: PANTALLA ROJA DE BLOQUEO ---
class _PantallaAccesoRestringido extends StatelessWidget {
  const _PantallaAccesoRestringido();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phonelink_lock, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                "Acceso Restringido",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                "Tu cuenta operativa está configurada exclusivamente para su uso en dispositivos móviles.",
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                onPressed: () {
                  // Regresa al login limpiando la sesión
                  Navigator.pushReplacementNamed(context, '/'); 
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("REGRESAR AL LOGIN"),
              )
            ],
          ),
        ),
      ),
    );
  }
}