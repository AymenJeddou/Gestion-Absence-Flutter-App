import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Map<String, String> get _jsonHeaders => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getEtudiants({int? classeId}) async {
    String url = '$baseUrl/admin/etudiants.php';
    if (classeId != null) url += '?classe_id=$classeId';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addEtudiant(
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/etudiants.php'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateEtudiant(
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/etudiants.php'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteEtudiant(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/etudiants.php?id=$id'),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getEnseignants() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/enseignants.php'),
    );
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addEnseignant(
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/enseignants.php'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateEnseignant(
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/enseignants.php'),
      headers: _jsonHeaders,
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

  static Future<List<dynamic>> getClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/classes.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addClass(
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/classes.php'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getMatieres() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/matieres.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<List<dynamic>> getSeances() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/seances.php'));
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> addSeance(
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/seances.php'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getSeancesEnseignant(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/enseignant/seances.php?id=$userId'),
    );
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }

  static Future<Map<String, dynamic>> submitAppel(
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/enseignant/absences.php'),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getProfilEtudiant(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/etudiant/profil.php?id=$userId'),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getAbsencesEtudiant(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/etudiant/absences.php?id=$userId'),
    );
    final data = jsonDecode(response.body);
    return data['success'] == 1 ? data['data'] : [];
  }
}
