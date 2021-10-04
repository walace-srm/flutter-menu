import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:menu_core/core/exceptions/client_invalid_exception.dart';
import 'package:menu_core/core/exceptions/invalid_email_exception.dart';
import 'package:menu_core/core/exceptions/password_invalid_exception.dart';
import 'package:menu_core/core/exceptions/user_not_found_exception.dart';
import 'package:menu_core/core/model/UserModel.dart';

class SignInController {
  String _email = '';
  String _senha = '';
  bool _isLoading = false;

  final _firebaseAuth = FirebaseAuth.instance;
  final _usuariosRef = FirebaseFirestore.instance.collection('usuarios');

  void setEmail(String email) => _email = email;
  void setSenha(String senha) => _senha = senha;
  void setIsLoading(bool isLoading) => _isLoading = isLoading;

  bool get isLoading => _isLoading;

  Future<UserModel> fazLogin() async {
    try {
      final userFireAuth = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email,
        password: _senha,
      );
      final userFirestore = await _usuariosRef.doc(userFireAuth.user.uid).get();
      final user =
          UserModel.fromJson(userFirestore.id, userFirestore.data());
      if (user.tipo != 'CLIENTE') {
        throw ClientInvalidException();
      }
      return user;
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw UserNotFoundException();
        } else if (e.code == 'wrong-password') {
          throw PasswordInvalidException();
        } else if (e.code == 'invalid-email') {
          throw InvalidEmailException();
        }
      } else {
        rethrow;
      }
    }
    return null;
  }
}
