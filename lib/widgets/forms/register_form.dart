import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _localErrorMessage;

  Future<void> _submitRegister() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _localErrorMessage = null;
    });
    provider.clearError();

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_password != _confirmPassword) {
      setState(() {
        _localErrorMessage = 'As senhas não conferem';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await provider.register(
      email: _email,
      password: _password,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.dynaPuff(
        color: const Color.fromARGB(255, 113, 23, 1),
        fontSize: 16,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 113, 23, 1)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 113, 23, 1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: _inputDecoration('E-mail'),
            style: GoogleFonts.dynaPuff(
              color: Colors.black,
              fontSize: 16,
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!.trim(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe seu e-mail';
              }
              if (!value.contains('@')) {
                return 'E-mail inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: _inputDecoration('Senha'),
            style: GoogleFonts.dynaPuff(
              color: Colors.black,
              fontSize: 16,
            ),
            obscureText: true,
            onSaved: (value) => _password = value!.trim(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe sua senha';
              }
              if (value.length < 4) {
                return 'A senha deve ter ao menos 4 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: _inputDecoration('Confirme a Senha'),
            style: GoogleFonts.dynaPuff(
              color: Colors.black,
              fontSize: 16,
            ),
            obscureText: true,
            onSaved: (value) => _confirmPassword = value!.trim(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirme sua senha';
              }
              if (value.length < 4) {
                return 'A confirmação deve ter ao menos 4 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (_localErrorMessage != null)
            Text(
              _localErrorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          if (provider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 16),
          _isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5532A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitRegister,
                    child: Text(
                      'Registrar',
                      style: GoogleFonts.dynaPuff(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(
              'Já tem conta? Faça login',
              style: GoogleFonts.dynaPuff(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}