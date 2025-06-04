import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_list/models/lead_model.dart';
import 'package:my_list/widgets/forms/lead_form.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../services/lead_service.dart';
import '../models/user_model.dart';
import '../widgets/lists/user_list_item.dart';
import '../widgets/lists/lead_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<UserModel>> _usersFuture;
  late Future<List<LeadModel>> _leadsFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = APIService.fetchUsers();
    _leadsFuture = LeadService.fetchLeads();
  }

  void _logout() {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userEmail = authProvider.loggedInUserEmail ?? 'Usuário';
    final userEmailPrefix = userEmail.split('@').first;

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(30, 231, 204, 166),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _usersFuture = APIService.fetchUsers();
              _leadsFuture = LeadService.fetchLeads();
            });
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsetsDirectional.only(start: 16, bottom: 12),
                  title: Text(
                    'Bem‐vindo, $userEmailPrefix',
                    style: GoogleFonts.dynaPuff(
                      color: const Color.fromARGB(255, 211, 74, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout,
                        color: Colors.black),
                    tooltip: 'Logout',
                    onPressed: _logout,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: DefaultTextStyle(
                    style: GoogleFonts.dynaPuff(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    child: Column(
                      children: [
                        // LEAD FORM
                        LeadForm(
                          onLeadSubmitted: () {
                            setState(() {
                              _leadsFuture = LeadService.fetchLeads();
                            });
                          },
                        ),
                        // LISTA DE LEADS
                        FutureBuilder<List<LeadModel>>(
                          future: _leadsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Erro ao carregar leads:\n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dynaPuff(color: Colors.red),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(child: Text('Nenhum lead cadastrado.'));
                            } else {
                              final leads = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: leads.length,
                                itemBuilder: (context, index) {
                                  return LeadListItem(
                                    lead: leads[index],
                                    onChanged: () {
                                      setState(() {
                                        _leadsFuture = LeadService.fetchLeads();
                                      });
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                        // USUÁRIOS RANDOMUSER
                        FutureBuilder<List<UserModel>>(
                          future: _usersFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Erro ao carregar usuários:\n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dynaPuff(color: Colors.red),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(child: Text('Nenhum usuário encontrado.'));
                            } else {
                              final users = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return UserListItem(user: users[index]);
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
