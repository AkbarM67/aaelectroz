import 'package:flutter/material.dart';
import 'package:aaelectroz_fe/models/user_model.dart';
import 'package:aaelectroz_fe/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;

  AuthProvider({required this.authService});

  late UserModel _user;
  UserModel get user => _user;

  Future<bool> register({
    required String? name,
    required String? username,
    required String? email,
    required String? password,
  }) async {
    try {
      UserModel user = await authService.register(
        name: name,
        username: username,
        email: email,
        password: password,
      );
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
    required String? email,
    required String? password,
  }) async {
    try {
      UserModel user = await authService.login(
        email: email,
        password: password,
      );
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout(String token) async {
    try {
      return await authService.logout(token);
    } catch (e) {
      print(e);
      return false;
    }
  }

  editProfile({required String name, required String username, required String email, required String token}) {}
}
