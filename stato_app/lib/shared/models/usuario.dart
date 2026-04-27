class UsuarioStato {
  final String uid;
  final String nombre;
  final String email;
  final String rol; // admin, vendedor, taller, instalador

  UsuarioStato({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  // Convierte los datos de Firebase a objeto de Flutter
  factory UsuarioStato.fromFirestore(Map<String, dynamic> data, String id) {
    return UsuarioStato(
      uid: id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      rol: data['rol'] ?? 'taller', 
    );
  }
}