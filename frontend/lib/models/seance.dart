class Seance {
  final int id;
  final String matiere;
  final String classe;
  final String? enseignant;
  final int? classeId;
  final String dateSeance;
  final String heureDebut;
  final String heureFin;

  Seance({
    required this.id,
    required this.matiere,
    required this.classe,
    this.enseignant,
    this.classeId,
    required this.dateSeance,
    required this.heureDebut,
    required this.heureFin,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: int.parse(json['id'].toString()),
      matiere: json['matiere'] ?? '',
      classe: json['classe'] ?? '',
      enseignant: json['enseignant'],
      classeId: json['classe_id'] != null
          ? int.parse(json['classe_id'].toString())
          : null,
      dateSeance: json['date_seance'] ?? '',
      heureDebut: json['heure_debut'] ?? '',
      heureFin: json['heure_fin'] ?? '',
    );
  }
}
