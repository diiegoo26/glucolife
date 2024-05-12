import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glucolife_app/modelos/usuario.dart';

class RegistroServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Registra un nuevo usuario en la aplicación.
  ///
  /// [usuario]: El usuario que se registrará.
  /// [imagePath]: La ruta de la imagen de perfil del usuario
  ///
  /// Devuelve una excepcion cuando no se puede almacenar el usuario en Firebase
  Future<void> registrarUsuario(Usuario usuario, String imagePath) async {
    try {
      UserCredential usuarioCredential = await _auth.createUserWithEmailAndPassword(email: usuario.email,password: usuario.password,
      );

      if (imagePath != null) {
        Reference storageReference = _storage.ref().child('usuarios/${usuarioCredential.user!.uid}/perfil.jpg');
        await storageReference.putFile(File(imagePath));

        String imageUrl = await storageReference.getDownloadURL();

        usuario.imagenUrl = imageUrl;
      }

      await _firestore.collection('usuarios').doc(usuarioCredential.user!.uid).set({
        'nombre': usuario.nombre,
        'apellidos': usuario.apellidos,
        'email': usuario.email,
        'fechaNacimiento': usuario.fechaNacimiento,
        'nivelActividad': usuario.nivelActividad,
        'altura': usuario.altura,
        'peso': usuario.peso,
        'unidadComida': usuario.unidadComida,
        'unidad': usuario.unidadMedida,
        'hiperglucemia': usuario.hiperglucemia,
        'hipoglucemia': usuario.hipoglucemia,
        'objetivo': usuario.nivel_objetivo,
        'password': usuario.password,
        'imagenUrl': usuario.imagenUrl,
      });

    } catch (e) {
      print('Error al registrar usuario: $e');
    }
  }

  /// Comprobacion del formato del correo
  ///
  /// [email] El correo del usuario
  /// Devuelve si es valido o no
  bool comprobarFormatoCorreo(String email) {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  /// Comprobacion del formato de la contraseña
  ///
  /// [pass] La contraseña del usuario
  /// Devuelve si es valido o no
  bool comprobarFormatoContrasena(String pass) {
    final RegExp passRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    return passRegExp.hasMatch(pass);
  }

}