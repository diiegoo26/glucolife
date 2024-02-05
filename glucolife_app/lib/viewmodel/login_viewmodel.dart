import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/vistas/home/home.dart';

class LoginViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      // Manejar errores de inicio de sesión aquí, por ejemplo, mostrar un mensaje de error.
      print('Error al iniciar sesión: $e');
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
            fechaNacimiento: DateTime(1990, 1, 1),
            nivelActividad: userSnapshot['nivelActividad'],
            altura: userSnapshot['altura'],
            peso: userSnapshot['peso'],
            unidadComida: userSnapshot['unidadComida'],
            unidad: userSnapshot['unidad'],
            hipoglucemia: userSnapshot['hipoglucemia'],
            hiperglucemia: userSnapshot['hiperglucemia'],
            objetivo: userSnapshot['objetivo']);
      }
    } catch (error) {
      print('Error al obtener el usuario: $error');
      throw error;
    }
  }

  Future<void> actualizarUsuarioEnFirebase(Usuario usuario) async {
    try {
      User? user = _auth.currentUser;
      DocumentReference usuarioRef =
          FirebaseFirestore.instance.collection('usuarios').doc(user?.uid);

      // Actualiza los datos del documento
      await usuarioRef.update({
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'fechaNacimiento': usuario.fechaNacimiento,
        'altura': usuario.altura,
        'peso': usuario.peso,
        'unidadComida': usuario.unidadComida,
        'unidad': usuario.unidad,
        'hiperglucemia': usuario.hiperglucemia,
        'hipoglucemia': usuario.hipoglucemia,
        'objetivo': usuario.objetivo,
        // Asegúrate de incluir los demás campos del usuario
      });

      print('Usuario actualizado en Firebase');
    } catch (error) {
      print('Error al actualizar el usuario en Firebase: $error');
      // Manejar el error según tus necesidades
      throw error;
    }
  }
}
