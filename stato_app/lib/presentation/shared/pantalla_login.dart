import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stato_app/shared/app_constants.dart';
import '../shared_pantallas.dart';

class PantallaLogin extends StatefulWidget {
  final TipoAplicacion tipoApp;
  const PantallaLogin({super.key, required this.tipoApp});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _viewPassword = false;
  bool _estaCargando = false;

  void _togglePasswordView() {
    setState(() => _viewPassword = !_viewPassword);
  }

  Future<void> _intentarLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _mensajeError("Llena todos los datos");
      return;
    }

    setState(() => _estaCargando = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String rolRecuperado = userDoc['rol'] ?? 'taller';

        if (!mounted) return;

        
        if (widget.tipoApp == TipoAplicacion.admin && rolRecuperado != 'admin' && rolRecuperado != 'vendedor') {
          _mensajeError("Este ejecutable es exclusivo para administración.");
          await FirebaseAuth.instance.signOut();
          return;
        }
        if (widget.tipoApp == TipoAplicacion.taller && rolRecuperado != 'taller') {
          _mensajeError("Este acceso es exclusivo para operadores del taller.");
          await FirebaseAuth.instance.signOut();
          return;
        }
        if (widget.tipoApp == TipoAplicacion.instalador && rolRecuperado != 'instalador') {
          _mensajeError("Este acceso es exclusivo para instaladores en campo.");
          await FirebaseAuth.instance.signOut();
          return;
        }

        
        Widget pantallaDestino;
        if (rolRecuperado == 'admin' || rolRecuperado == 'vendedor') {
          pantallaDestino = PantallaPrincipal(rolUsuario: rolRecuperado);
        } else if (rolRecuperado == 'taller') {
          pantallaDestino = const Scaffold(body: Center(child: Text("Nueva Pantalla Taller Móvil"))); 
        } else {
          pantallaDestino = const Scaffold(body: Center(child: Text("Nueva Pantalla Instalador Móvil")));
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => pantallaDestino),
        );

      } else {
        _mensajeError("El usuario no tiene un rol asignado en la base de datos.");
        await FirebaseAuth.instance.signOut();
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
    String subTituloApp = "";
    if (widget.tipoApp == TipoAplicacion.admin) subTituloApp = " - Administración";
    if (widget.tipoApp == TipoAplicacion.taller) subTituloApp = " - Taller";
    if (widget.tipoApp == TipoAplicacion.instalador) subTituloApp = " - Instaladores";

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${AppConstants.nombreApp}$subTituloApp",
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 50),
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