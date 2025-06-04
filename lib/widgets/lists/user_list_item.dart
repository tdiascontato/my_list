import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: const Color.fromARGB(255, 211, 74, 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.thumbnailUrl),
        ),
        title: Text(
          user.fullName,
          style: GoogleFonts.dynaPuff(color: Colors.white ,fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: GoogleFonts.dynaPuff(color: Colors.white ,)),
            const SizedBox(height: 2),
            Text(user.phone, style: GoogleFonts.dynaPuff(color: Colors.white ,)),
          ],
        ),
      ),
    );
  }
}
