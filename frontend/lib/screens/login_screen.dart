import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'admin/admin_home.dart';
import 'enseignant/enseignant_home.dart';
import 'etudiant/etudiant_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Veuillez remplir tous les champs');
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await ApiService.login(email, password);

      if (result['success'] == 1) {
        final data = result['data'];
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt('user_id', data['id']);
        await prefs.setString('role', data['role']);
        await prefs.setString('nom', data['nom']);
        await prefs.setString('prenom', data['prenom']);

        if (!mounted) return;

        Widget home;
        switch (data['role']) {
          case 'admin':
            home = const AdminHome();
            break;
          case 'enseignant':
            home = const EnseignantHome();
            break;
          case 'etudiant':
            home = const EtudiantHome();
            break;
          default:
            _showError('Rôle inconnu');
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => home),
        );
      } else {
        _showError(result['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      _showError('Impossible de contacter le serveur');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Gestion Absence',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connectez-vous pour continuer',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 40),

              // Champ email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Champ mot de passe
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton connexion
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Se connecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
