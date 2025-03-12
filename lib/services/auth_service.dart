import 'dart:convert';

import 'package:aaelectroz_fe/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  String baseUrl = 'http://127.0.0.1:8000/api';

 Future<UserModel> register({
    required String? name,
    required String? username,
    required String? email,
    required String? password,
  }) async {
    var url = '$baseUrl/register';

    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];

      return user;
    } else {
      throw Exception('Gagal Register');
    }
  }

  Future<UserModel> login({
    required String? email,
    required String? password,
  }) async {
    var url = '$baseUrl/login';

    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      var token = user.token = 'Bearer ' + data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email!);
      prefs.setString('password', password!);
      prefs.setString('token', token);

      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }

  Future<UserModel> editProfile({
    required String name,
    required String username,
    required String email,
    required String token,
  }) async {
    var url = '$baseUrl/user';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      user.token = token;

      return user;
    } else {
      throw Exception('Gagal Update Profil');
    }
  }

  Future<bool> logout(String token) async {
    var url = '$baseUrl/logout';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final removeEmail = prefs.remove('email');
      final removePassword = prefs.remove('password');
      final removeToken = prefs.remove('token');
      return true;
    } else {
      throw Exception('Gagal Logout');
    }
  }
}
