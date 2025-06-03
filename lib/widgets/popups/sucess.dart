import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;
  const SuccessPopup({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(Icons.check_circle, color: Colors.green, size: 48),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
