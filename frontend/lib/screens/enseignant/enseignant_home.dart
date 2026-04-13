import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_screen.dart';
import 'mes_seances_screen.dart';

class EnseignantHome extends StatelessWidget {
  const EnseignantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Enseignant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: const MesSeancesScreen(),
    );
  }
}
