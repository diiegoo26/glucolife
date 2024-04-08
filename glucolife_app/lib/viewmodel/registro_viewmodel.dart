import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glucolife_app/modelos/usuario.dart';

class RegistroViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser(Usuario user, String imagePath) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Subir la imagen solo si se proporciona una ruta
      if (imagePath != null) {
        Reference storageReference = _storage.ref().child('usuarios/${userCredential.user!.uid}/perfil.jpg');
        await storageReference.putFile(File(imagePath));

        // Obtener la URL de la imagen almacenada
        String imageUrl = await storageReference.getDownloadURL();

        // Agregar la URL de la imagen a los detalles del usuario
        user.imagenUrl = imageUrl;
      }

      // Guardar los detalles del usuario en la base de datos
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
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
        'imagenUrl': user.imagenUrl, // Puedes establecer esta propiedad en el constructor de Usuario
      });

      // Resto de tu lógica, como navegación, mensajes de éxito, etc.
    } catch (e) {
      print('Error al registrar usuario: $e');
      // Manejar errores aquí
    }
  }
}