import 'dart:io';
import 'package:flutter/material.dart';
import '../models/lead_model.dart';
import '../services/lead_service.dart';

class LeadProvider extends ChangeNotifier {
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<bool> submitLead(LeadModel lead, File image) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await LeadService.submitLead(lead, image);
      if (!success) {
        _errorMessage = 'Erro ao enviar lead';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao enviar lead: $e';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
