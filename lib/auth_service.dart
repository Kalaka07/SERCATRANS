import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Future<void> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/register'),
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
    final response = await http.post(
      Uri.parse('http://localhost:8080/login'),
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
