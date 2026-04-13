import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class EnseignantsScreen extends StatefulWidget {
  const EnseignantsScreen({super.key});

  @override
  State<EnseignantsScreen> createState() => _EnseignantsScreenState();
}

class _EnseignantsScreenState extends State<EnseignantsScreen> {
  late Future<List<dynamic>> _futureEnseignants;

  @override
  void initState() {
    super.initState();
    _futureEnseignants = ApiService.getEnseignants();
  }

  void _refresh() {
    setState(() {
      _futureEnseignants = ApiService.getEnseignants();
    });
  }

  void _showAddDialog() {
    final nomCtrl = TextEditingController();
    final prenomCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final specCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un enseignant'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: prenomCtrl,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
              ),
              TextField(
                controller: specCtrl,
                decoration: const InputDecoration(labelText: 'Spécialité'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              if (nomCtrl.text.isEmpty || prenomCtrl.text.isEmpty ||
                  emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
                return;
              }
              await ApiService.addEnseignant({
                'nom': nomCtrl.text,
                'prenom': prenomCtrl.text,
                'email': emailCtrl.text,
                'password': passwordCtrl.text,
                'specialite': specCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> enseignant) {
    final nomCtrl = TextEditingController(text: enseignant['nom']);
    final prenomCtrl = TextEditingController(text: enseignant['prenom']);
    final emailCtrl = TextEditingController(text: enseignant['email']);
    final specCtrl = TextEditingController(text: enseignant['specialite']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Modifier l\'enseignant'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: prenomCtrl,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: specCtrl,
                decoration: const InputDecoration(labelText: 'Spécialité'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              await ApiService.updateEnseignant({
                'id': int.parse(enseignant['id'].toString()),
                'nom': nomCtrl.text,
                'prenom': prenomCtrl.text,
                'email': emailCtrl.text,
                'specialite': specCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _futureEnseignants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final enseignants = snapshot.data ?? [];

          if (enseignants.isEmpty) {
            return const Center(child: Text('Aucun enseignant'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: enseignants.length,
            itemBuilder: (context, index) {
              final e = enseignants[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(e['nom'][0].toUpperCase()),
                  ),
                  title: Text('${e['nom']} ${e['prenom']}'),
                  subtitle: Text(e['specialite'] ?? 'Pas de spécialité'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmer'),
                          content: const Text('Supprimer cet enseignant ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Non'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Oui'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ApiService.deleteEnseignant(
                          int.parse(e['id'].toString()),
                        );
                        _refresh();
                      }
                    },
                  ),
                  onTap: () => _showEditDialog(e),
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
