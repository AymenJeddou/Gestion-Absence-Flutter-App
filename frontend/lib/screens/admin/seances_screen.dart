import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class SeancesScreen extends StatefulWidget {
  const SeancesScreen({super.key});

  @override
  State<SeancesScreen> createState() => _SeancesScreenState();
}

class _SeancesScreenState extends State<SeancesScreen> {
  late Future<List<dynamic>> _futureSeances;

  @override
  void initState() {
    super.initState();
    _futureSeances = ApiService.getSeances();
  }

  void _refresh() {
    setState(() {
      _futureSeances = ApiService.getSeances();
    });
  }

  void _showAddDialog() async {
    final enseignants = await ApiService.getEnseignants();
    final classes = await ApiService.getClasses();
    final matieres = await ApiService.getMatieres();

    if (!mounted) return;

    String? selectedEnseignantId;
    String? selectedClasseId;
    String? selectedMatiereId;
    final dateCtrl = TextEditingController();
    final debutCtrl = TextEditingController();
    final finCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Affecter une séance'),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedEnseignantId,
                    decoration: const InputDecoration(labelText: 'Enseignant'),
                    items: enseignants.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        value: e['id'].toString(),
                        child: Text('${e['nom']} ${e['prenom']}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedEnseignantId = val);
                    },
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: selectedClasseId,
                    decoration: const InputDecoration(labelText: 'Classe'),
                    items: classes.map<DropdownMenuItem<String>>((c) {
                      return DropdownMenuItem(
                        value: c['id'].toString(),
                        child: Text(c['nom']),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedClasseId = val);
                    },
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: selectedMatiereId,
                    decoration: const InputDecoration(labelText: 'Matière'),
                    items: matieres.map<DropdownMenuItem<String>>((m) {
                      return DropdownMenuItem(
                        value: m['id'].toString(),
                        child: Text(m['nom']),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedMatiereId = val);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Date (AAAA-MM-JJ)',
                      hintText: '2026-04-15',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        dateCtrl.text =
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                      }
                    },
                    readOnly: true,
                  ),
                  TextField(
                    controller: debutCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Heure début (HH:MM)',
                      hintText: '08:00',
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 8, minute: 0),
                      );
                      if (time != null) {
                        debutCtrl.text =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                    readOnly: true,
                  ),
                  TextField(
                    controller: finCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Heure fin (HH:MM)',
                      hintText: '10:00',
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 10, minute: 0),
                      );
                      if (time != null) {
                        finCtrl.text =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                    readOnly: true,
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              if (selectedEnseignantId == null ||
                  selectedClasseId == null ||
                  selectedMatiereId == null ||
                  dateCtrl.text.isEmpty ||
                  debutCtrl.text.isEmpty ||
                  finCtrl.text.isEmpty) {
                return;
              }
              await ApiService.addSeance({
                'enseignant_id': int.parse(selectedEnseignantId!),
                'classe_id': int.parse(selectedClasseId!),
                'matiere_id': int.parse(selectedMatiereId!),
                'date_seance': dateCtrl.text,
                'heure_debut': debutCtrl.text,
                'heure_fin': finCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Affecter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
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
            return const Center(child: Text('Aucune séance'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: seances.length,
            itemBuilder: (context, index) {
              final s = seances[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.book),
                  ),
                  title: Text(s['matiere'] ?? ''),
                  subtitle: Text(
                    '${s['classe']} • ${s['enseignant']}\n'
                    '${s['date_seance']} | ${s['heure_debut']} - ${s['heure_fin']}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
