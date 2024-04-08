import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      return true;
    } catch (e) {
      // Manejar errores de inicio de sesión aquí, por ejemplo, mostrar un mensaje de error.
      print('Error al iniciar sesión: $e');
    }
    return false;
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
          fechaNacimiento: userSnapshot['fechaNacimiento'].toDate(),
          nivelActividad: userSnapshot['nivelActividad'],
          altura: userSnapshot['altura'],
          peso: userSnapshot['peso'],
          unidadComida: userSnapshot['unidadComida'],
          unidad: userSnapshot['unidad'],
          hipoglucemia: userSnapshot['hipoglucemia'],
          hiperglucemia: userSnapshot['hiperglucemia'],
          objetivo: userSnapshot['objetivo'],
          imagenUrl: userSnapshot['imagenUrl'],
        );
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
        'imagenUrl':usuario.imagenUrl,
        // Asegúrate de incluir los demás campos del usuario
      });

      print('Usuario actualizado en Firebase');
    } catch (error) {
      print('Error al actualizar el usuario en Firebase: $error');
      // Manejar el error según tus necesidades
      throw error;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Imprimir el nombre de usuario
      print(userCredential.user?.displayName);

      // Obtener la referencia a la colección "usuarios" en Cloud Firestore
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');

      // Crear un documento en la colección con la información del usuario
      await usersCollection.doc(userCredential.user?.uid).set({
        "nombre": userCredential.user?.displayName,
        "email": userCredential.user?.email,
        // Puedes agregar más campos según la información que quieras almacenar
      });

      // Navegar a la vista "home" después del registro exitoso
      Navigator.pushReplacementNamed(context, '/home'); // Reemplaza la vista actual con la vista "home"
    } catch (e) {
      // Manejar errores de autenticación
      print("Error durante el inicio de sesión con Google: $e");
    }
  }
}