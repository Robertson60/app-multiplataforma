import 'package:flutter/material.dart';
import '../shared.dart';
import '../../shared/shared.dart';

class PantallaPrincipal extends StatefulWidget{
  const PantallaPrincipal({super.key});
  
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState(); 
  
  }

class _PantallaPrincipalState extends State<PantallaPrincipal>{

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
                                MaterialPageRoute(builder: (context) => const PantallaCotizador()),
                                );
                            },
                            child: const Text('Cotizador')
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
