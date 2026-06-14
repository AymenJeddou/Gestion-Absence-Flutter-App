<?php
include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));

    // Vérifier que les données sont présentes
    if (!$data || !isset($data->email) || !isset($data->password)) {
        echo json_encode(["success" => 0, "message" => "Email et mot de passe requis"]);
        exit();
    }

    $email = trim($data->email);
    $password = trim($data->password);

    $stmt = $conn->prepare("SELECT id, nom, prenom, email, role FROM utilisateurs WHERE email = ? AND password = ? LIMIT 1");
    if (!$stmt) {
        echo json_encode(["success" => 0, "message" => "Erreur lors de la préparation de la requête"]);
        exit();
    }

    $stmt->bind_param("ss", $email, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Préparer la réponse avec les infos de base
        $response = [
            "id" => (int) $user['id'],
            "nom" => $user['nom'],
            "prenom" => $user['prenom'],
            "email" => $user['email'],
            "role" => $user['role']
        ];

        // Ajouter l'ID spécifique au rôle (enseignant_id ou etudiant_id)
        if ($user['role'] == 'enseignant') {
            $res = $conn->query("SELECT id FROM enseignants WHERE utilisateur_id=" . $user['id']);
            if ($res->num_rows > 0) {
                $row = $res->fetch_assoc();
                $response['enseignant_id'] = (int) $row['id'];
            }
        } elseif ($user['role'] == 'etudiant') {
            $res = $conn->query("SELECT id, classe_id FROM etudiants WHERE utilisateur_id=" . $user['id']);
            if ($res->num_rows > 0) {
                $row = $res->fetch_assoc();
                $response['etudiant_id'] = (int) $row['id'];
                $response['classe_id'] = (int) $row['classe_id'];
            }
        }

        echo json_encode([
            "success" => 1,
            "data" => $response
        ]);
    } else {
        echo json_encode([
            "success" => 0,
            "message" => "Email ou mot de passe incorrect"
        ]);
    }

    $stmt->close();
} else {
    echo json_encode([
        "success" => 0,
        "message" => "Méthode non autorisée"
    ]);
}
?>