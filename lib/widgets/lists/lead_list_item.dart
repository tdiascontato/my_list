import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lead_model.dart';
import '../../services/lead_service.dart';
import '../popups/put_lead.dart';

class LeadListItem extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback? onChanged;
  const LeadListItem({super.key, required this.lead, this.onChanged});

  Future<void> _editLead(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => PutLeadPopup(lead: lead),
    );
    if (result == true && onChanged != null) {
      onChanged!();
    }
  }

  Future<void> _deleteLead(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Lead'),
        content: const Text('Tem certeza que deseja excluir este lead?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await LeadService.deleteLead(lead.id!);
      if (onChanged != null) onChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: ListTile(
        leading: lead.imageUrl != null
            ? CircleAvatar(backgroundImage: NetworkImage(lead.imageUrl!))
            : const CircleAvatar(child: Icon(Icons.person)),
        title: Text(
          lead.name,
          style: GoogleFonts.dynaPuff(color: const Color.fromARGB(255, 255, 115, 0) ,fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lead.email, style: GoogleFonts.dynaPuff(color: const Color.fromARGB(255, 255, 115, 0) ,)),
            Text(lead.phone, style: GoogleFonts.dynaPuff(color: const Color.fromARGB(255, 255, 115, 0) ,)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Editar',
              onPressed: () => _editLead(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Excluir',
              onPressed: () => _deleteLead(context),
            ),
          ],
        ),
      ),
    );
  }
}
