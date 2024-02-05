import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucolife_app/modelos/usuario.dart';

class RegistroViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(Usuario user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'nombre': user.nombre,
        'apellidos': user.apellidos,
        'email': user.email,
        'fechaNacimiento': user.fechaNacimiento,
        'nivelActividad': user.nivelActividad,
        'altura': user.altura,
        'peso': user.peso,
        'unidadComida': user.unidadComida,
        'unidad': user.unidad,
        'hiperglucemia': user.hiperglucemia,
        'hipoglucemia': user.hipoglucemia,
        'objetivo': user.objetivo,
        'password': user.password,
      });
    } catch (e) {
      print('Error al registrar usuario: $e');
      // Manejar errores aquí
    }
  }
}
