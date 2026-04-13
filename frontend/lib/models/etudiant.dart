class Etudiant {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String classe;
  final int classeId;
  final int utilisateurId;

  Etudiant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.classe,
    required this.classeId,
    required this.utilisateurId,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      classe: json['classe'] ?? '',
      classeId: int.parse((json['classe_id'] ?? '0').toString()),
      utilisateurId: int.parse((json['utilisateur_id'] ?? '0').toString()),
    );
  }
}
