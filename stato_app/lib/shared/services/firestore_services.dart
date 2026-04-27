import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Modifica tu función para que sea así:
  Future<void> agregarModulo(String clienteId, String proyectoId, Map<String, dynamic> datosModulo) async {
    try {
      await _db
          .collection('clientes')
          .doc(clienteId)
          .collection('proyectos')
          .doc(proyectoId)
          .collection('modulos')
          .add(datosModulo); // .add() genera un ID automático para el mueble
    } catch (e) {
      print("Error al agregar módulo: $e");
      rethrow;
    }
  }

  // Para que el proyecto sea editable, usamos set con merge: true
  Future<void> actualizarProyecto(String clienteId, String proyectoId, Map<String, dynamic> datos) async {
    await _db
        .collection('clientes')
        .doc(clienteId)
        .collection('proyectos')
        .doc(proyectoId)
        .set(datos, SetOptions(merge: true));
  }
}