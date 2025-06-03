import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/lead_model.dart';
import '../../services/lead_service.dart';
import 'package:image_picker/image_picker.dart';

class PutLeadPopup extends StatefulWidget {
  final LeadModel lead;
  const PutLeadPopup({super.key, required this.lead});

  @override
  State<PutLeadPopup> createState() => _PutLeadPopupState();
}

class _PutLeadPopupState extends State<PutLeadPopup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lead.name);
    _emailController = TextEditingController(text: widget.lead.email);
    _phoneController = TextEditingController(text: widget.lead.phone);
  }

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
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final updatedLead = LeadModel(
      id: widget.lead.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      imageUrl: widget.lead.imageUrl,
    );
    final success =
        await LeadService.updateLead(widget.lead.id!, updatedLead, _image);
    setState(() => _loading = false);
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Lead'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o e-mail';
                  if (!v.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o telefone' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Imagem'),
                  ),
                  const SizedBox(width: 12),
                  if (_image != null)
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                  else if (widget.lead.imageUrl != null)
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.network(widget.lead.imageUrl!,
                          fit: BoxFit.cover),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
