import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/enseignant/enseignant_home.dart';
import 'screens/etudiant/etudiant_home.dart';

void main() {
  runApp(const GestAbsenceApp());
}

class GestAbsenceApp extends StatelessWidget {
  const GestAbsenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestAbsence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1565C0), // bleu foncé
        brightness: Brightness.light,
      ),
      home: const CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final userId = prefs.getInt('user_id');

    if (!mounted) return;

    if (role != null && userId != null) {
      // L'utilisateur est déjà connecté, rediriger selon le rôle
      Widget home;
      switch (role) {
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
          home = const LoginScreen();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => home),
      );
    } else {
      // Pas connecté, afficher l'écran de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écran de chargement pendant la vérification
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
