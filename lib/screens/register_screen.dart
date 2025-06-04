import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/forms/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: const Alignment(0, -0.5),
        height: double.infinity,
        color: const Color.fromARGB(30, 231, 204, 166),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/leeds.png',
                      height: 60,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Crie\nSua Conta',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dynaPuff(
                        color: const Color.fromARGB(255, 113, 23, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
