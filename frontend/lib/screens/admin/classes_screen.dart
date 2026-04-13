import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late Future<List<dynamic>> _futureClasses;

  @override
  void initState() {
    super.initState();
    _futureClasses = ApiService.getClasses();
  }

  void _refresh() {
    setState(() {
      _futureClasses = ApiService.getClasses();
    });
  }

  void _showAddDialog() {
    final nomCtrl = TextEditingController();
    final niveauCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter une classe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomCtrl,
              decoration: const InputDecoration(labelText: 'Nom de la classe'),
            ),
            TextField(
              controller: niveauCtrl,
              decoration: const InputDecoration(labelText: 'Niveau'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              if (nomCtrl.text.isEmpty) return;
              await ApiService.addClass({
                'nom': nomCtrl.text,
                'niveau': niveauCtrl.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _futureClasses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final classes = snapshot.data ?? [];

          if (classes.isEmpty) {
            return const Center(child: Text('Aucune classe'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final c = classes[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(c['nom'][0].toUpperCase()),
                  ),
                  title: Text(c['nom']),
                  subtitle: Text(c['niveau'] ?? ''),
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
