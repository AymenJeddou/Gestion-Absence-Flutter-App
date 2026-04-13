<?php
include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $sql = "SELECT * FROM classes";
    $result = $conn->query($sql);

    $data = [];

    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode([
        "success" => 1,
        "data" => $data
    ]);

} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));

    if (!$data || !isset($data->nom)) {
        echo json_encode(["success" => 0, "message" => "Données manquantes"]);
        exit();
    }

    $nom = $conn->real_escape_string($data->nom);
    $niveau = isset($data->niveau) ? $conn->real_escape_string($data->niveau) : '';

    $sql = "INSERT INTO classes (nom, niveau)
            VALUES ('$nom', '$niveau')";

    if ($conn->query($sql)) {
        echo json_encode(["success" => 1, "message" => "Classe ajoutée avec succès"]);
    } else {
        echo json_encode(["success" => 0, "message" => "Erreur lors de l'ajout de la classe"]);
    }

} else {
    echo json_encode(["success" => 0, "message" => "Méthode non autorisée"]);
}
?>