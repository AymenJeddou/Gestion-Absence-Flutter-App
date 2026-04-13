<?php
include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));

    if (!$data || !isset($data->seance_id) || !isset($data->absences)) {
        echo json_encode(["success" => 0, "message" => "Données manquantes (seance_id et absences requis)"]);
        exit();
    }

    $seance_id = (int)$data->seance_id;
    $absences = $data->absences;

    $errors = 0;

    foreach ($absences as $a) {

        $etudiant_id = (int)$a->etudiant_id;
        $statut = $conn->real_escape_string($a->statut);

        $sql = "INSERT INTO absences (seance_id, etudiant_id, statut)
                VALUES ($seance_id, $etudiant_id, '$statut')
                ON DUPLICATE KEY UPDATE statut='$statut'";

        if (!$conn->query($sql)) {
            $errors++;
        }
    }

    if ($errors == 0) {
        echo json_encode(["success" => 1, "message" => "Appel enregistré avec succès"]);
    } else {
        echo json_encode(["success" => 0, "message" => "Certaines absences n'ont pas pu être enregistrées"]);
    }

} else {
    echo json_encode(["success" => 0, "message" => "Méthode non autorisée"]);
}
?>