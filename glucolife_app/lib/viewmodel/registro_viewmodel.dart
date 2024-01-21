import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/modelos/usuario.dart';

class RegistroViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarUsuario(Usuario usuario) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.password,
      );

      // Guarda el usuario en Firestore
      await _saveUserToFirestore(usuario, userCredential.user!.uid);
    } catch (error) {
      print('Error durante el registro: $error');
      throw error;
    }
  }

  Future<void> _saveUserToFirestore(Usuario usuario, String userId) async {
    try {
      await _firestore.collection('usuarios').doc(userId).set(usuario.toMap());
      print('Usuario guardado en Firestore');
    } catch (error) {
      print('Error al guardar el usuario en Firestore: $error');
      throw error;
    }
  }

  Future<Usuario?> obtenerUsuarioActual() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Obtén el documento del usuario en Firestore
        DocumentSnapshot userSnapshot =
            await _firestore.collection('usuarios').doc(user.uid).get();

        // Construye una instancia de Usuario desde el mapa
        return Usuario(
          email: userSnapshot['email'],
          nombre: userSnapshot['nombre'],
          apellidos: userSnapshot['apellidos'],
          password: '',
        );
      }
    } catch (error) {
      print('Error al obtener el usuario: $error');
      throw error;
    }
  }
}
