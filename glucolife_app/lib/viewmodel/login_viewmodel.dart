import 'package:firebase_auth/firebase_auth.dart';
import 'package:glucolife_app/modelos/usuario.dart';

class LoginViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(Usuario usuario) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.password,
      );
      return userCredential.user;
    } catch (error) {
      print('Error durante el inicio de sesión: $error');
      throw error;
    }
  }
}
