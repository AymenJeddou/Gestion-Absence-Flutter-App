import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../models/absence.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  late Future<List<Absence>> _futureAbsences;

  @override
  void initState() {
    super.initState();
    _futureAbsences = _loadAbsences();
  }

  Future<List<Absence>> _loadAbsences() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    final data = await ApiService.getAbsencesEtudiant(userId);
    return data.map<Absence>((json) => Absence.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Absence>>(
      future: _futureAbsences,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final absences = snapshot.data ?? [];

        if (absences.isEmpty) {
          return const Center(child: Text('Aucune absence enregistrée'));
        }
        final totalAbsent =
            absences.where((a) => a.statut == 'absent').length;

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: totalAbsent > 0
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              child: Text(
                'Total absences : $totalAbsent / ${absences.length} séances',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: totalAbsent > 0 ? Colors.red.shade700 : Colors.green.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: absences.length,
                itemBuilder: (context, index) {
                  final a = absences[index];
                  final isAbsent = a.statut == 'absent';

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        isAbsent ? Icons.cancel : Icons.check_circle,
                        color: isAbsent ? Colors.red : Colors.green,
                        size: 32,
                      ),
                      title: Text(a.matiere),
                      subtitle: Text(
                        '${a.dateSeance} | ${a.heureDebut} - ${a.heureFin}',
                      ),
                      trailing: Chip(
                        label: Text(
                          isAbsent ? 'Absent' : 'Présent',
                          style: TextStyle(
                            color: isAbsent ? Colors.red.shade700 : Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: isAbsent
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        side: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
