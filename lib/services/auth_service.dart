import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://localhost:3000/auth';

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      return false;
    } else {
      throw Exception('Falha no login (status: ${response.statusCode})');
    }
  }

  static Future<bool> register({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Falha no registro (status: ${response.statusCode})');
    }
  }
}
