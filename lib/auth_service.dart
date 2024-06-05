import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class AuthService with ChangeNotifier {
  Future<void> register(String email, String password) async {
    final url = Uri.parse('${getServerUrl()}/register');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Registro exitoso
    } else {
      // Manejar error
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('${getServerUrl()}/login');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Login exitoso
      final responseData = json.decode(response.body);
      print(responseData['message']);
    } else {
      // Manejar error
    }
  }
}
