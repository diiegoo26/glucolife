import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/usuario.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:glucolife_app/vistas/home/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Inicia sesión con el correo electrónico y la contraseña proporcionados.
  ///
  /// Retorna un valor booleano que indica si el inicio de sesión fue exitoso.
  ///
  /// Devuelve excepcion cuando se produce algun error con Firebase Authentication
  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeVista()));
      return true;
    } catch (e) {
      print('Error al iniciar sesión: $e');
    }
    return false;
  }

  /// Obtiene el usuario actualmente autenticado.
  ///
  /// Retorna un objeto [Usuario] si el usuario está autenticado, de lo contrario, retorna `null`.
  ///
  /// Devuelve error cuando no se puede recuperar al usuario
  Future<Usuario?> obtenerUsuarioActual() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('usuarios').doc(user.uid).get();

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
          unidadMedida: userSnapshot['unidad'],
          hipoglucemia: userSnapshot['hipoglucemia'],
          hiperglucemia: userSnapshot['hiperglucemia'],
          nivel_objetivo: userSnapshot['objetivo'],
          imagenUrl: userSnapshot['imagenUrl'],
        );
      }
    } catch (error) {
      print('Error al obtener el usuario: $error');
      throw error;
    }
  }

  /// Actualiza los datos del usuario en Firebase.
  ///
  /// [usuario]: El objeto [Usuario] con los datos actualizados.
  ///
  /// Devuelve excepcion cuando no se produce algun error al actualizar Firebase
  Future<void> actualizarUsuarioEnFirebase(Usuario usuario) async {
    try {
      User? user = _auth.currentUser;
      DocumentReference usuarioRef =
          FirebaseFirestore.instance.collection('usuarios').doc(user?.uid);

      await usuarioRef.update({
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'fechaNacimiento': usuario.fechaNacimiento,
        'altura': usuario.altura,
        'peso': usuario.peso,
        'unidadComida': usuario.unidadComida,
        'unidad': usuario.unidadMedida,
        'hiperglucemia': usuario.hiperglucemia,
        'hipoglucemia': usuario.hipoglucemia,
        'objetivo': usuario.nivel_objetivo,
        'imagenUrl': usuario.imagenUrl,
      });

      print('Usuario actualizado en Firebase');
    } catch (error) {
      print('Error al actualizar el usuario en Firebase: $error');
      throw error;
    }
  }

  /// Guarda los datos médicos del usuario en Firebase.
  ///
  /// [usuario]: El objeto [Usuario] con los datos médicos actualizados.
  ///
  /// Devuelve una excepcion cuando no se puede almacenar los datos en Firebase
  Future<void> guardarDatosMedicos(Usuario? usuario) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null && usuario != null) {
        await _firestore.collection('usuarios').doc(firebaseUser.uid).update({
          'altura': usuario.altura,
          'peso': usuario.peso,
          'hiperglucemia': usuario.hiperglucemia,
          'hipoglucemia': usuario.hipoglucemia,
          'nivelActividad': usuario.nivelActividad,
          'objetivo': usuario.nivel_objetivo,
          'unidad': usuario.unidadMedida,
          'unidadComida': usuario.unidadComida,
        });
      }
    } catch (error) {
      throw Exception('Error al guardar los cambios: $error');
    }
  }

  /// Guarda los datos personales del usuario en Firebase.
  ///
  /// [imagePath]: La ruta de la imagen de perfil.
  /// [usuario]: El objeto [Usuario] con los datos personales actualizados.
  /// [context]: El contexto de la aplicación.
  ///
  /// Devuelve una excepcion cuando no se puede almacenar los datos en Firebase
  Future<void> guardarDatosPersonales(
      String? imagePath, Usuario? usuario, BuildContext context) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null && usuario != null) {
        if (imagePath != null) {
          String storagePath = 'usuarios/${firebaseUser.uid}/perfil.jpg';
          Reference storageReference = _storage.ref().child(storagePath);
          await storageReference.putFile(File(imagePath));
          usuario.imagenUrl = await storageReference.getDownloadURL();
        }
        await _firestore.collection('usuarios').doc(firebaseUser.uid).update({
          'imagenUrl': usuario.imagenUrl,
          'nombre': usuario.nombre,
          'apellidos': usuario.apellidos,
          'fechaNacimiento': usuario.fechaNacimiento,
        });

        /// Llamada al provider para poder mantener la vista actualizada
        UsuarioProvider usuarioModel =
            Provider.of<UsuarioProvider>(context, listen: false);
        usuarioModel.actualizarUsuario(usuario);
      }
    } catch (error) {
      throw Exception('Error al guardar los datos personales: $error');
    }
  }

  /// Inicia sesión con Google.
  ///
  /// [context]: El contexto de la aplicación.
  ///
  /// Devuelve una excepcion cuando no se puede iniciar sesión mediante una cuenta Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredential.user?.displayName);

      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('usuarios');

      await usersCollection.doc(userCredential.user?.uid).set({
        "nombre": userCredential.user?.displayName,
        "email": userCredential.user?.email,
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print("Error durante el inicio de sesión con Google: $e");
    }
  }

  /// Envía un correo electrónico para restablecer la contraseña.
  ///
  /// [email]: El correo electrónico al que se enviará el enlace de restablecimiento de contraseña.
  ///
  /// Devuelve un error cuando no se puede enviar el correo correctamente
  Future<void> enviarCorreoRestablecimiento(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print('Error al enviar correo de restablecimiento: $error');
    }
  }

  /// Cierra sesión del usuario actual.
  ///
  /// Devuelve un error cuando no se puede cerrar la cuenta exitosamente
  Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }
}
