import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.dynaPuff(
        color: Colors.white,
        fontSize: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF5532A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Editar Lead',
        style: GoogleFonts.dynaPuff(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nome'),
                style: GoogleFonts.dynaPuff(color: Colors.white),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('E-mail'),
                style: GoogleFonts.dynaPuff(color: Colors.white),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o e-mail';
                  if (!v.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Telefone'),
                style: GoogleFonts.dynaPuff(color: Colors.white),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o telefone' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFF5532A),
                      textStyle: GoogleFonts.dynaPuff(
                        color: const Color(0xFFF5532A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _loading ? null : _pickImage,
                    icon: const Icon(Icons.image, color: Color(0xFFF5532A)),
                    label: Text(
                      'Imagem',
                      style: GoogleFonts.dynaPuff(
                        color: const Color(0xFFF5532A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          child: Text(
            'Cancelar',
            style: GoogleFonts.dynaPuff(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFF5532A),
            textStyle: GoogleFonts.dynaPuff(
              color: const Color(0xFFF5532A),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'Salvar',
                  style: GoogleFonts.dynaPuff(
                    color: const Color(0xFFF5532A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
