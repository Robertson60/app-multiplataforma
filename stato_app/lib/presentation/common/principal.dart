import 'package:flutter/material.dart';
import '../shared.dart';
import '../../shared/shared.dart';

class PantallaPrincipal extends StatelessWidget{
  final String rolUsuario;
  const PantallaPrincipal({super.key, required this.rolUsuario});

  
  //Variables


  //Funciones


  //Pantalla
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.trabajando) ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    //Menu de opciones
                    Row(
                      children: [
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) =>  PantallaListaClientes(rolUsuario: rolUsuario)),
                                );
                            },
                            child: const Text('Proyectos')
                          )
                        ),

                        const SizedBox(width: 10,),

                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const ProcessScreen()),
                                );
                              },
                          child: const Text('Procesos')
                          )
                        )
                      ]
                    ),

                  ] 
                ),
              ),
              Expanded(
                flex:  3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Calendario y Titulo
                    const Text('------',
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                      ),
                    ),
                    
                  ]
                ),
              ),
            ]    
          )
        ),
      )

    );

  }
  }
