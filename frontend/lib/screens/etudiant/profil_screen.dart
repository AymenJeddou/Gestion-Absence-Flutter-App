import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late Future<Map<String, dynamic>> _futureProfil;

  @override
  void initState() {
    super.initState();
    _futureProfil = _loadProfil();
  }

  Future<Map<String, dynamic>> _loadProfil() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    return await ApiService.getProfilEtudiant(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureProfil,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final result = snapshot.data!;
        if (result['success'] != 1) {
          return const Center(child: Text('Profil introuvable'));
        }

        final profil = result['data'];

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar avec initiales
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        '${profil['nom'][0]}${profil['prenom'][0]}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nom complet
                    Text(
                      '${profil['nom']} ${profil['prenom']}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    // Email
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.email_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(profil['email']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Classe
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.class_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text('Classe : ${profil['classe']}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
