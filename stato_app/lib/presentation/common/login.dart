import 'package:flutter/material.dart';
import 'package:stato_app/presentation/common/cotizador.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  // 1. Controladores para "escuchar" lo que el usuario escribe
  final _usuario = TextEditingController();
  final _password = TextEditingController();

  bool _viewPassword = false;

  //Funcion para mostrar u ocultar la contraseña
  void _togglePasswordView() {
    setState(() {
      _viewPassword = !_viewPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Título
              const Text(
                "proyecto",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
        
              const SizedBox(height: 50),

              //Caja de Usuario
              SizedBox(
                width: 350, 
                child: TextField(
                  controller: _usuario,
                  decoration: const InputDecoration(
                    labelText: "Usuario",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(), 
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //Caja de Contraseña
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _password,
                  obscureText: !_viewPassword, // Oculta el texto
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_viewPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: _togglePasswordView,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              //Botón de Entrar
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Validador de usuario y contraseña

                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaCalculador()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("INICIAR SESIÓN"),
                ),
              ),

              const SizedBox(height: 20),

              // Imagen Decorativa
              SizedBox(
                width: 400,
                height: 200,
                child: Image.asset('assets/images/login_image.jpeg'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usuario.dispose();
    _password.dispose();
    super.dispose();
  }
}
