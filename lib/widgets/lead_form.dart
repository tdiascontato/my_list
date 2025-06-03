import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import 'popups/sucess.dart';

class LeadForm extends StatefulWidget {
  final VoidCallback? onLeadSubmitted;
  const LeadForm({super.key, this.onLeadSubmitted});

  @override
  State<LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _image;

  String? _localErrorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _localErrorMessage = null;
      });
    }
  }

  Future<void> _submit() async {
    final provider = Provider.of<LeadProvider>(context, listen: false);
    provider.clearError();
    setState(() {
      _localErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      setState(() {
        _localErrorMessage = 'Selecione uma imagem.';
      });
      return;
    }
    _formKey.currentState!.save();

    final lead = LeadModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    final success = await provider.submitLead(lead, _image!);

    if (success) {
      if (widget.onLeadSubmitted != null) {
        widget.onLeadSubmitted!();
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => SuccessPopup(message: 'Lead enviado com sucesso!'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeadProvider>(context);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Cadastrar Lead',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (v) => _nameController.text = v!.trim(),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _emailController.text = v!.trim(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o e-mail';
                  if (!v.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _phoneController.text = v!.trim(),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o telefone' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: provider.isSubmitting ? null : _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Selecionar Imagem'),
                  ),
                  const SizedBox(width: 12),
                  if (_image != null)
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
                ],
              ),
              if (_localErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _localErrorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (provider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: provider.isSubmitting ? null : _submit,
                child: provider.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enviar Lead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
