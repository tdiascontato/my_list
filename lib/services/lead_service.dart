import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/lead_model.dart';

class LeadService {
  static Future<bool> submitLead(LeadModel lead, File image) async {
    final uri = Uri.parse('http://localhost:3000/leads');
    final request = http.MultipartRequest('POST', uri)
      ..fields.addAll(lead.toMap())
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<List<LeadModel>> fetchLeads() async {
    final uri = Uri.parse('http://localhost:3000/leads');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => LeadModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar leads');
    }
  }

  static Future<bool> updateLead(String id, LeadModel lead,
      [File? image]) async {
    final uri = Uri.parse('http://localhost:3000/leads/$id');
    var request = http.MultipartRequest('PATCH', uri)
      ..fields.addAll(lead.toMap());
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> deleteLead(String id) async {
    final uri = Uri.parse('http://localhost:3000/leads/$id');
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}
