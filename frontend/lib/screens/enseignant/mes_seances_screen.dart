import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../models/seance.dart';
import 'appel_screen.dart';

class MesSeancesScreen extends StatefulWidget {
  const MesSeancesScreen({super.key});

  @override
  State<MesSeancesScreen> createState() => _MesSeancesScreenState();
}

class _MesSeancesScreenState extends State<MesSeancesScreen> {
  late Future<List<Seance>> _futureSeances;

  @override
  void initState() {
    super.initState();
    _futureSeances = _loadSeances();
  }

  Future<List<Seance>> _loadSeances() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    final data = await ApiService.getSeancesEnseignant(userId);
    return data.map<Seance>((json) => Seance.fromJson(json)).toList();
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Seance>>(
      future: _futureSeances,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final seances = snapshot.data ?? [];

        if (seances.isEmpty) {
          return const Center(
            child: Text('Aucune séance assignée'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: seances.length,
          itemBuilder: (context, index) {
            final s = seances[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Matière en titre
                    Text(
                      s.matiere,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // Classe
                    Text('Classe : ${s.classe}'),
                    // Date et heure
                    Text('Date : ${s.dateSeance}'),
                    Text('Horaire : ${s.heureDebut} - ${s.heureFin}'),
                    const SizedBox(height: 8),
                    // Bouton faire l'appel
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.checklist),
                        label: const Text("Faire l'appel"),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppelScreen(seance: s),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
