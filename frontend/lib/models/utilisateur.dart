class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final int? enseignantId;
  final int? etudiantId;
  final int? classeId;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.enseignantId,
    this.etudiantId,
    this.classeId,
  });
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: json['role'],
      enseignantId: json['enseignant_id'] != null
          ? (json['enseignant_id'] is int
              ? json['enseignant_id']
              : int.parse(json['enseignant_id'].toString()))
          : null,
      etudiantId: json['etudiant_id'] != null
          ? (json['etudiant_id'] is int
              ? json['etudiant_id']
              : int.parse(json['etudiant_id'].toString()))
          : null,
      classeId: json['classe_id'] != null
          ? (json['classe_id'] is int
              ? json['classe_id']
              : int.parse(json['classe_id'].toString()))
          : null,
    );
  }
}
