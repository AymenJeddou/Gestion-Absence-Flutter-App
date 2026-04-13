import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // ==================== AUTH ====================

  /// Connexion : POST /auth/login.php
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // ==================== ADMIN - ETUDIANTS ====================

  /// Récupérer tous les étudiants (ou filtrer par classe)
  static Future<List<dynamic>> getEtudiants({int? classeId}) async {
    String url = '$baseUrl/admin/etudiants.php';
    if (classeId != null) url += '?classe_id=$classeId';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  /// Ajouter un étudiant
  static Future<Map<String, dynamic>> addEtudiant(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/etudiants.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  /// Modifier un étudiant
  static Future<Map<String, dynamic>> updateEtudiant(Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/etudiants.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  /// Supprimer un étudiant
  static Future<Map<String, dynamic>> deleteEtudiant(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/etudiants.php?id=$id'),
    );
    return jsonDecode(response.body);
  }

  // ==================== ADMIN - ENSEIGNANTS ====================

  static Future<List<dynamic>> getEnseignants() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/enseignants.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addEnseignant(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/enseignants.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateEnseignant(Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/enseignants.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteEnseignant(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/enseignants.php?id=$id'),
    );
    return jsonDecode(response.body);
  }

  // ==================== ADMIN - CLASSES ====================

  static Future<List<dynamic>> getClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/classes.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addClass(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/classes.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  // ==================== ADMIN - MATIERES ====================

  static Future<List<dynamic>> getMatieres() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/matieres.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  // ==================== ADMIN - SEANCES ====================

  static Future<List<dynamic>> getSeances() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/seances.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addSeance(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/seances.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  // ==================== ENSEIGNANT ====================

  /// Récupérer les séances d'un enseignant (par utilisateur_id)
  static Future<List<dynamic>> getSeancesEnseignant(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/enseignant/seances.php?id=$userId'),
    );
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  /// Soumettre l'appel (liste des présences/absences)
  static Future<Map<String, dynamic>> submitAppel(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/enseignant/absences.php'),
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  // ==================== ETUDIANT ====================

  /// Récupérer le profil d'un étudiant (par utilisateur_id)
  static Future<Map<String, dynamic>> getProfilEtudiant(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/etudiant/profil.php?id=$userId'),
    );
    return jsonDecode(response.body);
  }

  /// Récupérer les absences d'un étudiant (par utilisateur_id)
  static Future<List<dynamic>> getAbsencesEtudiant(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/etudiant/absences.php?id=$userId'),
    );
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }
}
