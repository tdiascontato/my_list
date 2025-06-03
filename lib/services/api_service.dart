import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class APIService {
  static const String _baseUrl = 'https://randomuser.me/api/?results=10';

  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] as List<dynamic>;

      return results
          .map((jsonUser) => UserModel.fromJson(jsonUser as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao carregar usuários (status: ${response.statusCode})');
    }
  }
}
