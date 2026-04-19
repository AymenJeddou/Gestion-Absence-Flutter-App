import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/seance.dart';
import '../../models/etudiant.dart';

class AppelScreen extends StatefulWidget {
  final Seance seance;

  const AppelScreen({super.key, required this.seance});

  @override
  State<AppelScreen> createState() => _AppelScreenState();
}

class _AppelScreenState extends State<AppelScreen> {
  List<Etudiant> _etudiants = [];
  final Map<int, bool> _presences = {};
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadEtudiants();
  }

  Future<void> _loadEtudiants() async {
    final data = await ApiService.getEtudiants(classeId: widget.seance.classeId);
    setState(() {
      _etudiants = data.map<Etudiant>((json) => Etudiant.fromJson(json)).toList();
      for (var e in _etudiants) {
        _presences[e.id] = true;
      }
      _loading = false;
    });
  }

  Future<void> _validerAppel() async {
    setState(() => _submitting = true);
    final absences = _etudiants.map((e) {
      return {
        'etudiant_id': e.id,
        'statut': _presences[e.id] == true ? 'present' : 'absent',
      };
    }).toList();

    final result = await ApiService.submitAppel({
      'seance_id': widget.seance.id,
      'absences': absences,
    });

    setState(() => _submitting = false);

    if (!mounted) return;

    if (result['success'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Appel enregistré avec succès !'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Erreur'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appel - ${widget.seance.matiere}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _etudiants.isEmpty
              ? const Center(child: Text('Aucun étudiant dans cette classe'))
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withAlpha(80),
                      child: Text(
                        '${widget.seance.classe} • ${widget.seance.dateSeance} • '
                        '${widget.seance.heureDebut} - ${widget.seance.heureFin}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _etudiants.length,
                        itemBuilder: (context, index) {
                          final e = _etudiants[index];
                          return CheckboxListTile(
                            title: Text('${e.nom} ${e.prenom}'),
                            subtitle: Text(_presences[e.id] == true
                                ? 'Présent'
                                : 'Absent'),
                            value: _presences[e.id],
                            onChanged: (val) {
                              setState(() => _presences[e.id] = val ?? false);
                            },
                            activeColor:
                                Theme.of(context).colorScheme.primary,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _submitting ? null : _validerAppel,
                          child: _submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Valider l'appel"),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
