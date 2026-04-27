import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared.dart';

//import 'pantalla_principal.dart';


class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  // Controladores originales
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _viewPassword = false;
  bool _estaCargando = false;

  void _togglePasswordView() {
    setState(() {
      _viewPassword = !_viewPassword;
    });
  }

  // --- LÓGICA DE ACCESO CON ROLES ---
  Future<void> _intentarLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _mensajeError("Por favor, llena todos los campos");
      return;
    }

    setState(() => _estaCargando = true);

    try {
      // 1. Autenticación en Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Obtener el ROL desde Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        // Extraemos el rol (admin, vendedor, taller, instalador)
        String rolRecuperado = userDoc['rol'] ?? 'taller';

        if (mounted) {
          // 3. Navegar a la lista de clientes pasando el rol
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaPrincipal(rolUsuario: rolRecuperado),
              //builder: (context) => PantallaPrincipal(),
            ),
          );
        }
      } else {
        _mensajeError("El usuario no tiene un rol asignado en la base de datos.");
        await FirebaseAuth.instance.signOut(); // Cerramos sesión por seguridad
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = "Error al entrar";
      if (e.code == 'user-not-found') errorMsg = "Correo no registrado";
      if (e.code == 'wrong-password') errorMsg = "Contraseña incorrecta";
      if (e.code == 'invalid-email') errorMsg = "Correo con formato inválido";
      _mensajeError(errorMsg);
    } catch (e) {
      _mensajeError("Ocurrió un error inesperado");
    } finally {
      if (mounted) setState(() => _estaCargando = false);
    }
  }

  void _mensajeError(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: Colors.redAccent),
    );
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
              // Título original
              const Text(
                "Stato Cocinas",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),

              // Caja de Usuario (Email)
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo Electrónico",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Caja de Contraseña
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_viewPassword,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_viewPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: _togglePasswordView,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botón de Entrar original
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: _estaCargando ? null : _intentarLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                  child: _estaCargando 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("INICIAR SESIÓN"),
                ),
              ),
              const SizedBox(height: 20),

              // Imagen Decorativa original
              SizedBox(
                width: 400,
                height: 200,
                child: Image.asset(
                  'assets/images/login_image.jpeg',
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}