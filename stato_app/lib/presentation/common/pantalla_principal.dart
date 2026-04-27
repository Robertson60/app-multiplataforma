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

  final List<Widget> _pantallas = [
    //Pantallas de inicio 
    const PantallaProceso(),
    const PantallaListaClientes(rolUsuario: 'admin'),
    const PantallaInventario(rolUsuario: 'admin'),
    const PantallaAjustes(rolUsuario: 'admin'),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _pantallas[_indiceActual], 
      
      // La barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        selectedItemColor: Colors.blueGrey, // Color cuando está activa
        unselectedItemColor: Colors.grey,   // Color cuando está inactiva
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Procesos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_special),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}