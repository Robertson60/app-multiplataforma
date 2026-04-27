import 'package:flutter/material.dart';

import 'pantalla_cotizador.dart';
import 'pantalla_proceso.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  
  int _indiceActual = 0;

  final List<Widget> _pantallas = [
    //Pantallas de inicio 
    const PantallaCotizador(),  
    const ProcessScreen(), 
    
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
            label: 'Cotizador',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_special),
            label: 'Proyectos',
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